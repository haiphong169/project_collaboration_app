import 'package:project_collaboration_app/features/auth/domain/repositories/session_provider.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/conversation.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';
import 'package:project_collaboration_app/features/messaging/domain/repositories/conversation_repository.dart';
import 'package:project_collaboration_app/features/messaging/domain/repositories/message_repository.dart';
import 'package:project_collaboration_app/utils/app_exception.dart';
import 'package:project_collaboration_app/utils/logger.dart';
import 'package:project_collaboration_app/utils/result.dart';
import 'package:project_collaboration_app/utils/type_def.dart';
import 'package:uuid/uuid.dart';

class AddConversationUsecase {
  final ConversationRepository _conversationRepository;
  final MessageRepository _messageRepository;
  final SessionProvider _session;

  const AddConversationUsecase({
    required ConversationRepository conversationRepository,
    required MessageRepository messageRepository,
    required SessionProvider sessionProvider,
  }) : _conversationRepository = conversationRepository,
       _messageRepository = messageRepository,
       _session = sessionProvider;

  Future<Result<(MessageStream, String)>> call(
    String partnerUid,
    String messageText,
  ) async {
    // create conversation -> create first message -> return stream of conversation
    final userUid = _session.userUid;
    if (userUid == null) return Result.failure(UserNotFoundException());
    final conversation = Conversation(
      uid: Uuid().v4(),
      participants: [userUid, partnerUid],
      lastMessage: messageText,
      lastMessageAt: DateTime.now(),
      lastMessageSenderUid: userUid,
    );
    final conversationResult = await _conversationRepository.addConversation(
      conversation,
    );
    if (conversationResult is Failure<void>) {
      return Result.failure(FirestoreException());
    }
    AppLogger().d(1);
    final firstMessage = Message(
      uid: Uuid().v4(),
      conversationUid: conversation.uid,
      senderUid: userUid,
      text: messageText,
      createdAt: conversation.lastMessageAt,
    );
    final messageResult = await _messageRepository.sendMessage(firstMessage);
    if (messageResult is Failure<void>) {
      return Result.failure(FirestoreException());
    }
    AppLogger().d(2);
    final streamResult = await _messageRepository.conversationMessages(
      conversation.uid,
    );
    if (streamResult is Ok<MessageStream>) {
      return Result.ok((streamResult.data, conversation.uid));
    }
    return Result.failure(FirestoreException());
  }
}
