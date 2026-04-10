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
  List<ItemModel> get allItems => _items;

  List<ItemModel> get filteredItems {
    return _items.where((item) {
      final queryRaw = _searchQuery.toLowerCase();
      final queryCanonical = _toCanonicalKey(queryRaw);
      final matchSearch =
          item.name.toLowerCase().contains(queryRaw) ||
          item.collection.toLowerCase().contains(queryRaw) ||
          item.tags.any((tag) => tag.toLowerCase().contains(queryRaw)) ||
          item.tags.any((tag) => _toCanonicalKey(tag).contains(queryCanonical));
      // Normalize item tags to canonical keys before matching
      final matchTags =
          _selectedTags.isEmpty ||
          _selectedTags.every((sTag) =>
              item.tags.any((iTag) => _toCanonicalKey(iTag) == sTag));
      return matchSearch && matchTags;
    }).toList();
  }

  /// Converts any raw tag value (Thai, English, legacy) to a stable canonical key.
  /// Mirrors the logic in AppStrings.tagLabel() but returns keys instead of labels.
  static String _toCanonicalKey(String raw) {
    final t = raw.trim().toLowerCase();
    switch (t) {
      case 'no_defect':
      case 'no defect':
      case 'nodefect':
      case '\u0e44\u0e21\u0e48\u0e21\u0e35\u0e15\u0e33\u0e2b\u0e19\u0e34':
        return 'no_defect';

      case 'brand_new':
      case 'brand new':
      case 'brandnew':
      case 'new':
      case '\u0e21\u0e37\u0e2d 1':
      case '\u0e21\u0e37\u0e2d1':
        return 'brand_new';

      case 'pre_owned':
      case 'pre-owned':
      case 'pre owned':
      case 'preowned':
      case 'used':
      case '\u0e21\u0e37\u0e2d 2':
      case '\u0e21\u0e37\u0e2d2':
        return 'pre_owned';

      case 'misb':
        return 'misb';

      case 'check_card':
      case 'check card':
      case 'checkcard':
      case 'check-card':
      case 'เช็คการ์ด':
      case '\u0e40\u0e0a\u0e47\u0e04\u0e01\u0e32\u0e23\u0e14':
        return 'check_card';

      case 'limited':
      case 'limited edition':
      case 'ลิมิเต็ด':
        return 'limited';

      case 'secret':
      case 'secret rare':
      case 'ซีเคร็ท':
        return 'secret';

      default:
        return t; // catch-all
    }
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
        // Seed a Thai-named item
        await _db.collection('items').add({
          'name': 'Molly สีพาสเทล รุ่นพิเศษ',
          'collection': 'Molly',
          'price': 1200.0,
          'imageUrls': [
            'https://firebasestorage.googleapis.com/v0/b/meri-mari.appspot.com/o/molly_mock.jpg?alt=media',
          ],
          'tags': ['เช็คการ์ด', 'มือ 1'],
          'shippingCost': 60.0,
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
