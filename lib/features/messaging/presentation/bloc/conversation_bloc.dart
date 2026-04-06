import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/auth/domain/repositories/session_provider.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/conversation_display.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';
import 'package:project_collaboration_app/features/messaging/domain/usecases/message/get_conversation_messages_usecase.dart';
import 'package:project_collaboration_app/features/messaging/domain/usecases/message/send_message_usecase.dart';
import 'package:project_collaboration_app/features/messaging/presentation/bloc/chat_event.dart';
import 'package:project_collaboration_app/features/messaging/presentation/bloc/chat_state.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';
import 'package:project_collaboration_app/features/user/domain/usecases/get_users_by_uids_usecase.dart';
import 'package:project_collaboration_app/utils/app_exception.dart';
import 'package:project_collaboration_app/utils/result.dart';

class ConversationBloc extends Bloc<ChatEvent, ChatState> {
  ConversationBloc({
    required this.conversationId,
    required GetConversationMessagesUsecase getConversationMessagesUsecase,
    required SendMessageUsecase sendMessageUsecase,
    required GetUsersByUidsUseCase getUsersByUids,
    required SessionProvider sessionProvider,
    required this.partnerUid,
  }) : _getConversationMessagesUsecase = getConversationMessagesUsecase,
       _sendMessageUsecase = sendMessageUsecase,
       _getUsersByUids = getUsersByUids,
       _session = sessionProvider,
       super(const ChatEmpty()) {
    on<Initialization>(_init);

    on<MessageSent>(_sendMessage);

    on<MessageUpdated>(
      (event, emit) => emit(ChatReady(display: event.display)),
    );

    on<MessageError>((event, emit) => emit(ChatError(event.message)));
  }

  final GetConversationMessagesUsecase _getConversationMessagesUsecase;
  final SendMessageUsecase _sendMessageUsecase;
  final GetUsersByUidsUseCase _getUsersByUids;
  final SessionProvider _session;
  final String partnerUid;
  StreamSubscription<List<Message>>? _subscription;
  final String conversationId;

  Future<void> _init(Initialization event, Emitter<ChatState> emit) async {
    try {
      emit(const ChatLoading());
      final currentUser = _session.user;
      if (currentUser == null) {
        add(MessageError(UserNotFoundException().message));
      }
      final partner = (await _getUsersByUids([partnerUid])).first;
      final messageStream = _getConversationMessagesUsecase(conversationId);

      _subscription?.cancel();
      _subscription = messageStream.listen(
        (messages) => add(
          MessageUpdated(
            ConversationDisplay(
              currentUser: currentUser!,
              conversationPartner: partner,
              messages: messages,
            ),
          ),
        ),
        onError: (e) => add(MessageError(e.toString())),
      );
    } on Exception catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _sendMessage(MessageSent event, Emitter<ChatState> emit) async {
    emit(const ChatLoading());
    final result = await _sendMessageUsecase(event.text, conversationId);
    if (result is Failure<void>) {
      emit(ChatError(result.error.message));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
