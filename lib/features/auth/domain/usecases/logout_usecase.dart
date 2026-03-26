import 'package:project_collaboration_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:project_collaboration_app/features/auth/domain/repositories/session_provider.dart';
import 'package:project_collaboration_app/utils/result.dart';

class LogoutUsecase {
  final AuthRepository _authRepository;
  final SessionProvider _session;

  LogoutUsecase({
    required AuthRepository authRepository,
    required SessionProvider sessionProvider,
  }) : _authRepository = authRepository,
       _session = sessionProvider;

  Future<VoidResult> call() async {
    final logoutResult = await _authRepository.logout();
    if (logoutResult is Failure<void>) {
      return Result.failure(logoutResult.error);
    }
    return await _session.setUser(null);
  }
}
