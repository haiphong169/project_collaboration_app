import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/messaging/presentation/bloc/chat_event.dart';
import 'package:project_collaboration_app/features/messaging/presentation/bloc/chat_state.dart';
import 'package:project_collaboration_app/features/messaging/presentation/bloc/mock_conversation_bloc.dart';

class MockConversationScreen extends StatefulWidget {
  const MockConversationScreen({super.key});

  @override
  State<MockConversationScreen> createState() => _MockConversationScreenState();
}

class _MockConversationScreenState extends State<MockConversationScreen> {
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
    return Scaffold(
      body: Center(
        child: BlocBuilder<MockConversationBloc, ChatState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: switch (state) {
                    ChatEmpty() => Center(
                      child: Text('Send a message to start the conversation'),
                    ),
                    ChatError(:final error) => Center(child: Text(error)),
                    ChatLoading() => Center(child: CircularProgressIndicator()),
                    ChatReady(:final messages) => ListView.builder(
                      itemCount: messages.length,
                      itemBuilder:
                          (context, index) => Text(messages[index].text),
                    ),
                    _ => SizedBox(),
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: TextField(controller: _controller)),
                    IconButton(
                      onPressed: () {
                        if (state is ChatEmpty) {
                          context.read<MockConversationBloc>().add(
                            ConversationCreated(_controller.text),
                          );
                        } else if (state is ChatReady) {
                          context.read<MockConversationBloc>().add(
                            MessageSent(_controller.text),
                          );
                        }
                        _controller.clear();
                      },
                      icon: Icon(Icons.send),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
