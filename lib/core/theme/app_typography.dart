import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Three type voices: Frances for headwords, Inter for UI/body,
/// IBM Plex Mono for phonetic transcription.
class AppTypography {
  AppTypography._();

  static TextStyle _base(
    TextStyle Function({
      TextStyle? textStyle,
      Color? color,
      double? fontSize,
      FontWeight? fontWeight,
      double? height,
      double? letterSpacing,
    }) font, {
    required double size,
    required double lineHeight,
    required FontWeight weight,
    Color? color,
    double? letterSpacing,
  }) {
    return font(
      color: color ?? AppColors.ink900,
      fontSize: size.sp,
      fontWeight: weight,
      height: lineHeight / size,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle headwordXl({Color? color}) => _base(GoogleFonts.fraunces,
      size: 40, lineHeight: 44, weight: FontWeight.w500, color: color);

  static TextStyle headwordLg({Color? color}) => _base(GoogleFonts.fraunces,
      size: 28, lineHeight: 34, weight: FontWeight.w500, color: color);

  static TextStyle headwordMd({Color? color}) => _base(GoogleFonts.fraunces,
      size: 22, lineHeight: 28, weight: FontWeight.w500, color: color);

  static TextStyle h1({Color? color}) => _base(GoogleFonts.inter,
      size: 24, lineHeight: 30, weight: FontWeight.w700, color: color);

  static TextStyle h2({Color? color}) => _base(GoogleFonts.inter,
      size: 18, lineHeight: 24, weight: FontWeight.w600, color: color);

  static TextStyle bodyLg({Color? color}) => _base(GoogleFonts.inter,
      size: 17, lineHeight: 26, weight: FontWeight.w400, color: color);

  static TextStyle bodyMd({Color? color}) => _base(GoogleFonts.inter,
      size: 15, lineHeight: 22, weight: FontWeight.w400, color: color);

  static TextStyle labelMd({Color? color}) => _base(
        GoogleFonts.inter,
        size: 13,
        lineHeight: 18,
        weight: FontWeight.w600,
        color: color,
        letterSpacing: 0.4,
      );

  static TextStyle labelSm({Color? color}) => _base(GoogleFonts.inter,
      size: 12, lineHeight: 16, weight: FontWeight.w500, color: color);

  static TextStyle monoPhonetic({Color? color}) {
    final base = _base(
      GoogleFonts.ibmPlexMono,
      size: 15, lineHeight: 20, weight: FontWeight.w400, color: color,
    );
    final notoFamily = GoogleFonts.notoSans().fontFamily; // actually fetches/registers it
    return base.copyWith(fontFamilyFallback: [if (notoFamily != null) notoFamily]);
  }

  static TextStyle buttonMd({Color? color}) => _base(GoogleFonts.inter,
      size: 15, lineHeight: 20, weight: FontWeight.w600, color: color);
}
