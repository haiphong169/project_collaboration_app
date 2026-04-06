import 'package:equatable/equatable.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/conversation_display.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatReady extends ChatState {
  final ConversationDisplay display;

  const ChatReady({required this.display});

  @override
  List<Object?> get props => [display];
}

class ChatSending extends ChatReady {
  final Message sentMessage;

  const ChatSending({required super.display, required this.sentMessage});

  @override
  List<Object?> get props => [display, sentMessage];
}

class ChatError extends ChatState {
  final String error;

  const ChatError(this.error);

  @override
  List<Object?> get props => [error];
}

class ChatEmpty extends ChatState {
  const ChatEmpty();
}
