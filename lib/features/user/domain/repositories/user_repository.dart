import 'package:project_collaboration_app/features/user/domain/entities/user.dart';
import 'package:project_collaboration_app/utils/result.dart';

abstract class UserRepository {
  Future<Result<User>> getUser(String uid);
  Future<Result<void>> saveUser(String uid);
  Future<Result<List<User>>> searchUsers(String query);
}
