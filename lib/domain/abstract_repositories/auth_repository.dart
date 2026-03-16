import 'package:flutter/material.dart';

abstract class AuthRepository extends ChangeNotifier {
  Future<bool> get isAuthenticated;
  Future<void> login(String email, String password);
  Future<void> register(String email, String password);
  Future<void> logout();
}
