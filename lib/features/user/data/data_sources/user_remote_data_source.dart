import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_collaboration_app/features/user/data/models/user_model.dart';
import 'package:project_collaboration_app/utils/app_exception.dart';
import 'package:project_collaboration_app/utils/result.dart';

class UserRemoteDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _userCollection = 'users';

  Future<Result<UserModel>> getUser(String uid) async {
    try {
      final userDoc = await _db.collection(_userCollection).doc(uid).get();
      final user = UserModel.fromJson(userDoc.data() as Map<String, dynamic>);

      return Result.ok(user);
    } on Exception {
      return Result.failure(FirestoreException());
    }
  }

  Future<VoidResult> saveUser(String uid, UserModel user) async {
    try {
      await _db.collection(_userCollection).doc(uid).set(user.toJson());
      return Result.ok(null);
    } on Exception {
      return Result.failure(FirestoreException());
    }
  }
}
