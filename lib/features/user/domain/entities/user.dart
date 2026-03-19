import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uid;
  final String username;
  final Avatar avatar;

  const User({required this.uid, required this.username, required this.avatar});

  @override
  List<Object?> get props => [uid, username, avatar];
}

class Avatar extends Equatable {
  final int backgroundColorValue;
  final int textColorValue;
  final String initials;

  const Avatar({
    required this.backgroundColorValue,
    required this.textColorValue,
    required this.initials,
  });

  @override
  List<Object?> get props => [backgroundColorValue, textColorValue, initials];
}
