// import 'dart:async';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';
// import 'package:project_collaboration_app/features/messaging/domain/usecases/conversation/add_conversation_usecase.dart';
// import 'package:project_collaboration_app/features/messaging/domain/usecases/message/send_message_usecase.dart';
// import 'package:project_collaboration_app/features/messaging/presentation/bloc/chat_event.dart';
// import 'package:project_collaboration_app/features/messaging/presentation/bloc/chat_state.dart';
// import 'package:project_collaboration_app/utils/result.dart';

// class MockConversationBloc extends Bloc<ChatEvent, ChatState> {
//   MockConversationBloc({
//     required this.partnerId,
//     required AddConversationUsecase addConversationUseCase,
//     required SendMessageUsecase sendMessageUseCase,
//   }) : _addConversationUsecase = addConversationUseCase,
//        _sendMessageUsecase = sendMessageUseCase,
//        super(ChatEmpty()) {
//     on<ConversationCreated>(_createConversation);

//     on<MessageSent>(_sendMessage);

//     on<MessageUpdated>(
//       (event, emit) => emit(ChatReady(display: event.display)),
//     );

//     on<MessageError>((event, emit) => emit(ChatError(event.message)));
//   }

//   final String partnerId;
//   final AddConversationUsecase _addConversationUsecase;
//   final SendMessageUsecase _sendMessageUsecase;
//   StreamSubscription<List<Message>>? _subscription;
//   late final String conversationId;

//   Future<void> _createConversation(
//     ConversationCreated event,
//     Emitter<ChatState> emit,
//   ) async {
//     emit(ChatLoading());

//     final result = await _addConversationUsecase(partnerId, event.text);

    
//         conversationId = result.$2;
//         _subscription?.cancel();
//         _subscription = result.$1.listen(
//           (messages) => add(MessageUpdated(messages)),
//           onError: (e) => add(MessageError(e.toString())),
//         );
      
//     }
//   }

//   Future<void> _sendMessage(MessageSent event, Emitter<ChatState> emit) async {
//     emit(ChatLoading());
//     final result = await _sendMessageUsecase(event.text, conversationId);
//     if (result is Failure<void>) {
//       emit(ChatError(result.error.message));
//     }
//   }

//   @override
//   Future<void> close() {
//     _subscription?.cancel();
//     return super.close();
//   }
// }
