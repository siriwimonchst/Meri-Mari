// lib/providers/favorites_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/item_model.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favoriteIds = {};
  List<ItemModel> _favoriteItems = [];

  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);
  List<ItemModel> get favoriteItems => List.unmodifiable(_favoriteItems);

  bool isFavorite(String id) => _favoriteIds.contains(id);

  CollectionReference<Map<String, dynamic>>? _ref() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favorites');
  }

  Future<void> loadFavorites() async {
    final ref = _ref();
    if (ref == null) return;
    final snap = await ref.get();
    _favoriteIds.clear();
    _favoriteItems.clear();
    for (final doc in snap.docs) {
      _favoriteIds.add(doc.id);
      _favoriteItems.add(ItemModel.fromMap(doc.id, doc.data()));
    }
    notifyListeners();
  }

  Future<void> toggleFavorite(ItemModel item) async {
    final ref = _ref();
    if (ref == null) return;

    if (_favoriteIds.contains(item.id)) {
      // Remove
      _favoriteIds.remove(item.id);
      _favoriteItems.removeWhere((i) => i.id == item.id);
      notifyListeners();
      await ref.doc(item.id).delete();
    } else {
      // Add
      _favoriteIds.add(item.id);
      _favoriteItems.add(item);
      notifyListeners();
      await ref.doc(item.id).set(item.toMap());
    }
  }

  Future<void> removeMultiple(List<String> ids) async {
    final ref = _ref();
    if (ref == null) return;

    // Local update
    _favoriteIds.removeAll(ids);
    _favoriteItems.removeWhere((i) => ids.contains(i.id));
    notifyListeners();

    // Firestore update (using batch)
    final batch = FirebaseFirestore.instance.batch();
    for (final id in ids) {
      batch.delete(ref.doc(id));
    }
    await batch.commit();
  }

  /// Call on logout to clear local state
  void clear() {
    _favoriteIds.clear();
    _favoriteItems.clear();
    notifyListeners();
  }
}
