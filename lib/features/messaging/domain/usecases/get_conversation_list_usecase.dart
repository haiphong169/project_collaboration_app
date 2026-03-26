import 'package:project_collaboration_app/features/auth/domain/repositories/session_provider.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/conversation.dart';
import 'package:project_collaboration_app/features/messaging/domain/repositories/conversation_repository.dart';
import 'package:project_collaboration_app/utils/app_exception.dart';
import 'package:project_collaboration_app/utils/result.dart';

class GetConversationListUsecase {
  final ConversationRepository _conversationRepository;
  final SessionProvider _session;

  const GetConversationListUsecase({
    required ConversationRepository conversationRepository,
    required SessionProvider sessionProvider,
  }) : _conversationRepository = conversationRepository,
       _session = sessionProvider;

  Future<Result<Stream<List<Conversation>>>> call() async {
    final uid = _session.userUid;
    if (uid == null) return Result.failure(UserNotFoundException());
    return _conversationRepository.conversations(uid);
  }
}
