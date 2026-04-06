import 'package:project_collaboration_app/features/messaging/data/data_sources/conversation_remote_data_source.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/conversation.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';
import 'package:project_collaboration_app/features/messaging/domain/repositories/conversation_repository.dart';
import 'package:project_collaboration_app/utils/mapper_extension.dart';
import 'package:project_collaboration_app/utils/result.dart';

class ConversationRepositoryImpl extends ConversationRepository {
  final ConversationRemoteDataSource _conversationRemoteDataSource;

  ConversationRepositoryImpl({
    required ConversationRemoteDataSource conversationRemoteDataSource,
  }) : _conversationRemoteDataSource = conversationRemoteDataSource;

  @override
  Future<VoidResult> addConversation(Conversation conversation) {
    return _conversationRemoteDataSource.addConversation(
      conversation.toModel(),
    );
  }

  @override
  Future<Result<String?>> checkExistingConversation(
    String partnerUid,
    String userUid,
  ) {
    return _conversationRemoteDataSource.checkExistingConversation(
      partnerUid,
      userUid,
    );
  }

  @override
  Stream<List<Conversation>> conversations(String userUid) async* {
    final modelStream = _conversationRemoteDataSource.getConversations(userUid);

    yield* modelStream.map(
      (modelList) => modelList.map((model) => model.toEntity()).toList(),
    );
  }

  @override
  Future<VoidResult> deleteConversation(String conversationUid) {
    return _conversationRemoteDataSource.deleteConversation(conversationUid);
  }

  @override
  Future<VoidResult> updateConversation(
    String conversationUid,
    Message newLastMessage,
  ) {
    final messageModel = newLastMessage.toModel();
    return _conversationRemoteDataSource.updateConversation(
      conversationUid,
      messageModel,
    );
  }
}
