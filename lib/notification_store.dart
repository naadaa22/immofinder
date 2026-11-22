import 'package:flutter/foundation.dart';

@immutable
class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.iconColor,
    this.read = false,
  });

  final String id;
  final String title;
  final String description;
  final String time;
  final int icon;
  final int iconColor;
  final bool read;
}

class NotificationStore extends ChangeNotifier {
  NotificationStore._();

  static final instance = NotificationStore._();

  final List<AppNotification> _notifications = [
    AppNotification(
      id: '1',
      title: 'Nouveau message',
      description: 'Ahmed Ben Ali vous a envoyé un message.',
      time: 'À l\'instant',
      icon: 0xe0e1,
      iconColor: 0xFF4B2A8B,
    ),
    AppNotification(
      id: '2',
      title: 'Votre annonce est publiée',
      description: 'Votre bien est maintenant visible par les acheteurs.',
      time: 'Il y a 2 h',
      icon: 0xe14f,
      iconColor: 0xFF35AFA7,
      read: true,
    ),
  ];

  List<AppNotification> get notifications =>
      List<AppNotification>.of(_notifications);

  int get unreadCount => _notifications.where((item) => !item.read).length;

  void markAllRead() {
    for (var i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].read) {
        _notifications[i] = AppNotification(
          id: _notifications[i].id,
          title: _notifications[i].title,
          description: _notifications[i].description,
          time: _notifications[i].time,
          icon: _notifications[i].icon,
          iconColor: _notifications[i].iconColor,
          read: true,
        );
      }
    }
    notifyListeners();
  }
}
