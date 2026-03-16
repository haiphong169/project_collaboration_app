import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
      await GoogleSignIn.instance.signOut();
      await _auth.signOut();
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser =
          await GoogleSignIn.instance.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      return const Result.ok(null);
    } on Exception catch (e) {
      AppLogger().e(e);
      AppLogger().e(e.runtimeType);
      return Result.failure(e);
    }
  }
}
