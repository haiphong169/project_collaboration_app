import 'package:project_collaboration_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:project_collaboration_app/features/auth/domain/repositories/session_provider.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';
import 'package:project_collaboration_app/features/user/domain/repositories/user_repository.dart';
import 'package:project_collaboration_app/utils/result.dart';

class LoginUseCase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final SessionProvider _session;

  LoginUseCase({
    required AuthRepository authRepository,
    required UserRepository userRepository,
    required SessionProvider sessionProvider,
  }) : _authRepository = authRepository,
       _userRepository = userRepository,
       _session = sessionProvider;

  Future<VoidResult> call(String email, String password) async {
    final loginResult = await _authRepository.login(email, password);
    if (loginResult is Failure<String>) {
      return Result.failure(loginResult.error);
    }
    final uid = (loginResult as Ok<String>).data;
    final userResult = await _userRepository.getUser(uid);
    if (userResult is Failure<User>) {
      return Result.failure(userResult.error);
    }
    final user = (userResult as Ok<User>).data;
    return await _session.setUser(user);
  }
}
