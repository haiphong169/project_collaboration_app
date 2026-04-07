import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';

abstract class MessageRepository {
  Stream<List<Message>> conversationMessages(String conversationUid);
  Future<void> sendMessage(Message message);
  Future<void> deleteMessage(String conversationUid, String messageUid);
}
