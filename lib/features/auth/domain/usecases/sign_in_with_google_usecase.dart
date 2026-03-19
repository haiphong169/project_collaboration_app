import 'package:project_collaboration_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:project_collaboration_app/utils/result.dart';

class SignInWithGoogleUseCase {
  final AuthRepository _authRepository;

  SignInWithGoogleUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  Future<VoidResult> call() async {
    return await _authRepository.signInWithGoogle();
  }
}
