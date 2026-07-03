import 'package:flutter/material.dart';

/// 8pt spacing scale.
class AppSpacing {
  AppSpacing._();
  static const s1 = 4.0;
  static const s2 = 8.0;
  static const s3 = 12.0;
  static const s4 = 16.0;
  static const s5 = 20.0;
  static const s6 = 24.0;
  static const s8 = 32.0;
  static const s10 = 40.0;
  static const s12 = 48.0;
}

class AppRadius {
  AppRadius._();
  static const sm = 8.0;
  static const md = 14.0;
  static const lg = 24.0;
  static const pill = 999.0;
}

class AppMotion {
  AppMotion._();
  static const instant = Duration(milliseconds: 100);
  static const fast = Duration(milliseconds: 180);
  static const base = Duration(milliseconds: 240);
  static const slow = Duration(milliseconds: 400);

  static const Curve easeOut = Curves.easeOut;
  static const Curve fastCurve = Curves.easeOutCubic;
  static const Curve baseCurve = Curves.easeInOutCubic;
  static const Curve slowCurve = Curves.easeOutQuint;
}
