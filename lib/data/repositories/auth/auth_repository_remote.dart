import 'dart:async';

import 'package:project_collaboration_app/data/services/firebase_auth_client.dart';
import 'package:project_collaboration_app/data/services/shared_preferences_client.dart';
import 'package:project_collaboration_app/domain/abstract_repositories/auth_repository.dart';
import 'package:project_collaboration_app/utils/result.dart';

class AuthRepositoryRemote extends AuthRepository {
  AuthRepositoryRemote({
    required SharedPreferencesClient sharedPreferencesClient,
    required FirebaseAuthClient firebaseAuthClient,
  }) : _sharedPreferencesClient = sharedPreferencesClient,
       _authClient = firebaseAuthClient;

  final SharedPreferencesClient _sharedPreferencesClient;
  final FirebaseAuthClient _authClient;
  bool? _isAuthenticated;

  @override
  Future<bool> get isAuthenticated async {
    if (_isAuthenticated != null) {
      return _isAuthenticated!;
    }

    await _fetchAuth();
    return _isAuthenticated ?? false;
  }

  Future<void> _fetchAuth() async {
    final result = await _sharedPreferencesClient.getAuth();

    switch (result) {
      case Ok<bool?>():
        _isAuthenticated = result.data;
      case Failure<bool?>():
        _isAuthenticated = null;
    }
  }

  @override
  Future<Result<void>> login(String email, String password) async {
    try {
      final result = await _authClient.login(email, password);
      switch (result) {
        case Ok<void>():
          _isAuthenticated = true;
          return await _sharedPreferencesClient.setAuth(true);
        case Failure<void>():
          return Result.failure(result.error);
      }
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      final result = await _authClient.logout();
      switch (result) {
        case Ok<void>():
          _isAuthenticated = false;
          return await _sharedPreferencesClient.setAuth(false);
        case Failure<void>():
          return Result.failure(result.error);
      }
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<void>> register(String email, String password) async {
    try {
      final result = await _authClient.createNewUser(email, password);
      switch (result) {
        case Ok<void>():
          _isAuthenticated = true;
          return await _sharedPreferencesClient.setAuth(true);
        case Failure<void>():
          return Result.failure(result.error);
      }
    } finally {
      notifyListeners();
    }
  }
}
