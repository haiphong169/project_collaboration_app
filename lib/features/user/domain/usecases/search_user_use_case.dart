import 'package:project_collaboration_app/features/user/domain/entities/user.dart';
import 'package:project_collaboration_app/features/user/domain/repositories/user_repository.dart';
import 'package:project_collaboration_app/utils/result.dart';

class SearchUserUseCase {
  final UserRepository _userRepository;

  SearchUserUseCase({required UserRepository userRepository})
    : _userRepository = userRepository;

  Future<Result<List<User>>> call(String query) {
    if (query.trim().isEmpty) {
      return Future.value(Result.ok([]));
    }
    return _userRepository.searchUsers(query);
  }
}
