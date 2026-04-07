import 'package:project_collaboration_app/features/messaging/data/data_sources/message_remote_data_source.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';
import 'package:project_collaboration_app/features/messaging/domain/repositories/message_repository.dart';
import 'package:project_collaboration_app/utils/mapper_extension.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource _messageRemoteDataSource;

  MessageRepositoryImpl({
    required MessageRemoteDataSource messageRemoteDataSource,
  }) : _messageRemoteDataSource = messageRemoteDataSource;

  @override
  Stream<List<Message>> conversationMessages(String conversationUid) async* {
    final modelStream = _messageRemoteDataSource.conversationMessages(
      conversationUid,
    );

    yield* modelStream.map(
      (modelList) => modelList.map((model) => model.toEntity()).toList(),
    );
  }

  @override
  Future<void> deleteMessage(String conversationUid, String messageUid) {
    return _messageRemoteDataSource.deleteMessage(conversationUid, messageUid);
  }

  @override
  Future<void> sendMessage(Message message) {
    return _messageRemoteDataSource.sendMessage(message.toModel());
  }
}
