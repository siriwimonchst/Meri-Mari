// lib/models/notification_model.dart

enum NotificationType { order, promo, system }

class AppNotification {
  final String id;
  final String titleTh;
  final String titleEn;
  final String messageTh;
  final String messageEn;
  final DateTime timestamp;
  bool isRead;
  final NotificationType type;
  final String? orderId;

  AppNotification({
    required this.id,
    required this.titleTh,
    required this.titleEn,
    required this.messageTh,
    required this.messageEn,
    required this.timestamp,
    this.isRead = false,
    this.type = NotificationType.system,
    this.orderId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titleTh': titleTh,
      'titleEn': titleEn,
      'messageTh': messageTh,
      'messageEn': messageEn,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'type': type.name,
      'orderId': orderId,
    };
  }

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    // Handling backward compatibility
    final title   = map['title']   as String?;
    final message = map['message'] as String?;

    return AppNotification(
      id: map['id'] ?? '',
      titleTh: map['titleTh'] ?? title   ?? '',
      titleEn: map['titleEn'] ?? title   ?? '',
      messageTh: map['messageTh'] ?? message ?? '',
      messageEn: map['messageEn'] ?? message ?? '',
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      isRead: map['isRead'] ?? false,
      type: NotificationType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => NotificationType.system,
      ),
      orderId: map['orderId'],
    );
  }
}
