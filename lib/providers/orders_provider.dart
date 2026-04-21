// lib/providers/orders_provider.dart
// ─── Order State + Firestore Persistence ──────────────────────────────────────
// Orders are saved to `users/{uid}/orders` so they survive app restarts.
// Auth-state changes trigger automatic reload — logging out clears local state.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'notifications_provider.dart';
import '../models/notification_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data models
// ─────────────────────────────────────────────────────────────────────────────

enum OrderTab { toPay, toShip, toReceive, toRate }

extension OrderTabJson on OrderTab {
  String toJson() => name; // 'toPay', 'toShip', …
  static OrderTab fromJson(String s) =>
      OrderTab.values.firstWhere((e) => e.name == s, orElse: () => OrderTab.toPay);
}

class OrderItem {
  final String itemId;
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

  Map<String, dynamic> toMap() => {
        'itemId':   itemId,
        'name':     name,
        'price':    price,
        'imageUrl': imageUrl,
        'quantity': quantity,
      };

  factory OrderItem.fromMap(Map<String, dynamic> m) => OrderItem(
        itemId:   (m['itemId'] as String?) ?? '',
        name:     (m['name'] as String?) ?? '',
        price:    (m['price'] as num?)?.toDouble() ?? 0,
        imageUrl: (m['imageUrl'] as String?) ?? '',
        quantity: (m['quantity'] as int?) ?? 1,
      );
}

class AppOrder {
  final String id;
  final List<OrderItem> items;
  final double total;
  final DateTime createdAt;
  OrderTab tab;
  bool hasSlip;

  AppOrder({
    required this.id,
    required this.items,
    required this.total,
    required this.createdAt,
    this.tab = OrderTab.toPay,
    this.hasSlip = false,
  });

  Duration get timeRemaining {
    final deadline = createdAt.add(const Duration(hours: 24));
    final remaining = deadline.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  bool get isExpired => timeRemaining == Duration.zero;

  Map<String, dynamic> toMap() => {
        'id':        id,
        'items':     items.map((i) => i.toMap()).toList(),
        'total':     total,
        'createdAt': Timestamp.fromDate(createdAt),
        'tab':       tab.name,
        'hasSlip':   hasSlip,
      };

  factory AppOrder.fromMap(Map<String, dynamic> m) {
    final rawItems = m['items'];
    final List<OrderItem> parsedItems = rawItems is List
        ? rawItems
            .map((e) => OrderItem.fromMap(Map<String, dynamic>.from(e as Map)))
            .toList()
        : [];

    DateTime created;
    final ts = m['createdAt'];
    if (ts is Timestamp) {
      created = ts.toDate();
    } else {
      created = DateTime.now();
    }

    return AppOrder(
      id:        (m['id'] as String?) ?? '',
      items:     parsedItems,
      total:     (m['total'] as num?)?.toDouble() ?? 0,
      createdAt: created,
      tab:       OrderTabJson.fromJson((m['tab'] as String?) ?? 'toPay'),
      hasSlip:   (m['hasSlip'] as bool?) ?? false,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Provider
// ─────────────────────────────────────────────────────────────────────────────

class OrdersProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final List<AppOrder> _orders = [];
  final Set<String> _orderedItemIds = {};

  /// Monotonically-increasing suffix for local order IDs within a session.
  int _nextLocalSeq = 1;

  List<AppOrder> get orders => List.unmodifiable(_orders);

  List<AppOrder> ordersForTab(OrderTab tab) =>
      _orders.where((o) => o.tab == tab).toList();

  bool isOrdered(String itemId) => _orderedItemIds.contains(itemId);

  // ── Firestore helpers ───────────────────────────────────────────────────────

  /// Returns the Firestore collection for the current user's orders.
  /// Throws [StateError] when no user is signed in.
  CollectionReference<Map<String, dynamic>> _ordersRef() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw StateError('No authenticated user');
    return _db.collection('users').doc(uid).collection('orders');
  }

  // ── Initialisation ──────────────────────────────────────────────────────────

  OrdersProvider() {
    // Reload orders whenever auth state changes.
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        _clearLocalState();
      } else {
        _loadOrders();
      }
    });
  }

  void _clearLocalState() {
    _orders.clear();
    _orderedItemIds.clear();
    notifyListeners();
  }

  /// Fetches all orders from Firestore for the signed-in user.
  Future<void> _loadOrders() async {
    try {
      final snap = await _ordersRef()
          .orderBy('createdAt', descending: false)
          .get();

      _orders.clear();
      _orderedItemIds.clear();

      for (final doc in snap.docs) {
        final order = AppOrder.fromMap(doc.data());
        _orders.add(order);
        for (final item in order.items) {
          _orderedItemIds.add(item.itemId);
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint('[OrdersProvider] _loadOrders error: $e');
    }
  }

  // ── Public mutations ────────────────────────────────────────────────────────

  /// Place all cart items as a single new order and persist to Firestore.
  Future<void> placeOrders({
    required List<Map<String, dynamic>> items,
    required OrderTab tab,
    required NotificationsProvider np,
    bool hasSlip = false,
    String? customTitleTh,
    String? customTitleEn,
    String? customMsgTh,
    String? customMsgEn,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    final orderItems = items
        .map(
          (i) => OrderItem(
            itemId:   (i['itemId'] as String?) ?? '',
            name:     i['name'] as String,
            price:    (i['price'] as num).toDouble(),
            imageUrl: i['imageUrl'] as String? ?? '',
            quantity: (i['qty'] as int?) ?? 1,
          ),
        )
        .toList();

    final total = orderItems.fold<double>(
      0,
      (acc, i) => acc + i.price * i.quantity,
    );

    // Generate order ID — use Firestore doc-id when persisting, local id otherwise.
    final localId = 'MRMR-${_nextLocalSeq.toString().padLeft(3, '0')}';
    _nextLocalSeq++;

    final order = AppOrder(
      id:        localId,
      items:     orderItems,
      total:     total,
      createdAt: DateTime.now(),
      tab:       tab,
      hasSlip:   hasSlip,
    );

    _orders.add(order);
    for (final i in orderItems) {
      _orderedItemIds.add(i.itemId);
    }
    notifyListeners();

    // Trigger notification
    np.addNotification(
      titleTh: customTitleTh ?? 'สั่งซื้อสินค้าสำเร็จ!',
      titleEn: customTitleEn ?? 'Order Placed!',
      messageTh: customMsgTh ?? 'สร้างออเดอร์หมายเลข ${order.id} เรียบร้อยแล้ว ยอดชำระ ${order.total} บาท',
      messageEn: customMsgEn ?? 'Order ID ${order.id} has been created. Total amount is ${order.total} THB',
      type: NotificationType.order,
      orderId: order.id,
    );

    // Persist to Firestore (best-effort — local state is source of truth in session).
    if (uid != null) {
      try {
        await _ordersRef().doc(localId).set(order.toMap());
      } catch (e) {
        debugPrint('[OrdersProvider] placeOrders persist error: $e');
      }
    }
  }

  /// Mark that a payment slip has been uploaded for [orderId].
  Future<void> markSlipUploaded(String orderId, NotificationsProvider np) async {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx == -1) return;
    _orders[idx].hasSlip = true;
    notifyListeners();
    _updateField(orderId, {'hasSlip': true});

    // Trigger notification (Mock verification)
    np.addNotification(
      titleTh: 'อัปเดตสถานะการชำระเงิน',
      titleEn: 'Payment Status Update',
      messageTh: 'ได้รับสลิปการโอนเงินของออเดอร์หมายเลข $orderId แล้ว ระบบกำลังตรวจสอบข้อมูล',
      messageEn: 'Transfer slip for Order ID $orderId received. System is verifying.',
      type: NotificationType.order,
      orderId: orderId,
    );
  }

  /// Cancel and remove an order.
  Future<void> cancelOrder(String orderId, NotificationsProvider? np) async {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx == -1) return;

    final order = _orders.removeAt(idx);
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

    // Trigger notification
    np?.addNotification(
      titleTh: 'ยกเลิกออเดอร์สำเร็จ',
      titleEn: 'Order Cancelled',
      messageTh: 'ออเดอร์หมายเลข $orderId ของคุณถูกยกเลิกเรียบร้อยแล้ว',
      messageEn: 'Your order ID $orderId has been cancelled.',
      type: NotificationType.order,
      orderId: orderId,
    );

    try {
      await _ordersRef().doc(orderId).delete();
    } catch (e) {
      debugPrint('[OrdersProvider] cancelOrder delete error: $e');
    }
  }

  /// Move an order to a different status tab.
  Future<void> moveOrder(String id, OrderTab newTab) async {
    final idx = _orders.indexWhere((o) => o.id == id);
    if (idx == -1) return;
    _orders[idx].tab = newTab;
    notifyListeners();
    _updateField(id, {'tab': newTab.name});
  }

  // ── Internal helpers ────────────────────────────────────────────────────────

  Future<void> _updateField(String orderId, Map<String, dynamic> data) async {
    try {
      await _ordersRef().doc(orderId).update(data);
    } catch (e) {
      debugPrint('[OrdersProvider] _updateField error ($orderId): $e');
    }
  }
}
