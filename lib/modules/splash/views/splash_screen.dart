import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../constant/const_string.dart';
import '../../../routes/app_routes.dart';
import '../../../widget/dictionary/squiggle_underline.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _onboardedKey = 'has_onboarded';

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final prefs = await SharedPreferences.getInstance();
    final hasOnboarded = prefs.getBool(_onboardedKey) ?? false;
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    Get.offNamed(hasOnboarded ? AppRoutes.mainNavScreen : AppRoutes.onboardingScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPaper,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(ConstString.appName, style: AppTypography.headwordXl()),
            SizedBox(height: 8.h),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 400),
              builder: (context, value, _) => ClipRect(
                child: Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: value,
                  child: const SquiggleUnderline(width: 40, strokeWidth: 3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
