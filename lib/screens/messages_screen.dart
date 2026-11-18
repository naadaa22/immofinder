import 'package:flutter/material.dart';

const _purple = Color(0xFF4B2A8B);

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  static const _conversations = [
    _ConversationPreview(
      name: 'Ahmed Ben Ali',
      property: 'Appartement S+2 · La Marsa',
      message: 'D’accord, est-ce que je peux le visiter ?',
      time: '10:42',
      unread: 2,
      avatarColor: Color(0xFFE9E2F8),
      initials: 'AB',
    ),
    _ConversationPreview(
      name: 'Meriem Trabelsi',
      property: 'Villa avec jardin · Sidi Bou Saïd',
      message: 'Merci pour les informations !',
      time: 'Hier',
      unread: 0,
      avatarColor: Color(0xFFFFE9DF),
      initials: 'MT',
    ),
    _ConversationPreview(
      name: 'Youssef Gharbi',
      property: 'Studio meublé · Centre-ville',
      message: 'Le loyer inclut-il les charges ?',
      time: 'Lun.',
      unread: 0,
      avatarColor: Color(0xFFE1F1E8),
      initials: 'YG',
    ),
  ];

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
      body: ListView(
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
          ..._conversations.map(
            (conversation) => _ConversationTile(conversation: conversation),
          ),
        ],
      ),
    );
  }
}

class _ConversationPreview {
  const _ConversationPreview({
    required this.name,
    required this.property,
    required this.message,
    required this.time,
    required this.unread,
    required this.avatarColor,
    required this.initials,
  });

  final String name;
  final String property;
  final String message;
  final String time;
  final int unread;
  final Color avatarColor;
  final String initials;
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({required this.conversation});

  final _ConversationPreview conversation;

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: conversation.avatarColor,
          child: Text(
            conversation.initials,
            style: const TextStyle(color: _purple, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          conversation.name,
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
              Text(
                conversation.message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              conversation.time,
              style: TextStyle(color: Colors.grey[600], fontSize: 11),
            ),
            const SizedBox(height: 6),
            if (conversation.unread > 0)
              CircleAvatar(
                radius: 10,
                backgroundColor: _purple,
                child: Text(
                  '${conversation.unread}',
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              )
            else
              const Icon(Icons.chevron_right, color: Colors.black38, size: 20),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => _ConversationScreen(conversation: conversation),
            ),
          );
        },
      ),
    );
  }
}

class _ConversationScreen extends StatefulWidget {
  const _ConversationScreen({required this.conversation});

  final _ConversationPreview conversation;

  @override
  State<_ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<_ConversationScreen> {
  final _messageController = TextEditingController();
  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text: 'Bonjour, votre annonce est-elle toujours disponible ?',
      isMine: false,
      time: '10:35',
    ),
    const _ChatMessage(
      text: 'Bonjour ! Oui, le bien est toujours disponible.',
      isMine: true,
      time: '10:38',
    ),
    const _ChatMessage(
      text: 'D’accord, est-ce que je peux le visiter ?',
      isMine: false,
      time: '10:42',
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        _ChatMessage(
          text: text,
          isMine: true,
          time: TimeOfDay.now().format(context),
        ),
      );
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final conversation = widget.conversation;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: conversation.avatarColor,
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
                    conversation.name,
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _MessageBubble(message: message);
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
                    icon: const Icon(Icons.send_rounded, color: Colors.white),
                    tooltip: 'Envoyer',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({
    required this.text,
    required this.isMine,
    required this.time,
  });

  final String text;
  final bool isMine;
  final String time;
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.76,
        ),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: message.isMine ? _purple : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(message.isMine ? 18 : 4),
            bottomRight: Radius.circular(message.isMine ? 4 : 18),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isMine ? Colors.white : Colors.black87,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message.time,
              style: TextStyle(
                color: message.isMine ? Colors.white70 : Colors.black45,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
