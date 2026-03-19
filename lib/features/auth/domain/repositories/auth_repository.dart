import 'package:flutter/material.dart';
import 'package:project_collaboration_app/features/auth/domain/entities/user.dart';
import 'package:project_collaboration_app/utils/result.dart';

abstract class AuthRepository extends ChangeNotifier {
  Future<User?> get user;
  Future<VoidResult> login(String email, String password);
  Future<VoidResult> register(String username, String email, String password);
  Future<VoidResult> logout();
  Future<VoidResult> signInWithGoogle();
}
