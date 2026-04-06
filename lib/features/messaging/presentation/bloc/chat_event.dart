import 'package:project_collaboration_app/features/messaging/domain/entities/conversation_display.dart';

abstract class ChatEvent {}

class Initialization extends ChatEvent {}

class MessageSent extends ChatEvent {
  final String text;

  MessageSent(this.text);
}

class ConversationCreated extends ChatEvent {
  final String text;

  ConversationCreated(this.text);
}

class MessageUpdated extends ChatEvent {
  final ConversationDisplay display;

  MessageUpdated(this.display);
}

class MessageError extends ChatEvent {
  final String message;

  MessageError(this.message);
}
