// lib/providers/orders_provider.dart
import 'package:flutter/material.dart';

enum OrderTab { toPay, toShip, toReceive, toRate }

class OrderItem {
  final String itemId; // Firestore item document ID
  final String name;
  final double price;
  final String imageUrl;
  final int quantity;

  const OrderItem({
    required this.itemId,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });
}

class AppOrder {
  final String id;
  final List<OrderItem> items;
  final double total;
  final DateTime createdAt;
  OrderTab tab;

  AppOrder({
    required this.id,
    required this.items,
    required this.total,
    required this.createdAt,
    this.tab = OrderTab.toPay,
  });

  Duration get timeRemaining {
    final deadline = createdAt.add(const Duration(hours: 24));
    final remaining = deadline.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  bool get isExpired => timeRemaining == Duration.zero;
}

class OrdersProvider extends ChangeNotifier {
  final List<AppOrder> _orders = [];
  // Set of Firestore item IDs that are currently in any active order
  final Set<String> _orderedItemIds = {};
  int _nextId = 1;

  List<AppOrder> get orders => List.unmodifiable(_orders);

  List<AppOrder> ordersForTab(OrderTab tab) =>
      _orders.where((o) => o.tab == tab).toList();

  /// Returns true if this item is in an existing active order.
  bool isOrdered(String itemId) => _orderedItemIds.contains(itemId);

  /// Place all cart items together as a single order.
  void placeOrders({
    required List<Map<String, dynamic>> items,
    required OrderTab tab,
  }) {
    final orderItems = items
        .map(
          (i) => OrderItem(
            itemId: (i['itemId'] as String?) ?? '',
            name: i['name'] as String,
            price: (i['price'] as num).toDouble(),
            imageUrl: i['imageUrl'] as String? ?? '',
            quantity: (i['qty'] as int?) ?? 1,
          ),
        )
        .toList();

    final total = orderItems.fold<double>(
      0,
      (sum, i) => sum + i.price * i.quantity,
    );

    _orders.add(
      AppOrder(
        id: 'MRMR-${_nextId.toString().padLeft(3, '0')}',
        items: orderItems,
        total: total,
        createdAt: DateTime.now(),
        tab: tab,
      ),
    );
    _nextId++;

    // Mark every item as ordered
    for (final i in orderItems) {
      _orderedItemIds.add(i.itemId);
    }
    notifyListeners();
  }

  /// Cancel and remove an order, freeing its items.
  void cancelOrder(String orderId) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx == -1) return;
    final order = _orders[idx];
    _orders.removeAt(idx);
    // Free items — only if not still referenced by another active order
    final stillOrdered = <String>{
      for (final o in _orders)
        for (final i in o.items) i.itemId,
    };
    for (final i in order.items) {
      if (!stillOrdered.contains(i.itemId)) {
        _orderedItemIds.remove(i.itemId);
      }
    }
    notifyListeners();
  }

  /// Move order between tabs (e.g. toPay → toShip after payment verified).
  void moveOrder(String id, OrderTab newTab) {
    final idx = _orders.indexWhere((o) => o.id == id);
    if (idx != -1) {
      _orders[idx].tab = newTab;
      notifyListeners();
    }
  }
}
