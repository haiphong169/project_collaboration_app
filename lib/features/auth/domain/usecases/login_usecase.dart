import 'package:project_collaboration_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:project_collaboration_app/utils/result.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  Future<VoidResult> call(String email, String password) async {
    return await _authRepository.login(email, password);
  }
}
