import 'package:project_collaboration_app/features/user/domain/entities/user.dart';
import 'package:project_collaboration_app/utils/result.dart';

abstract class UserRepository {
  Future<VoidResult> createUser(User user);
  Future<Result<User>> getUser(String uid);
  Future<Result<List<User>>> searchUsers(String query);
  Future<List<User>> getUsersByIds(List<String> uids);
}
