import 'package:project_collaboration_app/features/auth/domain/repositories/session_provider.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/conversation.dart';
import 'package:project_collaboration_app/features/messaging/domain/repositories/conversation_repository.dart';
import 'package:project_collaboration_app/utils/app_exception.dart';

class GetConversationListUsecase {
  final ConversationRepository _conversationRepository;
  final SessionProvider _session;

  const GetConversationListUsecase({
    required ConversationRepository conversationRepository,
    required SessionProvider sessionProvider,
  }) : _conversationRepository = conversationRepository,
       _session = sessionProvider;

  Stream<List<Conversation>> call() {
    final uid = _session.userUid;
    if (uid == null) throw UserNotFoundException();
    return _conversationRepository.conversations(uid);
  }
}
