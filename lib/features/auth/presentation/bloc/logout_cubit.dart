import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:project_collaboration_app/utils/result.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class LogoutCubit extends Cubit<VoidUiState> {
  LogoutCubit({required LogoutUsecase logoutUseCase})
    : _logoutUseCase = logoutUseCase,
      super(VoidUiState.idle());

  final LogoutUsecase _logoutUseCase;

  Future<void> logout() async {
    emit(VoidUiState.loading());
    final result = await _logoutUseCase();
    switch (result) {
      case Ok<void>():
        emit(VoidUiState.idle());
      case Failure<void>():
        emit(
          VoidUiState.error(
            'Something wrong happened, could not log you out right now',
          ),
        );
    }
  }
}
