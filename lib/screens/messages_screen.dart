import 'package:flutter/material.dart';

import '../chat_store.dart';
import '../user_profile_store.dart';

const _purple = Color(0xFF4B2A8B);

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  static void openConversation(
    BuildContext context, {
    required String otherUserId,
    required String otherUserName,
    required String property,
  }) {
    final conversation = ChatStore.instance.openConversation(
      otherUserId: otherUserId,
      otherUserName: otherUserName,
      property: property,
    );
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _ConversationScreen(conversationId: conversation.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF8F7FC),
        elevation: 0,
      ),
      body: AnimatedBuilder(
        animation: ChatStore.instance,
        builder: (context, _) {
          final conversations = ChatStore.instance.conversations;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            children: [
              const Text(
                'Vos conversations',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Touchez une conversation pour répondre.',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              if (conversations.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: Center(child: Text('Aucune conversation')),
                ),
              for (final conversation in conversations)
                _ConversationTile(conversation: conversation),
            ],
          );
        },
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({required this.conversation});

  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    final lastMessage = conversation.messages.isEmpty
        ? 'Nouvelle conversation'
        : conversation.messages.last.text;
    final unread = ChatStore.instance.unreadCount(conversation.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFECE8F3)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Color(conversation.avatarColor),
          child: Text(
            conversation.initials,
            style: const TextStyle(color: _purple, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          conversation.otherUserName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                conversation.property,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _purple,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 3),
              Text(lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        trailing: unread > 0
            ? CircleAvatar(
                radius: 10,
                backgroundColor: _purple,
                child: Text(
                  '$unread',
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              )
            : const Icon(Icons.chevron_right, color: Colors.black38, size: 20),
        onTap: () {
          final refreshed = ChatStore.instance.openConversation(
            otherUserId: conversation.otherUserId,
            otherUserName: conversation.otherUserName,
            property: conversation.property,
          );
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => _ConversationScreen(conversationId: refreshed.id),
            ),
          );
        },
      ),
    );
  }
}

class _ConversationScreen extends StatefulWidget {
  const _ConversationScreen({required this.conversationId});

  final String conversationId;

  @override
  State<_ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<_ConversationScreen> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    ChatStore.instance.sendMessage(
      conversationId: widget.conversationId,
      text: text,
    );
    _messageController.clear();
  }

  Conversation? get _conversation =>
      ChatStore.instance.conversations.cast<Conversation?>().firstWhere(
        (item) => item?.id == widget.conversationId,
        orElse: () => null,
      );

  @override
  Widget build(BuildContext context) {
    final conversation = _conversation;
    if (conversation == null) return const Scaffold();
    final currentUserId =
        UserProfileStore.instance.current?.email.trim().toLowerCase() ??
        'utilisateur';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Color(conversation.avatarColor),
              child: Text(
                conversation.initials,
                style: const TextStyle(
                  color: _purple,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.otherUserName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    conversation.property,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[600], fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: AnimatedBuilder(
        animation: ChatStore.instance,
        builder: (context, _) {
          final liveConversation = _conversation;
          if (liveConversation == null) return const SizedBox();
          return Column(
            children: [
              Expanded(
                child: liveConversation.messages.isEmpty
                    ? const Center(child: Text('Commencez la conversation'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: liveConversation.messages.length,
                        itemBuilder: (context, index) {
                          final message = liveConversation.messages[index];
                          return Align(
                            alignment: message.senderId == currentUserId
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.sizeOf(context).width * 0.76,
                              ),
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: message.senderId == currentUserId
                                    ? _purple
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    message.text,
                                    style: TextStyle(
                                      color: message.senderId == currentUserId
                                          ? Colors.white
                                          : Colors.black87,
                                      height: 1.35,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    message.time,
                                    style: TextStyle(
                                      color: message.senderId == currentUserId
                                          ? Colors.white70
                                          : Colors.black45,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          textCapitalization: TextCapitalization.sentences,
                          onSubmitted: (_) => _sendMessage(),
                          decoration: InputDecoration(
                            hintText: 'Écrire un message...',
                            filled: true,
                            fillColor: const Color(0xFFF4F2F8),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: _sendMessage,
                        style: IconButton.styleFrom(backgroundColor: _purple),
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
