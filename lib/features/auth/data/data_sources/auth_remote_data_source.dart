import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_collaboration_app/utils/app_exception.dart';
import 'package:project_collaboration_app/utils/result.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Result<String>> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Result.ok(credential.user!.uid);
    } on Exception {
      return Result.failure(LoginException());
    }
  }

  Future<Result<String>> createNewUser(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Result.ok(credential.user!.uid);
    } on Exception {
      return Result.failure(RegisterException());
    }
  }

  Future<VoidResult> logout() async {
    try {
      await GoogleSignIn.instance.signOut();
      await _auth.signOut();
      return Result.ok(null);
    } on Exception {
      return Result.failure(LogoutException());
    }
  }

  Future<Result<(String, String)>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser =
          await GoogleSignIn.instance.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final result = await _auth.signInWithCredential(credential);
      return Result.ok((result.user!.uid, googleUser.displayName!));
    } on Exception {
      return Result.failure(LoginException());
    }
  }
}
