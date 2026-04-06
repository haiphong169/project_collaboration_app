import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_collaboration_app/config/routing/routes.dart';
import 'package:project_collaboration_app/core/ui/user_circle_avatar.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/conversation_preview.dart';
import 'package:project_collaboration_app/features/messaging/presentation/bloc/message_screen_cubit.dart';
import 'package:project_collaboration_app/utils/app_date_formatter.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 48),
            MessageSearchBar(
              onTap: () {
                context.push(Routes.userSearch, extra: Routes.messages);
              },
            ),
            SizedBox(height: 48),
            Expanded(
              child: BlocBuilder<
                MessageScreenCubit,
                UiState<List<ConversationPreview>>
              >(
                builder:
                    (context, state) => switch (state) {
                      Success<List<ConversationPreview>>(:final data) =>
                        ListView.builder(
                          itemCount: data.length,
                          itemBuilder:
                              (context, index) => _ConversationListTile(
                                conversationPreview: data[index],
                                onTap: () {
                                  context.push(
                                    Routes.conversationWithId(
                                      data[index].conversation.uid,
                                    ),
                                    extra: data[index].user.uid,
                                  );
                                },
                              ),
                        ),
                      _ => SizedBox(),
                    },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationListTile extends StatelessWidget {
  const _ConversationListTile({
    required this.conversationPreview,
    required this.onTap,
  });

  final ConversationPreview conversationPreview;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            UserCircleAvatar(
              avatar: conversationPreview.user.avatar,
              radius: 40,
            ),
            SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversationPreview.user.username,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversationPreview.conversation.lastMessage,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        AppDateFormatter.formatDateTime(
                          conversationPreview.conversation.lastMessageAt,
                        ),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageSearchBar extends StatelessWidget {
  const MessageSearchBar({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: "Search users...",
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}
