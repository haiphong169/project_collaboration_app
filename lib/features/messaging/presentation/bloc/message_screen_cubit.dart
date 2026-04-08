import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/conversation_preview.dart';
import 'package:project_collaboration_app/features/messaging/domain/usecases/conversation/get_conversation_previews_usecase.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class MessageScreenCubit extends Cubit<UiState<List<ConversationPreview>>> {
  final GetConversationPreviewsUseCase _getConversationPreviews;
  StreamSubscription<List<ConversationPreview>>? _subscription;

  MessageScreenCubit({
    required GetConversationPreviewsUseCase getConversationPreviewsUseCase,
  }) : _getConversationPreviews = getConversationPreviewsUseCase,
       super(UiState.idle());

  void fetchConversations() {
    emit(UiState.loading());
    try {
      final conversationsStream = _getConversationPreviews();
      _subscription?.cancel();
      _subscription = conversationsStream.listen(
        (conversations) => emit(UiState.success(conversations)),
        onError: (e) => emit(UiState.error(e.toString())),
      );
    } on Exception catch (e) {
      emit(UiState.error(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
