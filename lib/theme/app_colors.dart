import 'package:flutter/material.dart';

/// Palet warna game, senada dengan prototype web (langit cerah, aksen coral & ungu).
class AppColors {
  AppColors._();

  static const skyTop = Color(0xFF7EC8F2);
  static const skyBottom = Color(0xFFBFE9FF);
  static const grass = Color(0xFF4FAE4F);
  static const grassLight = Color(0xFF6FCF6F);
  static const sun = Color(0xFFFFD23F);
  static const coral = Color(0xFFFF6B6B);
  static const coralDark = Color(0xFFD84F4F);
  static const plum = Color(0xFF5B3A9B);
  static const plumDark = Color(0xFF3F2A70);
  static const ink = Color(0xFF2B2140);
  static const card = Colors.white;
  static const subtitle = Color(0xFF8B83A1);
  static const success = Color(0xFF3FAE4F);

  static const backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [skyTop, skyBottom, grassLight, grass],
    stops: [0.0, 0.62, 0.7, 1.0],
  );
}
