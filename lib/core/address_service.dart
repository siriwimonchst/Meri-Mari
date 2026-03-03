// lib/core/address_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/address_model.dart';

class AddressService {
  static const int maxAddresses = 5;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _addressesRef() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return _db.collection('users').doc(uid).collection('addresses');
  }

  /// Real-time stream of this user's addresses ordered by creation time
  Stream<List<AddressModel>> streamAddresses() {
    return _addressesRef()
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => AddressModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  /// Add a new address (throws if already at max)
  Future<void> addAddress(AddressModel address) async {
    final ref = _addressesRef();
    final snap = await ref.get();
    if (snap.docs.length >= maxAddresses) {
      throw Exception('คุณมีที่อยู่ครบ $maxAddresses รายการแล้ว');
    }

    final batch = _db.batch();

    // If new address is default → unset all current defaults first
    if (address.isDefault) {
      for (final doc in snap.docs) {
        if (doc.data()['isDefault'] == true) {
          batch.update(doc.reference, {'isDefault': false});
        }
      }
    }

    // If this is the first address, auto-set as default
    final isFirst = snap.docs.isEmpty;
    final newRef = ref.doc();
    batch.set(newRef, {
      ...address.toMap(),
      'isDefault': address.isDefault || isFirst,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  /// Update an existing address
  Future<void> updateAddress(AddressModel address) async {
    final ref = _addressesRef();
    final batch = _db.batch();

    if (address.isDefault) {
      // Unset other defaults
      final snap = await ref.get();
      for (final doc in snap.docs) {
        if (doc.id != address.id && doc.data()['isDefault'] == true) {
          batch.update(doc.reference, {'isDefault': false});
        }
      }
    }

    batch.update(ref.doc(address.id), address.toMap());
    await batch.commit();
  }

  /// Delete an address; if it was default, promote the next oldest as default
  Future<void> deleteAddress(String id) async {
    final ref = _addressesRef();
    final snap = await ref.get();
    final target = snap.docs.firstWhere((d) => d.id == id);
    final wasDefault = target.data()['isDefault'] == true;

    final batch = _db.batch();
    batch.delete(target.reference);

    if (wasDefault) {
      // promote oldest remaining address to default
      final remaining = snap.docs.where((d) => d.id != id).toList();
      if (remaining.isNotEmpty) {
        batch.update(remaining.first.reference, {'isDefault': true});
      }
    }

    await batch.commit();
  }

  /// Set an address as default (and unset all others)
  Future<void> setDefault(String id) async {
    final ref = _addressesRef();
    final snap = await ref.get();
    final batch = _db.batch();

    for (final doc in snap.docs) {
      final shouldBeDefault = doc.id == id;
      if ((doc.data()['isDefault'] == true) != shouldBeDefault) {
        batch.update(doc.reference, {'isDefault': shouldBeDefault});
      }
    }

    await batch.commit();
  }
}
