// lib/providers/notifications_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model.dart';

class NotificationsProvider extends ChangeNotifier {
  static const _prefsKey = 'mrmr_notifications';

  final List<AppNotification> _notifications = [];
  bool _loaded = false;

  NotificationsProvider() {
    _load();
  }

  List<AppNotification> get notifications => List.unmodifiable(_notifications.reversed);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  // ── Persistence ──────────────────────────────────────────────────────────

  Future<void> _load() async {
    if (_loaded) return;
    _loaded = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      
      if (raw == null) {
        // Initial mock notifications for a better demo feel
        _addMockInitialNotifications();
        return;
      }

      final list = jsonDecode(raw) as List<dynamic>;
      _notifications.clear();
      for (final j in list) {
        _notifications.add(AppNotification.fromMap(j as Map<String, dynamic>));
      }
      notifyListeners();
    } catch (e) {
      debugPrint('[NotificationsProvider] _load error: $e');
    }
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_notifications.map((n) => n.toMap()).toList());
      await prefs.setString(_prefsKey, encoded);
    } catch (e) {
      debugPrint('[NotificationsProvider] _save error: $e');
    }
  }

  // ── Mutations ────────────────────────────────────────────────────────────

  void addNotification({
    required String titleTh,
    required String titleEn,
    required String messageTh,
    required String messageEn,
    NotificationType type = NotificationType.system,
    String? orderId,
  }) {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titleTh: titleTh,
      titleEn: titleEn,
      messageTh: messageTh,
      messageEn: messageEn,
      timestamp: DateTime.now(),
      type: type,
      orderId: orderId,
    );
    _notifications.add(notification);
    notifyListeners();
    _save();
  }

  void markAsRead(String id) {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _notifications[idx].isRead = true;
      notifyListeners();
      _save();
    }
  }

  void markAllAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
    _save();
  }

  void removeNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
    _save();
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
    _save();
  }

  void _addMockInitialNotifications() {
    _notifications.addAll([
      AppNotification(
        id: 'welcome',
        titleTh: 'ยินดีต้อนรับสู่ Meri-Mari!',
        titleEn: 'Welcome to Meri-Mari!',
        messageTh: 'ขอบคุณที่เข้าร่วมกับเรา เริ่มต้นสั่งซื้อสินค้าที่คุณชื่นชอบได้เลยตอนนี้',
        messageEn: 'Thank you for joining us! Start shopping your favorite items now.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        type: NotificationType.system,
      ),
    ]);
    notifyListeners();
    _save();
  }
}
