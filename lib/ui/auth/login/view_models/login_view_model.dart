import 'package:project_collaboration_app/domain/abstract_repositories/auth_repository.dart';

class LoginViewModel {
  LoginViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  Future<void> login(String email, String password) async {
    await _authRepository.login(email, password);
  }
}
