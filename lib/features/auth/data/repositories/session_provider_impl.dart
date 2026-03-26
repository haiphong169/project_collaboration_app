import 'dart:async';

import 'package:project_collaboration_app/features/auth/domain/repositories/session_provider.dart';
import 'package:project_collaboration_app/features/user/data/data_sources/user_local_data_source.dart';
import 'package:project_collaboration_app/features/user/data/models/user_model.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';
import 'package:project_collaboration_app/utils/mapper_extension.dart';
import 'package:project_collaboration_app/utils/result.dart';

class SessionProviderImpl implements SessionProvider {
  final UserLocalDataSource _userLocalDataSource;

  final _controller = StreamController<User?>.broadcast();

  User? _user;

  SessionProviderImpl({required UserLocalDataSource userLocalDataSource})
    : _userLocalDataSource = userLocalDataSource;

  @override
  Stream<User?> get sessionStream => _controller.stream;

  @override
  User? get user => _user;

  @override
  String? get userUid => _user?.uid;

  @override
  Future<void> init() async {
    final result = await _userLocalDataSource.getUser();

    switch (result) {
      case Ok<UserModel?>():
        _user = result.data?.toEntity();
      case Failure<UserModel?>():
        _user = null;
    }

    _controller.add(_user);
  }

  @override
  Future<VoidResult> setUser(User? user) async {
    _user = user;
    _controller.add(_user);
    return await _userLocalDataSource.saveUser(user?.toModel());
  }

  void dispose() {
    _controller.close();
  }
}
