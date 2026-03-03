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
      final matchSearch = item.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
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
