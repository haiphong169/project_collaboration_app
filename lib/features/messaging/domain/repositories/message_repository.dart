import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';
import 'package:project_collaboration_app/utils/result.dart';

abstract class MessageRepository {
  Stream<List<Message>> conversationMessages(String conversationUid);
  Future<VoidResult> sendMessage(Message message);
  Future<VoidResult> deleteMessage(String messageUid);
}
