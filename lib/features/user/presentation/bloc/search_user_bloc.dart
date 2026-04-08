import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/config/routing/routes.dart';
import 'package:project_collaboration_app/features/messaging/domain/usecases/conversation/check_existing_conversation_usecase.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';
import 'package:project_collaboration_app/features/user/domain/usecases/search_user_use_case.dart';
import 'package:project_collaboration_app/features/user/presentation/bloc/search_user_event.dart';
import 'package:project_collaboration_app/features/user/presentation/bloc/search_user_state.dart';
import 'package:project_collaboration_app/utils/result.dart';
import 'package:stream_transform/stream_transform.dart';

class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState> {
  final SearchUserUseCase _searchUserUseCase;
  final CheckExistingConversationUseCase _checkExistingConversation;
  final String origin;

  SearchUserBloc({
    required SearchUserUseCase searchUserUseCase,
    required CheckExistingConversationUseCase checkExistingConversationUseCase,
    required this.origin,
  }) : _checkExistingConversation = checkExistingConversationUseCase,
       _searchUserUseCase = searchUserUseCase,
       super(SearchInitial()) {
    on<SearchQueryChanged>(
      _onQueryChanged,
      transformer: debounceRestarable(const Duration(milliseconds: 400)),
    );

    on<SearchCleared>((event, emit) {
      emit(SearchInitial());
    });

    on<ResultTapped>(_onResultTapped);
  }

  Future<void> _onResultTapped(
    ResultTapped event,
    Emitter<SearchUserState> emit,
  ) async {
    final result = await _checkExistingConversation(event.resultUid);

    switch (result) {
      case Ok<String?>(:final data):
        if (origin == Routes.messages) {
          if (data != null) {
            emit(
              OnNavigation(Routes.conversationWithId(data), event.resultUid),
            );
          } else {
            emit(OnNavigation(Routes.mockConversationWithId(event.resultUid)));
          }
        }
      case Failure<String?>(:final error):
        emit(SearchError(error.message));
    }
  }

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchUserState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    final result = await _searchUserUseCase(query);

    switch (result) {
      case Ok<List<User>>(:final data):
        if (data.isEmpty) {
          emit(SearchEmpty());
        } else {
          emit(SearchSuccess(data));
        }
      case Failure<List<User>>(:final error):
        emit(SearchError(error.message));
    }
  }

  EventTransformer<T> debounceRestarable<T>(Duration duration) {
    return (events, mapper) => events.debounce(duration).switchMap(mapper);
  }
}
