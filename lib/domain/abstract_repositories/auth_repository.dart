import 'package:flutter/material.dart';
import 'package:project_collaboration_app/utils/result.dart';

abstract class AuthRepository extends ChangeNotifier {
  Future<bool> get isAuthenticated;
  Future<Result<void>> login({
    String? email,
    String? password,
    bool signInWithGoogle = false,
  });
  Future<Result<void>> register(String email, String password);
  Future<Result<void>> logout();
}
