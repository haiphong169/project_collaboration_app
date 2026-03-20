import 'package:project_collaboration_app/features/user/data/data_sources/user_remote_data_source.dart';
import 'package:project_collaboration_app/features/user/data/models/user_model.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';
import 'package:project_collaboration_app/features/user/domain/repositories/user_repository.dart';
import 'package:project_collaboration_app/utils/result.dart';

class UserRepositoryImpl extends UserRepository {
  final UserRemoteDataSource _userRemoteDataSource;

  UserRepositoryImpl({required UserRemoteDataSource userRemoteDataSource})
    : _userRemoteDataSource = userRemoteDataSource;

  @override
  Future<Result<User>> getUser(String uid) {
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> saveUser(String uid) {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<User>>> searchUsers(String query) async {
    final result = await _userRemoteDataSource.searchUsers(query);
    switch (result) {
      case Ok<List<UserModel>>():
        return Result<List<User>>.ok(
          result.data.map((model) => model.toEntity()).toList(),
        );
      case Failure<List<UserModel>>():
        return Result.failure(result.error);
    }
  }
}
