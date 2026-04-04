import 'package:project_collaboration_app/features/messaging/domain/entities/conversation.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';
import 'package:project_collaboration_app/utils/result.dart';

abstract class ConversationRepository {
  Stream<List<Conversation>> conversations(String userUid);
  Future<Result<String?>> checkExistingConversation(
    String partnerUid,
    String userUid,
  );
  Future<VoidResult> addConversation(Conversation conversation);
  Future<VoidResult> deleteConversation(String conversationUid);
  Future<VoidResult> updateConversation(
    String conversationUid,
    Message newLastMessage,
  );
}
