import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_collaboration_app/features/user/data/models/user_model.dart';
import 'package:project_collaboration_app/utils/app_exception.dart';
import 'package:project_collaboration_app/utils/logger.dart';
import 'package:project_collaboration_app/utils/result.dart';

class UserRemoteDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _userCollection = 'users';

  Future<Result<UserModel>> getUser(String uid) async {
    try {
      final userDoc = await _db.collection(_userCollection).doc(uid).get();
      final user = UserModel.fromJson(
        userDoc.data() as Map<String, dynamic>,
        uid,
      );

      return Result.ok(user);
    } on Exception {
      return Result.failure(FirestoreException());
    }
  }

  Future<VoidResult> saveUser(String uid, UserModel user) async {
    try {
      await _db.collection(_userCollection).doc(uid).set({
        ...user.toJson(),
        'username_lowercase': user.username.toLowerCase(),
      });
      return Result.ok(null);
    } on Exception {
      return Result.failure(FirestoreException());
    }
  }

  Future<Result<List<UserModel>>> searchUsers(String query) async {
    final normalized = query.toLowerCase();
    try {
      final snapshot =
          await _db
              .collection(_userCollection)
              .where('username_lowercase', isGreaterThanOrEqualTo: normalized)
              .where(
                'username_lowercase',
                isLessThanOrEqualTo: '$normalized\uf8ff',
              )
              .limit(20)
              .get();

      return Result<List<UserModel>>.ok(
        snapshot.docs
            .map((doc) => UserModel.fromJson(doc.data(), doc.id))
            .toList(),
      );
    } on Exception catch (e) {
      AppLogger().e(e);
      return Result.failure(FirestoreException());
    }
  }
}
