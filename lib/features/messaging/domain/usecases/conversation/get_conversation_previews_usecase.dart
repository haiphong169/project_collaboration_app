import 'package:project_collaboration_app/features/auth/domain/repositories/session_provider.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/conversation_preview.dart';
import 'package:project_collaboration_app/features/messaging/domain/usecases/conversation/get_conversation_list_usecase.dart';
import 'package:project_collaboration_app/features/user/domain/usecases/get_users_by_uids_usecase.dart';
import 'package:project_collaboration_app/utils/app_exception.dart';

class GetConversationPreviewsUseCase {
  final GetConversationListUsecase _getConversationListUsecase;
  final GetUsersByUidsUseCase _getUsersByUidsUseCase;
  final SessionProvider _session;

  const GetConversationPreviewsUseCase({
    required GetConversationListUsecase getConversationListUsecase,
    required GetUsersByUidsUseCase getUsersByUidsUseCase,
    required SessionProvider sessionProvider,
  }) : _getConversationListUsecase = getConversationListUsecase,
       _getUsersByUidsUseCase = getUsersByUidsUseCase,
       _session = sessionProvider;

  Stream<List<ConversationPreview>> call() {
    final userUid = _session.userUid;
    if (userUid == null) throw UserNotFoundException();
    return _getConversationListUsecase().asyncMap((conversations) async {
      final partnerUids =
          conversations
              .map(
                (conversation) => conversation.participants.firstWhere(
                  (uid) => uid != userUid,
                ),
              )
              .toList();
      final users = await _getUsersByUidsUseCase(partnerUids);
      final userMap = {for (var u in users) u.uid: u};
      return conversations
          .map(
            (conversation) => ConversationPreview(
              user:
                  userMap[conversation.participants.firstWhere(
                    (uid) => uid != userUid,
                  )]!,
              conversation: conversation,
            ),
          )
          .toList();
    });
  }
}
