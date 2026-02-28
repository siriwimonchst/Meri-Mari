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
  String _selectedCondition = 'All';

  // ─── Getters ─────────────────────────────────────────────────────────────
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCondition => _selectedCondition;

  List<ItemModel> get filteredItems {
    return _items.where((item) {
      final matchSearch = item.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final matchCondition =
          _selectedCondition == 'All' || item.condition == _selectedCondition;
      return matchSearch && matchCondition;
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

  void setCondition(String condition) {
    _selectedCondition = condition;
    notifyListeners();
  }
}
