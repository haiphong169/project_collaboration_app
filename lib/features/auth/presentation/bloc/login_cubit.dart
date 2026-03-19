import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:project_collaboration_app/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:project_collaboration_app/utils/result.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class LoginCubit extends Cubit<VoidUiState> {
  LoginCubit({
    required LoginUseCase loginUseCase,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
  }) : _loginUseCase = loginUseCase,
       _signInWithGoogleUseCase = signInWithGoogleUseCase,
       super(VoidUiState.idle());

  final LoginUseCase _loginUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;

  Future<void> login(String email, String password) async {
    emit(VoidUiState.loading());
    final result = await _loginUseCase(email, password);
    switch (result) {
      case Ok<void>():
        emit(VoidUiState.idle());
      case Failure<void>():
        emit(
          VoidUiState.error(
            'Something wrong happened, could not sign you in right now',
          ),
        );
    }
  }

  Future<void> signInWithGoogle() async {
    emit(VoidUiState.loading());
    final result = await _signInWithGoogleUseCase();
    switch (result) {
      case Ok<void>():
        emit(VoidUiState.idle());
      case Failure<void>():
        emit(
          VoidUiState.error(
            'Something wrong happened, could not sign you in right now',
          ),
        );
    }
  }
}
