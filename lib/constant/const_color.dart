import 'package:flutter/material.dart';

/// Static, compile-time color tokens.
/// Required by the shared generic widgets (CustomTextFormField,
/// CustomElevatedButton) which use `const` constructors internally.
/// Dynamic light/dark theming for the rest of the app lives in
/// `core/theme/app_colors.dart` (AppColors), which is reactive to theme mode.
class ConstColor {
  ConstColor._();

  static const primaryColor = Color(0xFFEE9C3A); // accent/marigold
  static const titleColor = Color(0xFF1D2333); // ink/900
  static const bodyColor = Color(0xFF3C4257); // ink/700
  static const outLineColor = Color(0xFFA8ACBC); // ink/300
  static const iconColor = Color(0xFFE4E1D8); // ink/100
  static const red = Color(0xFFBE5B4D); // accent/brick
}
