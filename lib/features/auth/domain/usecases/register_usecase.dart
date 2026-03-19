import 'package:project_collaboration_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:project_collaboration_app/utils/result.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  Future<VoidResult> call(
    String username,
    String email,
    String password,
  ) async {
    return await _authRepository.register(username, email, password);
  }
}
