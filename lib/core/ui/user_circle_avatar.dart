import 'package:flutter/material.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';

class UserCircleAvatar extends StatelessWidget {
  const UserCircleAvatar({super.key, required this.avatar, this.radius = 64});

  final Avatar avatar;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Color(avatar.backgroundColorValue),
      child: Text(
        avatar.initials,
        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
          color: Color(avatar.textColorValue),
        ),
      ),
    );
  }
}
