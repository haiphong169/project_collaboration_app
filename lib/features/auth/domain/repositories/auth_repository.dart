import 'package:project_collaboration_app/utils/result.dart';

abstract class AuthRepository {
  Future<Result<String>> login(String email, String password);
  Future<Result<String>> register(
    String username,
    String email,
    String password,
  );
  Future<VoidResult> logout();
  Future<Result<(String, String)>> signInWithGoogle();
}
