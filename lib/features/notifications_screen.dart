// lib/features/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_locale_provider.dart';
import '../providers/notifications_provider.dart';
import '../models/notification_model.dart';
import '../core/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppLocaleProvider>().strings;
    final np = context.watch<NotificationsProvider>();
    final notifications = np.notifications;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: kText,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 4,
        title: Text(
          s.notifications,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: kText,
          ),
        ),
        actions: [
          if (notifications.isNotEmpty)
            TextButton(
              onPressed: () => np.markAllAsRead(),
              child: Text(
                s.isThai ? 'อ่านทั้งหมด' : 'Mark all read',
                style: const TextStyle(
                  color: kPurple,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState(s)
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: notifications.length,
                    separatorBuilder: (ctx, i) => Divider(
                      height: 1,
                      color: Colors.grey.shade100,
                      indent: 72,
                    ),
                    itemBuilder: (ctx, i) {
                      final n = notifications[i];
                      return _NotificationItem(notification: n, np: np);
                    },
                  ),
                ),
                if (notifications.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => np.clearAll(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          s.isThai ? 'ล้างการแจ้งเตือนทั้งหมด' : 'Clear all',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildEmptyState(dynamic s) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: kPurpleFaint,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 48,
              color: kPurpleLight,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            s.noNotifications,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: kText,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final AppNotification notification;
  final NotificationsProvider np;

  const _NotificationItem({required this.notification, required this.np});

  IconData _getTypeIcon() {
    switch (notification.type) {
      case NotificationType.order:
        return Icons.shopping_bag_outlined;
      case NotificationType.promo:
        return Icons.local_offer_outlined;
      case NotificationType.system:
        return Icons.notifications_none_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppLocaleProvider>().strings;
    final timeStr = _formatTimestamp(notification.timestamp);
    
    // Choose the correctly localized strings
    final title   = s.isThai ? notification.titleTh : notification.titleEn;
    final message = s.isThai ? notification.messageTh : notification.messageEn;

    return InkWell(
      onTap: () {
        if (!notification.isRead) {
          np.markAsRead(notification.id);
        }
      },
      child: Container(
        color: notification.isRead ? Colors.transparent : kPurpleFaint.withOpacity(0.3),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: notification.isRead ? kPurpleFaint : kPurpleLight.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getTypeIcon(),
                color: kPurple,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.w800,
                            color: kText,
                          ),
                        ),
                      ),
                      Text(
                        timeStr,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.4,
                      fontWeight: notification.isRead ? FontWeight.w400 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inSeconds < 60) return 'ตอนนี้';
    if (diff.inMinutes < 60) return '${diff.inMinutes}น.';
    if (diff.inHours < 24) return '${diff.inHours}ชม.';
    return '${dt.day}/${dt.month}';
  }
}
