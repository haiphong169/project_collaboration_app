import 'package:project_collaboration_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:project_collaboration_app/features/auth/domain/repositories/session_provider.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';
import 'package:project_collaboration_app/features/user/domain/repositories/user_repository.dart';
import 'package:project_collaboration_app/utils/generate_default_avatar.dart';
import 'package:project_collaboration_app/utils/result.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final SessionProvider _session;

  RegisterUseCase({
    required AuthRepository authRepository,
    required UserRepository userRepository,
    required SessionProvider sessionProvider,
  }) : _authRepository = authRepository,
       _userRepository = userRepository,
       _session = sessionProvider;

  Future<VoidResult> call(
    String username,
    String email,
    String password,
  ) async {
    final registerResult = await _authRepository.register(
      username,
      email,
      password,
    );
    if (registerResult is Failure<String>) {
      return Result.failure(registerResult.error);
    }
    final uid = (registerResult as Ok<String>).data;
    final user = User(
      uid: uid,
      username: username,
      avatar: AvatarGenerator.generateDefaultAvatar(username).toEntity(),
    );
    final createUserResult = await _userRepository.createUser(user);
    if (createUserResult is Failure<void>) {
      return Result.failure(createUserResult.error);
    }
    return await _session.setUser(user);
  }
}
