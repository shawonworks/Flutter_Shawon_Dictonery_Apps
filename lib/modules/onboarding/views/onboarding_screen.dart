import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../constant/const_string.dart';
import '../../../widget/dictionary/squiggle_underline.dart';
import '../../../widget/button/custom_elevated_button.dart';
import '../../../widget/text/custom_text.dart';
import '../controllers/onboarding_controller.dart';

class _Slide {
  final IconData icon;
  final String title;
  final String body;
  const _Slide({required this.icon, required this.title, required this.body});
}

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  static const _slides = [
    _Slide(icon: Icons.search_rounded, title: ConstString.onboardTitle1, body: ConstString.onboardBody1),
    _Slide(icon: Icons.star_outline_rounded, title: ConstString.onboardTitle2, body: ConstString.onboardBody2),
    _Slide(icon: Icons.history_rounded, title: ConstString.onboardTitle3, body: ConstString.onboardBody3),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPaper,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: controller.skip,
                child: Text(ConstString.skip, style: AppTypography.buttonMd(color: AppColors.ink500)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: _slides.length,
                itemBuilder: (context, index) => _SlideView(slide: _slides[index]),
              ),
            ),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_slides.length, (i) {
                  final active = i == controller.pageIndex.value;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: active
                        ? const SquiggleUnderline(width: 20, strokeWidth: 2.5)
                        : Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: BoxDecoration(color: AppColors.ink100, shape: BoxShape.circle),
                          ),
                  );
                }),
              ),
            ),
            Obx(
              () => CustomElevatedButton(
                onPressed: controller.next,
                color: AppColors.marigold,
                buttonBorderRadius: AppRadius.lg,
                height: 52,
                left: AppSpacing.s5,
                right: AppSpacing.s5,
                top: AppSpacing.s6,
                bottom: AppSpacing.s6,
                child: CustomText(
                  title: controller.pageIndex.value == _slides.length - 1
                      ? ConstString.getStarted
                      : ConstString.next,
                  textColor: AppColors.ink900Fixed,
                  fontWeight: FontWeight.w600,
                  textSize: 15.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlideView extends StatelessWidget {
  final _Slide slide;
  const _SlideView({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96.w,
            height: 96.w,
            decoration: BoxDecoration(color: AppColors.bgPaperSunken, shape: BoxShape.circle),
            child: Icon(slide.icon, size: 40.sp, color: AppColors.marigold),
          ),
          SizedBox(height: AppSpacing.s8.h),
          Text(slide.title, style: AppTypography.h1(), textAlign: TextAlign.center),
          SizedBox(height: AppSpacing.s3.h),
          Text(slide.body, style: AppTypography.bodyLg(color: AppColors.ink500), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
