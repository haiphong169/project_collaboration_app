import 'package:flutter/material.dart';
import 'package:project_collaboration_app/core/ui/user_circle_avatar.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';

// enum MessageStatus { pending, sent, delivered, read }

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
          ChatBubble(text: text, time: "", isMe: isMe),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final String time;
  final bool isMe;
  // final MessageStatus status;

  const ChatBubble({
    super.key,
    required this.text,
    required this.time,
    required this.isMe,
    // this.status = MessageStatus.sent,
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
          // _MetaRow(time: time, isMe: isMe, status: status),
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
        style: TextStyle(
          fontSize: 15,
          height: 1.4,
          color:
              isMe
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

// class _MetaRow extends StatelessWidget {
//   final String time;
//   final bool isMe;
//   final MessageStatus status;

//   const _MetaRow({
//     required this.time,
//     required this.isMe,
//     required this.status,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final color = Theme.of(context).colorScheme.outline;

//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text(time, style: TextStyle(fontSize: 11, color: color)),
//         if (isMe) ...[
//           const SizedBox(width: 4),
//           _StatusIcon(status: status, color: color),
//         ],
//       ],
//     );
//   }
// }

// class _StatusIcon extends StatelessWidget {
//   final MessageStatus status;
//   final Color color;

//   const _StatusIcon({required this.status, required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return switch (status) {
//       MessageStatus.pending => SizedBox(
//         width: 12,
//         height: 12,
//         child: CircularProgressIndicator(strokeWidth: 1.5, color: color),
//       ),
//       MessageStatus.sent => Icon(Icons.check, size: 14, color: color),
//       MessageStatus.delivered => Icon(Icons.done_all, size: 14, color: color),
//       MessageStatus.read => Icon(Icons.done_all, size: 14, color: Colors.blue),
//     };
//   }
// }
