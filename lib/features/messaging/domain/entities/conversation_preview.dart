import 'package:project_collaboration_app/features/messaging/domain/entities/conversation.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';

class ConversationPreview {
  final User user;
  final Conversation conversation;

  ConversationPreview({required this.user, required this.conversation});
}
