import 'package:hive/hive.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String username;
  @HiveField(2)
  final AvatarModel avatar;

  const UserModel({
    required this.uid,
    required this.username,
    required this.avatar,
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'username': username,
    'avatar': avatar.toJson(),
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    uid: json['uid'] as String,
    username: json['username'] as String,
    avatar: AvatarModel.fromJson(json['avatar'] as Map<String, dynamic>),
  );

  User toEntity() {
    return User(uid: uid, username: username, avatar: avatar.toEntity());
  }
}

@HiveType(typeId: 1)
class AvatarModel {
  @HiveField(0)
  final int backgroundColorValue;
  @HiveField(1)
  final int textColorValue;
  @HiveField(2)
  final String initials;

  const AvatarModel({
    required this.backgroundColorValue,
    required this.textColorValue,
    required this.initials,
  });

  Map<String, dynamic> toJson() => {
    'backgroundColorValue': backgroundColorValue,
    'textColorValue': textColorValue,
    'initials': initials,
  };

  factory AvatarModel.fromJson(Map<String, dynamic> json) => AvatarModel(
    backgroundColorValue: json['backgroundColorValue'] as int,
    textColorValue: json['textColorValue'] as int,
    initials: json['initials'] as String,
  );

  Avatar toEntity() {
    return Avatar(
      backgroundColorValue: backgroundColorValue,
      textColorValue: textColorValue,
      initials: initials,
    );
  }
}
