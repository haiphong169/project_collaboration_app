import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:project_collaboration_app/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:project_collaboration_app/utils/result.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class RegisterCubit extends Cubit<VoidUiState> {
  RegisterCubit({
    required RegisterUseCase registerUseCase,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
  }) : _registerUseCase = registerUseCase,
       _signInWithGoogleUseCase = signInWithGoogleUseCase,
       super(VoidUiState.idle());

  final RegisterUseCase _registerUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;

  Future<void> register(String username, String email, String password) async {
    emit(VoidUiState.loading());
    final result = await _registerUseCase(username, email, password);
    switch (result) {
      case Ok<void>():
        emit(VoidUiState.idle());
      case Failure<void>():
        emit(
          VoidUiState.error(
            'Something wrong happened, could not sign you up right now',
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
