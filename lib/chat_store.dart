import 'package:flutter/foundation.dart';

import 'user_profile_store.dart';

@immutable
class ChatMessage {
  const ChatMessage({
    required this.senderId,
    required this.text,
    required this.time,
  });

  final String senderId;
  final String text;
  final String time;
}

@immutable
class Conversation {
  const Conversation({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    required this.property,
    required this.avatarColor,
    required this.initials,
    required this.messages,
  });

  final String id;
  final String otherUserId;
  final String otherUserName;
  final String property;
  final int avatarColor;
  final String initials;
  final List<ChatMessage> messages;
}

class ChatStore extends ChangeNotifier {
  ChatStore._();

  static final instance = ChatStore._();

  final Map<String, Conversation> _conversations = {};
  final Map<String, int> _unread = {};

  String get _currentUserId =>
      UserProfileStore.instance.current?.email.trim().toLowerCase() ??
      'utilisateur';

  String _threadId(String otherUserId) {
    final users = [_currentUserId, otherUserId]..sort();
    return users.join('__');
  }

  List<Conversation> get conversations => _conversations.values.toList();

  int unreadCount(String conversationId) => _unread[conversationId] ?? 0;

  Conversation openConversation({
    required String otherUserId,
    required String otherUserName,
    required String property,
  }) {
    final id = _threadId(otherUserId);
    final existing = _conversations[id];
    if (existing != null) {
      _unread[id] = 0;
      final updated = Conversation(
        id: existing.id,
        otherUserId: existing.otherUserId,
        otherUserName: otherUserName,
        property: property,
        avatarColor: existing.avatarColor,
        initials: _initials(otherUserName),
        messages: existing.messages,
      );
      _conversations[id] = updated;
      notifyListeners();
      return updated;
    }

    final conversation = Conversation(
      id: id,
      otherUserId: otherUserId,
      otherUserName: otherUserName,
      property: property,
      avatarColor: 0xFFE9E2F8,
      initials: _initials(otherUserName),
      messages: const [],
    );
    _conversations[id] = conversation;
    notifyListeners();
    return conversation;
  }

  void sendMessage({required String conversationId, required String text}) {
    final conversation = _conversations[conversationId];
    if (conversation == null || text.trim().isEmpty) return;

    final messages = List<ChatMessage>.of(conversation.messages)
      ..add(
        ChatMessage(
          senderId: _currentUserId,
          text: text.trim(),
          time: _formatTime(DateTime.now()),
        ),
      );
    _conversations[conversationId] = Conversation(
      id: conversation.id,
      otherUserId: conversation.otherUserId,
      otherUserName: conversation.otherUserName,
      property: conversation.property,
      avatarColor: conversation.avatarColor,
      initials: conversation.initials,
      messages: messages,
    );
    notifyListeners();
  }

  String _formatTime(DateTime time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
