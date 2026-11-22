import 'package:flutter/material.dart';

import '../notification_store.dart';

const _purple = Color(0xFF4B2A8B);

IconData _notificationIcon(int code) {
  switch (code) {
    case 0xe0e1:
      return Icons.chat_bubble_outline;
    case 0xe14f:
      return Icons.home_work_outlined;
    default:
      return Icons.notifications_none;
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF8F7FC),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: NotificationStore.instance.markAllRead,
            child: const Text(
              'Tout lire',
              style: TextStyle(color: _purple, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: NotificationStore.instance,
        builder: (context, _) {
          final notifications = NotificationStore.instance.notifications;
          if (notifications.isEmpty) {
            return const Center(child: Text('Aucune notification'));
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              for (final notification in notifications)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: notification.read
                        ? Colors.white
                        : const Color(0xFFF1ECFA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: notification.read
                          ? const Color(0xFFECE8F3)
                          : const Color(0xFFDCD1F2),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(notification.iconColor)
                          .withValues(alpha: 0.12),
                      child: Icon(
                        _notificationIcon(notification.icon),
                        color: Color(notification.iconColor),
                      ),
                    ),
                    title: Text(
                      notification.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.description,
                            style: const TextStyle(
                              color: Color(0xFF6F6C74),
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            notification.time,
                            style: const TextStyle(
                              color: Color(0xFF9A969F),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
