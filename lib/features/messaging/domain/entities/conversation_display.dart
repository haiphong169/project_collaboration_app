import 'package:equatable/equatable.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';

class ConversationDisplay extends Equatable {
  final List<Message> messages;
  final User currentUser;
  final User conversationPartner;

  const ConversationDisplay({
    required this.messages,
    required this.currentUser,
    required this.conversationPartner,
  });

  ConversationDisplay copyWith({
    List<Message>? messages,
    User? currentUser,
    User? conversationPartner,
  }) {
    return ConversationDisplay(
      messages: messages ?? this.messages,
      currentUser: currentUser ?? this.currentUser,
      conversationPartner: conversationPartner ?? this.conversationPartner,
    );
  }

  @override
  List<Object?> get props => [messages, currentUser, conversationPartner];
}
