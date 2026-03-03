// lib/providers/item_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item_model.dart';

class ItemProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<ItemModel> _items = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';
  Set<String> _selectedTags = {};

  // ─── Getters ─────────────────────────────────────────────────────────────
  bool get isLoading => _isLoading;
  String? get error => _error;
  Set<String> get selectedTags => _selectedTags;

  List<ItemModel> get filteredItems {
    return _items.where((item) {
      final query = _searchQuery.toLowerCase();
      final matchSearch =
          item.name.toLowerCase().contains(query) ||
          item.collection.toLowerCase().contains(query);
      // If no tags selected, show all. Otherwise item must have at least one matching tag.
      final matchTags =
          _selectedTags.isEmpty ||
          item.tags.any((t) => _selectedTags.contains(t));
      return matchSearch && matchTags;
    }).toList();
  }

  // ─── Constructor: เริ่ม listen Firestore ─────────────────────────────────
  ItemProvider() {
    _listenToItems();
    _seedDimoo();
  }

  /// Check if a Dimoo item exists. If not, seed a mock one to Firestore.
  Future<void> _seedDimoo() async {
    try {
      final snap = await _db
          .collection('items')
          .where('name', isGreaterThanOrEqualTo: 'Dimoo')
          .where('name', isLessThan: 'Dimop')
          .get();
      if (snap.docs.isEmpty) {
        await _db.collection('items').add({
          'name': 'Dimoo - Finding unicorns',
          'collection': 'Dimoo',
          'price': 450.0,
          'imageUrls': [
            'https://firebasestorage.googleapis.com/v0/b/meri-mari.appspot.com/o/dimoo_mock.jpg?alt=media',
          ],
          'tags': ['มือ 1', 'แบบสุ่ม'],
          'shippingCost': 50.0,
        });
      }
    } catch (e) {
      debugPrint('Error seeding Dimoo: $e');
    }
  }

  /// Subscribe realtime stream จาก Firestore collection 'items'
  void _listenToItems() {
    _db
        .collection('items')
        .snapshots()
        .listen(
          (snapshot) {
            _items = snapshot.docs.map(ItemModel.fromFirestore).toList();
            _isLoading = false;
            _error = null;
            notifyListeners();
          },
          onError: (e) {
            _error = 'โหลดข้อมูลไม่สำเร็จ: $e';
            _isLoading = false;
            notifyListeners();
          },
        );
  }

  // ─── Filters ─────────────────────────────────────────────────────────────
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleTag(String tag) {
    if (_selectedTags.contains(tag)) {
      _selectedTags = {..._selectedTags}..remove(tag);
    } else {
      _selectedTags = {..._selectedTags, tag};
    }
    notifyListeners();
  }

  void clearTags() {
    _selectedTags = {};
    notifyListeners();
  }

  void setTags(Set<String> tags) {
    _selectedTags = tags;
    notifyListeners();
  }
}
