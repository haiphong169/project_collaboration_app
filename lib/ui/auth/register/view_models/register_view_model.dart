import 'package:project_collaboration_app/domain/abstract_repositories/auth_repository.dart';

class RegisterViewModel {
  RegisterViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  Future<void> register(String email, String password) async {
    await _authRepository.register(email, password);
  }
}
