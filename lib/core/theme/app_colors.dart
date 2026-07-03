import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Reactive design-token colors for the "Annotated Paper" theme.
/// Reads the active brightness from GetX so every widget that calls
/// `AppColors.x` always resolves to the correct light/dark value
/// without needing BuildContext.
class AppColors {
  AppColors._();

  static bool get _dark => Get.isDarkMode;

  // Surfaces
  static Color get bgPaper => _dark ? const Color(0xFF14161D) : const Color(0xFFFAF7F1);
  static Color get bgPaperRaised => _dark ? const Color(0xFF1D2029) : const Color(0xFFFFFFFF);
  static Color get bgPaperSunken => _dark ? const Color(0xFF262A35) : const Color(0xFFF0EBE1);

  // Ink (text)
  static Color get ink900 => _dark ? const Color(0xFFF3F1EA) : const Color(0xFF1D2333);
  static Color get ink700 => _dark ? const Color(0xFFD3D2CC) : const Color(0xFF3C4257);
  static Color get ink500 => _dark ? const Color(0xFF8F92A0) : const Color(0xFF6B7189);
  static Color get ink300 => _dark ? const Color(0xFF5C5F6D) : const Color(0xFFA8ACBC);
  static Color get ink100 => _dark ? const Color(0xFF2E323D) : const Color(0xFFE4E1D8);

  // Accents
  static Color get marigold => _dark ? const Color(0xFFF2AA55) : const Color(0xFFEE9C3A);
  static Color get marigoldDim => _dark ? marigold.withAlpha(46) : const Color(0xFFF8E3C2);
  static Color get sage => _dark ? const Color(0xFF7BA294) : const Color(0xFF5C8374);
  static Color get sageDim => _dark ? sage.withAlpha(46) : const Color(0xFFDCE7E1);
  static Color get brick => _dark ? const Color(0xFFD97A6C) : const Color(0xFFBE5B4D);
  static Color get brickDim => _dark ? brick.withAlpha(46) : const Color(0xFFF3DBD6);

  // Fixed (theme independent)
  static const Color inkPaperFixed = Color(0xFFFAF7F1);
  static const Color ink900Fixed = Color(0xFF1D2333);
}
