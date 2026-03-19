import 'package:project_collaboration_app/features/user/data/models/user_model.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';

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
