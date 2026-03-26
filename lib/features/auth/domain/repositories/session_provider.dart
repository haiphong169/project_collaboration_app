import 'package:project_collaboration_app/features/user/domain/entities/user.dart';
import 'package:project_collaboration_app/utils/result.dart';

abstract class SessionProvider {
  User? get user;
  String? get userUid;
  Stream<User?> get sessionStream;
  Future<VoidResult> setUser(User? user);
  Future<void> init();
}
