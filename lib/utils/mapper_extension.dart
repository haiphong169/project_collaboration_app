import 'package:project_collaboration_app/features/auth/data/models/user_model.dart';
import 'package:project_collaboration_app/features/auth/domain/entities/user.dart';

extension UserMapper on User {
  UserModel toModel() {
    return UserModel(uid: uid, username: username, avatar: avatar.toModel());
  }
}

extension AvatarMapper on Avatar {
  AvatarModel toModel() {
    return AvatarModel(
      backgroundColorValue: backgroundColorValue,
      textColorValue: textColorValue,
      initials: initials,
    );
  }
}
