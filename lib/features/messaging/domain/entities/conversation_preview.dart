import 'package:equatable/equatable.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/conversation.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';

class ConversationPreview extends Equatable {
  final User user;
  final Conversation conversation;

  const ConversationPreview({required this.user, required this.conversation});

  @override
  List<Object?> get props => [user, conversation];
}
