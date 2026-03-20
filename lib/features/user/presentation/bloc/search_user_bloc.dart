import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';
import 'package:project_collaboration_app/features/user/domain/usecases/search_user_use_case.dart';
import 'package:project_collaboration_app/features/user/presentation/bloc/search_user_event.dart';
import 'package:project_collaboration_app/features/user/presentation/bloc/search_user_state.dart';
import 'package:project_collaboration_app/utils/result.dart';
import 'package:stream_transform/stream_transform.dart';

class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState> {
  final SearchUserUseCase _searchUserUseCase;

  SearchUserBloc({required SearchUserUseCase searchUserUseCase})
    : _searchUserUseCase = searchUserUseCase,
      super(SearchInitial()) {
    on<SearchQueryChanged>(
      _onQueryChanged,
      transformer: debounceRestarable(const Duration(milliseconds: 400)),
    );

    on<SearchCleared>((event, emit) {
      emit(SearchInitial());
    });
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
