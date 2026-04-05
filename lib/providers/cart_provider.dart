// lib/providers/cart_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item_model.dart';

class CartItem {
  final ItemModel item;
  int quantity;

  CartItem({required this.item, this.quantity = 1});

  Map<String, dynamic> toJson() => {
    'item': item.toMap()..['id'] = item.id,
    'quantity': quantity,
    'selectedByDefault': true,
  };

  static CartItem fromJson(Map<String, dynamic> json) {
    final itemData = Map<String, dynamic>.from(json['item'] as Map);
    final id = itemData.remove('id') as String? ?? '';
    return CartItem(
      item: ItemModel.fromMap(id, itemData),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );
  }
}

class CartProvider extends ChangeNotifier {
  static const _prefsKey = 'meri_mari_cart';

  final List<CartItem> _items = [];
  final Set<String> _selectedIds = {};
  bool _loaded = false;

  CartProvider() {
    _load();
  }

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalCount => _items.fold(0, (sum, ci) => sum + ci.quantity);

  double get subtotal =>
      _items.fold(0.0, (sum, ci) => sum + ci.item.price * ci.quantity);

  double get selectedSubtotal => _items
      .where((ci) => _selectedIds.contains(ci.item.id))
      .fold(0.0, (sum, ci) => sum + ci.item.price * ci.quantity);

  /// Sum of shippingCost for each selected item (× quantity)
  double get selectedShipping => _items
      .where((ci) => _selectedIds.contains(ci.item.id))
      .fold(0.0, (sum, ci) => sum + ci.item.shippingCost * ci.quantity);

  bool isSelected(String id) => _selectedIds.contains(id);

  bool get allSelected =>
      _items.isNotEmpty &&
      _items.every((ci) => _selectedIds.contains(ci.item.id));

  bool get anySelected => _selectedIds.isNotEmpty;

  Set<String> get selectedIds => Set.unmodifiable(_selectedIds);

  bool containsItem(String id) => _items.any((ci) => ci.item.id == id);

  // ── Persistence ──────────────────────────────────────────────────────────

  Future<void> _load() async {
    if (_loaded) return;
    _loaded = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw == null) return;
      final list = jsonDecode(raw) as List<dynamic>;
      for (final j in list) {
        final ci = CartItem.fromJson(j as Map<String, dynamic>);
        _items.add(ci);
        _selectedIds.add(ci.item.id); // restore as selected
      }
      notifyListeners();
    } catch (_) {
      // corrupted data — ignore silently
    }
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_items.map((ci) => ci.toJson()).toList());
      await prefs.setString(_prefsKey, encoded);
    } catch (_) {}
  }

  // ── Mutations ────────────────────────────────────────────────────────────

  bool addItem(ItemModel item) {
    if (containsItem(item.id)) return false;
    _items.add(CartItem(item: item));
    _selectedIds.add(item.id); // auto-select new items
    notifyListeners();
    _save();
    return true;
  }

  void toggleSelected(String id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
    notifyListeners();
  }

  void selectAll() {
    _selectedIds.addAll(_items.map((ci) => ci.item.id));
    notifyListeners();
  }

  void deselectAll() {
    _selectedIds.clear();
    notifyListeners();
  }


  void removeItem(String id) {
    _selectedIds.remove(id);
    _items.removeWhere((ci) => ci.item.id == id);
    notifyListeners();
    _save();
  }

  void clear() {
    _items.clear();
    _selectedIds.clear();
    notifyListeners();
    _save();
  }
}
