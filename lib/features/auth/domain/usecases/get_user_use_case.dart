import 'package:project_collaboration_app/features/auth/domain/entities/user.dart';
import 'package:project_collaboration_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:project_collaboration_app/utils/app_exception.dart';
import 'package:project_collaboration_app/utils/result.dart';

class GetUserUseCase {
  final AuthRepository _authRepository;

  GetUserUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  Future<Result<User>> getCurrentUser() async {
    final result = await _authRepository.user;
    if (result != null) {
      return Result.ok(result);
    }
    return Result.failure(UserNotFoundException());
  }
}
