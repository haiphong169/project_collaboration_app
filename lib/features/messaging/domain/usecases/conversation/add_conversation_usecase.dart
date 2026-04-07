import 'package:project_collaboration_app/features/auth/domain/repositories/session_provider.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/conversation.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';
import 'package:project_collaboration_app/features/messaging/domain/repositories/conversation_repository.dart';
import 'package:project_collaboration_app/features/messaging/domain/repositories/message_repository.dart';
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

  Future<(Stream<List<Message>>, String)> call(
    String partnerUid,
    String messageText,
  ) async {
    // create conversation -> create first message -> return stream of conversation
    final userUid = _session.userUid;
    final conversation = Conversation(
      uid: Uuid().v4(),
      participants: [userUid!, partnerUid],
      lastMessage: messageText,
      lastMessageAt: DateTime.now(),
      lastMessageSenderUid: userUid,
    );
    await _conversationRepository.addConversation(conversation);
    final firstMessage = Message(
      uid: Uuid().v4(),
      conversationUid: conversation.uid,
      senderUid: userUid,
      text: messageText,
      createdAt: conversation.lastMessageAt,
    );
    await _messageRepository.sendMessage(firstMessage);
    return (
      _messageRepository.conversationMessages(conversation.uid),
      conversation.uid,
    );
  }
}
