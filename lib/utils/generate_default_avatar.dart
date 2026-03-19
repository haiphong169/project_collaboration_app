import 'dart:math';

import 'package:flutter/material.dart';
import 'package:project_collaboration_app/features/auth/data/models/user_model.dart';

class AvatarGenerator {
  static int _generateAvatarColorValue() {
    final random = Random();

    final hue = random.nextDouble() * 360;
    final saturation = 0.6 + random.nextDouble() * 0.3;
    final value = 0.7 + random.nextDouble() * 0.2;

    final color = HSVColor.fromAHSV(1.0, hue, saturation, value).toColor();
    return color.value;
  }

  static int _getTextColorValue(int backgroundColorValue) {
    final backgroundColor = Color(backgroundColorValue);

    final isLight = backgroundColor.computeLuminance() > 0.5;

    return isLight ? Colors.black.value : Colors.white.value;
  }

  static String _pickInitialsFromUsername(String username) {
    final random = Random();
    String randomChar = username[random.nextInt(username.length - 1) + 1];
    return username[0] + randomChar;
  }

  static AvatarModel generateDefaultAvatar(String username) {
    final backgroundColorValue = _generateAvatarColorValue();
    final textColorValue = _getTextColorValue(backgroundColorValue);
    final initials = _pickInitialsFromUsername(username);

    return AvatarModel(
      backgroundColorValue: backgroundColorValue,
      textColorValue: textColorValue,
      initials: initials,
    );
  }
}
