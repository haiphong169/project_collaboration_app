import 'package:project_collaboration_app/features/messaging/domain/repositories/conversation_repository.dart';

class DeleteConversationUsecase {
  final ConversationRepository _conversationRepository;

  const DeleteConversationUsecase({
    required ConversationRepository conversationRepository,
  }) : _conversationRepository = conversationRepository;

  Future<void> call(String conversationUid) {
    return _conversationRepository.deleteConversation(conversationUid);
  }
}
