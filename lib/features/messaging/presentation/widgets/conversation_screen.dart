import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/core/ui/user_circle_avatar.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/conversation_display.dart';
import 'package:project_collaboration_app/features/messaging/presentation/bloc/chat_event.dart';
import 'package:project_collaboration_app/features/messaging/presentation/bloc/chat_state.dart';
import 'package:project_collaboration_app/features/messaging/presentation/bloc/conversation_bloc.dart';
import 'package:project_collaboration_app/features/messaging/presentation/widgets/chat_bubble.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConversationBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar(state),
          body: SafeArea(
            child: Center(
              child: Column(
                children: [
                  Expanded(
                    child: switch (state) {
                      ChatReady(:final display) => _buildMessageList(display),
                      ChatLoading() => Center(
                        child: CircularProgressIndicator(),
                      ),
                      _ => SizedBox(),
                    },
                  ),
                  SizedBox(height: 36),
                  // input field
                  Row(
                    children: [
                      Expanded(child: TextField(controller: _controller)),
                      IconButton(
                        onPressed: () {
                          context.read<ConversationBloc>().add(
                            MessageSent(_controller.text),
                          );
                          _controller.clear();
                        },
                        icon: Icon(Icons.send),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageList(ConversationDisplay display) {
    final avatarUid = <String, void>{};
    final reversedMessages = display.messages.reversed.toList();
    for (int i = 0; i < reversedMessages.length; i++) {
      if (i > 0) {
        if (reversedMessages[i].senderUid == display.currentUser.uid &&
            reversedMessages[i - 1].senderUid ==
                display.conversationPartner.uid) {
          avatarUid[reversedMessages[i - 1].uid] = null;
        }
      }
    }
    if (reversedMessages.last.senderUid == display.conversationPartner.uid) {
      avatarUid[reversedMessages.last.uid] = null;
    }

    return ListView.builder(
      reverse: true,
      itemCount: display.messages.length,
      itemBuilder: (context, index) {
        final message = display.messages[index];
        return Padding(
          padding: const EdgeInsetsGeometry.symmetric(
            vertical: 4,
            horizontal: 4,
          ),
          child: ChatRow(
            text: message.text,
            time: message.createdAt,
            isMe: message.senderUid == display.currentUser.uid,
            avatar:
                avatarUid.containsKey(message.uid)
                    ? display.conversationPartner.avatar
                    : null,
          ),
        );
      },
    );
  }

  AppBar _appBar(ChatState state) {
    if (state is ChatReady) {
      return AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            UserCircleAvatar(
              avatar: state.display.conversationPartner.avatar,
              radius: 28,
            ),
            SizedBox(width: 8),
            Text(state.display.conversationPartner.username),
          ],
        ),
      );
    } else {
      return AppBar();
    }
  }
}
