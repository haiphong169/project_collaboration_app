import 'dart:async';

import 'package:project_collaboration_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:project_collaboration_app/features/user/data/data_sources/user_local_data_source.dart';
import 'package:project_collaboration_app/features/user/data/models/user_model.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';
import 'package:project_collaboration_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:project_collaboration_app/utils/result.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl({required AuthRemoteDataSource authRemoteDataSource})
    : _authRemoteDataSource = authRemoteDataSource;

  final AuthRemoteDataSource _authRemoteDataSource;

  @override
  Future<Result<String>> login(String email, String password) async {
    return await _authRemoteDataSource.login(email, password);
  }

  @override
  Future<VoidResult> logout() async {
    return await _authRemoteDataSource.logout();
  }

  @override
  Future<Result<String>> register(
    String username,
    String email,
    String password,
  ) async {
    return await _authRemoteDataSource.createNewUser(email, password);
  }

  @override
  Future<Result<(String, String)>> signInWithGoogle() async {
    return await _authRemoteDataSource.signInWithGoogle();
  }
}
