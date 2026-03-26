import 'package:project_collaboration_app/features/auth/domain/repositories/session_provider.dart';
import 'package:project_collaboration_app/features/messaging/domain/repositories/conversation_repository.dart';
import 'package:project_collaboration_app/utils/app_exception.dart';
import 'package:project_collaboration_app/utils/result.dart';

class CheckExistingConversationUsecase {
  final ConversationRepository _conversationRepository;
  final SessionProvider _session;

  CheckExistingConversationUsecase({
    required ConversationRepository conversationRepository,
    required SessionProvider sessionProvider,
  }) : _conversationRepository = conversationRepository,
       _session = sessionProvider;

  Future<Result<String?>> call(String partnerUid) async {
    final userUid = _session.userUid;
    if (userUid == null) return Result.failure(UserNotFoundException());
    return _conversationRepository.checkExistingConversation(
      partnerUid,
      userUid,
    );
  }
}
