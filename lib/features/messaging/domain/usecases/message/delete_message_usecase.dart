import 'package:project_collaboration_app/features/messaging/domain/repositories/message_repository.dart';

class DeleteMessageUsecase {
  final MessageRepository _messageRepository;

  const DeleteMessageUsecase({required MessageRepository messageRepository})
    : _messageRepository = messageRepository;

  Future<void> call(String conversationUid, String messageUid) {
    return _messageRepository.deleteMessage(conversationUid, messageUid);
  }
}
