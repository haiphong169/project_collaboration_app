import 'package:project_collaboration_app/features/auth/domain/repositories/session_provider.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';
import 'package:project_collaboration_app/features/messaging/domain/repositories/conversation_repository.dart';
import 'package:project_collaboration_app/features/messaging/domain/repositories/message_repository.dart';
import 'package:project_collaboration_app/utils/app_exception.dart';
import 'package:project_collaboration_app/utils/result.dart';
import 'package:uuid/uuid.dart';

class SendMessageUsecase {
  final MessageRepository _messageRepository;
  final ConversationRepository _conversationRepository;
  final SessionProvider _session;

  const SendMessageUsecase({
    required MessageRepository messageRepository,
    required ConversationRepository conversationRepository,
    required SessionProvider sessionProvider,
  }) : _messageRepository = messageRepository,
       _conversationRepository = conversationRepository,
       _session = sessionProvider;

  Future<VoidResult> call(String messageText, String conversationUid) async {
    final userUid = _session.userUid;
    if (userUid == null) return Result.failure(UserNotFoundException());
    final message = Message(
      uid: Uuid().v4(),
      conversationUid: conversationUid,
      senderUid: userUid,
      text: messageText,
      createdAt: DateTime.now(),
    );
    final messageResult = await _messageRepository.sendMessage(message);
    if (messageResult is Failure<void>) {
      return Result.failure(FirestoreException());
    }
    final conversationResult = _conversationRepository.updateConversation(
      message.conversationUid,
      message,
    );
    return conversationResult;
  }
}
