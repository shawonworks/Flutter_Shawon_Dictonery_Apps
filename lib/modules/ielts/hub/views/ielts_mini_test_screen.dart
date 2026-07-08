import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../widget/appbar/global_app_bar.dart';
import '../../../../widget/button/custom_elevated_button.dart';
import '../../../../widget/text/custom_text.dart';
import 'ielts_mini_test_controller.dart';

class IeltsMiniTestScreen extends GetView<IeltsMiniTestController> {
  const IeltsMiniTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPaper,
      appBar: const GlobalAppBar(title: 'Mini Test'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.questions.isEmpty) {
          return Center(
            child: Text(
              'Not enough vocabulary yet to build a test.',
              style: AppTypography.bodyLg(color: AppColors.ink500),
              textAlign: TextAlign.center,
            ),
          );
        }
        if (controller.isFinished.value) {
          return _ResultView(controller: controller);
        }
        return _QuestionView(controller: controller);
      }),
    );
  }
}

class _QuestionView extends StatelessWidget {
  final IeltsMiniTestController controller;
  const _QuestionView({required this.controller});

  @override
  Widget build(BuildContext context) {
    final question = controller.currentQuestion!;
    final answered = controller.selectedOption.value != null;

    return Padding(
      padding: EdgeInsets.all(AppSpacing.s4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${controller.currentIndex.value + 1} of ${controller.total}',
                style: AppTypography.labelMd(color: AppColors.ink500),
              ),
              Text('Score: ${controller.score.value}', style: AppTypography.labelMd(color: AppColors.marigold)),
            ],
          ),
          SizedBox(height: AppSpacing.s2.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: (controller.currentIndex.value + 1) / controller.total,
              minHeight: 6.h,
              backgroundColor: AppColors.bgPaperSunken,
              valueColor: AlwaysStoppedAnimation(AppColors.marigold),
            ),
          ),
          SizedBox(height: AppSpacing.s6.h),
          Text(question.prompt, style: AppTypography.headwordMd()),
          SizedBox(height: AppSpacing.s5.h),
          Expanded(
            child: ListView.separated(
              itemCount: question.options.length,
              separatorBuilder: (_, __) => SizedBox(height: AppSpacing.s3.h),
              itemBuilder: (context, index) {
                final isCorrect = index == question.correctIndex;
                final isSelected = controller.selectedOption.value == index;

                Color bg = AppColors.bgPaperRaised;
                Color border = AppColors.ink100;
                Color text = AppColors.ink900;

                if (answered) {
                  if (isCorrect) {
                    bg = AppColors.sageDim;
                    border = AppColors.sage;
                    text = AppColors.sage;
                  } else if (isSelected) {
                    bg = AppColors.brickDim;
                    border = AppColors.brick;
                    text = AppColors.brick;
                  }
                }

                return GestureDetector(
                  onTap: () => controller.selectOption(index),
                  child: AnimatedContainer(
                    duration: AppMotion.fast,
                    padding: EdgeInsets.all(AppSpacing.s4.w),
                    decoration: BoxDecoration(
                      color: bg,
                      border: Border.all(color: border, width: 1),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Text(question.options[index], style: AppTypography.bodyLg(color: text)),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: AppSpacing.s3.h),
          CustomElevatedButton(
            onPressed: answered ? controller.next : null,
            color: AppColors.marigold,
            height: 52,
            buttonBorderRadius: AppRadius.lg,
            child: CustomText(
              title: controller.currentIndex.value + 1 >= controller.total ? 'Finish' : 'Next',
              textColor: AppColors.ink900Fixed,
              fontWeight: FontWeight.w600,
              textSize: 15.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  final IeltsMiniTestController controller;
  const _ResultView({required this.controller});

  @override
  Widget build(BuildContext context) {
    final percent = controller.total == 0 ? 0 : ((controller.score.value / controller.total) * 100).round();
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.s6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events_rounded, size: 56.sp, color: AppColors.marigold),
            SizedBox(height: AppSpacing.s4.h),
            Text('$percent%', style: AppTypography.headwordXl()),
            SizedBox(height: AppSpacing.s2.h),
            Text(
              'You scored ${controller.score.value} out of ${controller.total}',
              style: AppTypography.bodyLg(color: AppColors.ink500),
            ),
            SizedBox(height: AppSpacing.s6.h),
            CustomElevatedButton(
              onPressed: controller.start,
              color: AppColors.marigold,
              width: 220,
              height: 48,
              buttonBorderRadius: AppRadius.lg,
              child: CustomText(
                title: 'Try Again',
                textColor: AppColors.ink900Fixed,
                fontWeight: FontWeight.w600,
                textSize: 15.sp,
              ),
            ),
            CustomElevatedButton(
              onPressed: () => Get.back(),
              isOutLined: true,
              outLineColour: AppColors.ink100,
              width: 220,
              height: 48,
              buttonBorderRadius: AppRadius.lg,
              child: CustomText(
                title: 'Back to Hub',
                textColor: AppColors.ink900,
                fontWeight: FontWeight.w600,
                textSize: 15.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}