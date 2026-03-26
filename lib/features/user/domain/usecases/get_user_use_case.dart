import 'package:project_collaboration_app/features/auth/domain/repositories/session_provider.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';
import 'package:project_collaboration_app/utils/app_exception.dart';
import 'package:project_collaboration_app/utils/result.dart';

class GetUserUseCase {
  final SessionProvider _session;

  GetUserUseCase({required SessionProvider sessionProvider})
    : _session = sessionProvider;

  Future<Result<User>> getCurrentUser() async {
    final result = _session.user;
    if (result != null) {
      return Result.ok(result);
    }
    return Result.failure(UserNotFoundException());
  }
}
