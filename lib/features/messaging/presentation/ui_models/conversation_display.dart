import 'package:equatable/equatable.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';

class ConversationDisplay extends Equatable {
  final Stream<List<Message>> messages;
  final User currentUser;
  final User partner;

  const ConversationDisplay({
    required this.messages,
    required this.currentUser,
    required this.partner,
  });

  @override
  List<Object?> get props => [messages, currentUser, partner];
}
