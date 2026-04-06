import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';
import 'package:project_collaboration_app/features/messaging/domain/repositories/message_repository.dart';

class GetConversationMessagesUsecase {
  final MessageRepository _messageRepository;

  const GetConversationMessagesUsecase({
    required MessageRepository messageRepository,
  }) : _messageRepository = messageRepository;

  Stream<List<Message>> call(String conversationUid) {
    return _messageRepository.conversationMessages(conversationUid);
  }
}
