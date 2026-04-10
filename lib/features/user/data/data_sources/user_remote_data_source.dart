import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_collaboration_app/features/user/data/models/user_model.dart';
import 'package:project_collaboration_app/utils/app_exception.dart';
import 'package:project_collaboration_app/utils/firebase_path.dart';
import 'package:project_collaboration_app/utils/result.dart';

class UserRemoteDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Result<UserModel>> getUser(String uid) async {
    try {
      final userDoc = await _db.collection(FirebasePath.users).doc(uid).get();
      if (userDoc.exists) {
        final user = UserModel.fromJson(
          userDoc.data() as Map<String, dynamic>,
          uid,
        );

        return Result.ok(user);
      } else {
        return Result.failure(UserNotFoundException());
      }
    } on Exception {
      return Result.failure(FirestoreException());
    }
  }

  Future<List<UserModel>> getUsersByIds(List<String> uids) async {
    if (uids.isEmpty) return [];
    final snapshots =
        await _db
            .collection(FirebasePath.users)
            .where(FieldPath.documentId, whereIn: uids)
            .get();

    return snapshots.docs
        .map((doc) => UserModel.fromJson(doc.data(), doc.id))
        .toList();
  }

  Future<VoidResult> saveUser(String uid, UserModel user) async {
    try {
      await _db.collection(FirebasePath.users).doc(uid).set({
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
              .collection(FirebasePath.users)
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
      return Result.failure(FirestoreException());
    }
  }
}
