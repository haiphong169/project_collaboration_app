import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/domain/abstract_repositories/auth_repository.dart';
import 'package:project_collaboration_app/utils/result.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class RegisterViewModel extends Cubit<VoidUiState> {
  RegisterViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(VoidUiState.idle());

  final AuthRepository _authRepository;

  Future<void> register({
    String? email,
    String? password,
    bool signInWithGoogle = false,
  }) async {
    emit(VoidUiState.loading());
    final result =
        signInWithGoogle
            ? await _authRepository.login(signInWithGoogle: true)
            : await _authRepository.register(email!, password!);
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
}
