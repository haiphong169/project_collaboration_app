import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_collaboration_app/utils/logger.dart';
import 'package:project_collaboration_app/utils/result.dart';

class FirebaseAuthClient {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Result<void>> createNewUser(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      AppLogger().d(credential.toString());
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      AppLogger().d(credential.toString());
      return const Result.ok(null);
    } on Exception catch (e) {
      AppLogger().e(e);
      return Result.failure(e);
    }
  }

  Future<Result<void>> logout() async {
    try {
      await _auth.signOut();
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
