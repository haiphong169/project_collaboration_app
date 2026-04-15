import 'package:flutter/material.dart';
import 'package:project_collaboration_app/core/ui/user_circle_avatar.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';

class ChatRow extends StatelessWidget {
  const ChatRow({
    super.key,
    required this.text,
    required this.time,
    required this.isMe,
    this.avatar,
  });

  final String text;
  final DateTime time;
  final bool isMe;
  final Avatar? avatar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: isMe ? 0 : 4,
        right: isMe ? 8 : 0,
      ),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            if (avatar != null) ...[
              UserCircleAvatar(avatar: avatar!, radius: 24),
              SizedBox(width: 8),
            ] else
              SizedBox(width: 56),
          ],
          _ChatBubble(text: text, time: "", isMe: isMe),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final String time;
  final bool isMe;

  const _ChatBubble({
    required this.text,
    required this.time,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.72,
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          _BubbleShape(isMe: isMe, text: text, time: time),
          const SizedBox(height: 2),
        ],
      ),
    );
  }
}

class _BubbleShape extends StatelessWidget {
  final bool isMe;
  final String text;
  final String time;

  const _BubbleShape({
    required this.isMe,
    required this.text,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: Radius.circular(isMe ? 18 : 4),
      bottomRight: Radius.circular(isMe ? 4 : 18),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color:
            isMe
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerHighest,
        borderRadius: radius,
      ),
      child: Text(
        text,
        style: theme.textTheme.bodyLarge!.copyWith(
          color:
              isMe
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
