import 'package:project_collaboration_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:project_collaboration_app/utils/result.dart';

class LogoutUsecase {
  final AuthRepository _authRepository;

  LogoutUsecase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  Future<VoidResult> call() async {
    return await _authRepository.logout();
  }
}
