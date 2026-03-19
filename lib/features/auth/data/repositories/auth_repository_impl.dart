import 'dart:async';

import 'package:project_collaboration_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:project_collaboration_app/features/auth/data/data_sources/user_local_data_source.dart';
import 'package:project_collaboration_app/features/auth/data/data_sources/user_remote_data_source.dart';
import 'package:project_collaboration_app/features/auth/data/models/user_model.dart';
import 'package:project_collaboration_app/features/auth/domain/entities/user.dart';
import 'package:project_collaboration_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:project_collaboration_app/utils/generate_default_avatar.dart';
import 'package:project_collaboration_app/utils/result.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource authRemoteDataSource,
    required UserRemoteDataSource userRemoteDataSource,
    required UserLocalDataSource userLocalDataSource,
  }) : _authRemoteDataSource = authRemoteDataSource,
       _userRemoteDataSource = userRemoteDataSource,
       _userLocalDataSource = userLocalDataSource;

  final AuthRemoteDataSource _authRemoteDataSource;
  final UserRemoteDataSource _userRemoteDataSource;
  final UserLocalDataSource _userLocalDataSource;
  User? _user;

  @override
  Future<User?> get user async {
    if (_user != null) {
      return _user!;
    }

    await _fetchUser();
    return _user;
  }

  Future<void> _fetchUser() async {
    final result = await _userLocalDataSource.getUser();

    switch (result) {
      case Ok<UserModel?>():
        _user = result.data?.toEntity();
      case Failure<UserModel?>():
        _user = null;
    }
  }

  @override
  Future<VoidResult> login(String email, String password) async {
    try {
      final result = await _authRemoteDataSource.login(email, password);
      switch (result) {
        case Ok<String>():
          final uid = result.data;
          final dbResult = await _userRemoteDataSource.getUser(uid);
          switch (dbResult) {
            case Ok<UserModel>():
              return await _userLocalDataSource.saveUser(dbResult.data);
            case Failure<UserModel>():
              return Result.failure(dbResult.error);
          }
        case Failure<String>():
          return Result.failure(result.error);
      }
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<VoidResult> logout() async {
    try {
      final result = await _authRemoteDataSource.logout();
      switch (result) {
        case Ok<void>():
          _user = null;
          return await _userLocalDataSource.saveUser(null);
        case Failure<void>():
          return Result.failure(result.error);
      }
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<VoidResult> register(
    String username,
    String email,
    String password,
  ) async {
    try {
      final result = await _authRemoteDataSource.createNewUser(email, password);
      switch (result) {
        case Ok<String>():
          final user = UserModel(
            uid: result.data,
            username: username,
            avatar: AvatarGenerator.generateDefaultAvatar(username),
          );
          final dbResult = await _userRemoteDataSource.saveUser(
            result.data,
            user,
          );
          switch (dbResult) {
            case Ok<void>():
              return await _userLocalDataSource.saveUser(user);
            case Failure<void>():
              return Result.failure(dbResult.error);
          }

        case Failure<String>():
          return Result.failure(result.error);
      }
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<VoidResult> signInWithGoogle() async {
    try {
      final result = await _authRemoteDataSource.signInWithGoogle();
      switch (result) {
        case Ok<(String, String)>():
          final user = UserModel(
            uid: result.data.$1,
            username: result.data.$2,
            avatar: AvatarGenerator.generateDefaultAvatar(result.data.$2),
          );
          final dbResult = await _userRemoteDataSource.saveUser(
            result.data.$1,
            user,
          );
          switch (dbResult) {
            case Ok<void>():
              return await _userLocalDataSource.saveUser(user);
            case Failure<void>():
              return Result.failure(dbResult.error);
          }
        case Failure<(String, String)>():
          return Result.failure(result.error);
      }
    } finally {
      notifyListeners();
    }
  }
}
