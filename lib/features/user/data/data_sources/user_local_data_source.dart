import 'package:hive/hive.dart';
import 'package:project_collaboration_app/features/user/data/models/user_model.dart';
import 'package:project_collaboration_app/utils/app_exception.dart';
import 'package:project_collaboration_app/utils/result.dart';

class UserLocalDataSource {
  static const String _authBox = 'auth_box';
  static const String _userKey = 'user';

  Future<Box<UserModel?>> _openBox() async {
    if (Hive.isBoxOpen(_authBox)) {
      return Hive.box<UserModel?>(_authBox);
    }
    return await Hive.openBox<UserModel?>(_authBox);
  }

  Future<Result<UserModel?>> getUser() async {
    try {
      final box = await _openBox();
      return Result.ok(box.get(_userKey));
    } on Exception {
      return Result.failure(DiskIOException());
    }
  }

  Future<Result<void>> saveUser(UserModel? user) async {
    try {
      final box = await _openBox();
      return Result.ok(box.put(_userKey, user));
    } on Exception {
      return Result.failure(DiskIOException());
    }
  }
}
