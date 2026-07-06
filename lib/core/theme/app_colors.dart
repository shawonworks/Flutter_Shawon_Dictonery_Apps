import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColors {
  AppColors._();

  static bool get _dark => Get.isDarkMode;

  // Surfaces
  static Color get bgPaper => _dark ? const Color(0xFF12140F) : const Color(0xFFF6F5F1);
  static Color get bgPaperRaised => _dark ? const Color(0xFF1A1D16) : const Color(0xFFFCFBF8);
  static Color get bgPaperSunken => _dark ? const Color(0xFF21251C) : const Color(0xFFECE9E2);

  // Ink (text)
  static Color get ink900 => _dark ? const Color(0xFFEDEEE8) : const Color(0xFF1C1E1A);
  static Color get ink700 => _dark ? const Color(0xFFC9CCC0) : const Color(0xFF3A3D36);
  static Color get ink500 => _dark ? const Color(0xFF8B9082) : const Color(0xFF6B6F66);
  static Color get ink300 => _dark ? const Color(0xFF565A4E) : const Color(0xFFA6AA9F);
  static Color get ink100 => _dark ? const Color(0xFF2A2E22) : const Color(0xFFDCDCD2);

  // Accents — primary: Forest green, secondary: warm Ochre, error: Brick
  static Color get marigold => _dark ? const Color(0xFF4F9C74) : const Color(0xFF2F6E4F);
  static Color get marigoldDim => _dark ? marigold.withAlpha(46) : const Color(0xFFDCEAE1);
  static Color get sage => _dark ? const Color(0xFFE3A35E) : const Color(0xFFD98C3D);
  static Color get sageDim => _dark ? sage.withAlpha(46) : const Color(0xFFF4E3CC);
  static Color get brick => _dark ? const Color(0xFFD97A6C) : const Color(0xFFBE5B4D);
  static Color get brickDim => _dark ? brick.withAlpha(46) : const Color(0xFFF3DCD4);

  // Fixed (theme independent) — used by AppSnackbar (always dark bg)
  static const Color inkPaperFixed = Color(0xFFF6F5F1);
  static const Color ink900Fixed = Color(0xFF1C1E1A);
}