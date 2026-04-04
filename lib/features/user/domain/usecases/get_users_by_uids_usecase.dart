import 'package:project_collaboration_app/features/user/domain/entities/user.dart';
import 'package:project_collaboration_app/features/user/domain/repositories/user_repository.dart';

class GetUsersByUidsUseCase {
  final UserRepository _userRepository;

  GetUsersByUidsUseCase({required UserRepository userRepository})
    : _userRepository = userRepository;

  Future<List<User>> call(List<String> uids) {
    return _userRepository.getUsersByIds(uids);
  }
}
