import 'package:project_collaboration_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:project_collaboration_app/features/auth/domain/repositories/session_provider.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';
import 'package:project_collaboration_app/features/user/domain/repositories/user_repository.dart';
import 'package:project_collaboration_app/utils/generate_default_avatar.dart';
import 'package:project_collaboration_app/utils/result.dart';

class SignInWithGoogleUseCase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final SessionProvider _session;

  SignInWithGoogleUseCase({
    required AuthRepository authRepository,
    required UserRepository userRepository,
    required SessionProvider sessionProvider,
  }) : _authRepository = authRepository,
       _userRepository = userRepository,
       _session = sessionProvider;

  Future<VoidResult> call() async {
    final signInResult = await _authRepository.signInWithGoogle();
    if (signInResult is Failure<(String, String)>) {
      return Result.failure(signInResult.error);
    }
    final resultData = (signInResult as Ok<(String, String)>).data;
    final uid = resultData.$1;
    final displayName = resultData.$2;

    final checkIfUserExists = await _userRepository.getUser(uid);

    if (checkIfUserExists is Ok<User>) {
      return await _session.setUser(checkIfUserExists.data);
    }

    final user = User(
      uid: uid,
      username: displayName,
      avatar: AvatarGenerator.generateDefaultAvatar(displayName).toEntity(),
    );

    final createUserResult = await _userRepository.createUser(user);
    if (createUserResult is Failure<void>) {
      return Result.failure(createUserResult.error);
    }

    return await _session.setUser(user);
  }
}
