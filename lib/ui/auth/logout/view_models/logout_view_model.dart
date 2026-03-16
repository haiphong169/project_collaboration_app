import 'package:project_collaboration_app/domain/abstract_repositories/auth_repository.dart';

class LogoutViewModel {
  LogoutViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  Future<void> logout() async {
    await _authRepository.logout();
  }
}
