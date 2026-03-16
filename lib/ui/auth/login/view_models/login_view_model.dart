import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/domain/abstract_repositories/auth_repository.dart';
import 'package:project_collaboration_app/utils/result.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class LoginViewModel extends Cubit<VoidUiState> {
  LoginViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(VoidUiState.idle());

  final AuthRepository _authRepository;

  Future<void> login({
    String? email,
    String? password,
    bool signInWithGoogle = false,
  }) async {
    emit(VoidUiState.loading());
    final result = await _authRepository.login(
      email: email,
      password: password,
      signInWithGoogle: signInWithGoogle,
    );
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
