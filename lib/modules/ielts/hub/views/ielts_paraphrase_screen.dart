import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../widget/appbar/global_app_bar.dart';
import '../../../../widget/button/custom_elevated_button.dart';
import '../../../../widget/text/custom_text.dart';
import 'ielts_paraphrase_controller.dart';

class IeltsParaphraseScreen extends GetView<IeltsParaphraseController> {
  const IeltsParaphraseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPaper,
      appBar: const GlobalAppBar(title: 'Paraphrasing Practice'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final exercise = controller.current;
        if (exercise == null) return const SizedBox.shrink();

        return Padding(
          padding: EdgeInsets.all(AppSpacing.s4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${controller.currentIndex.value + 1} / ${controller.total}',
                style: AppTypography.labelMd(color: AppColors.ink500),
              ),
              SizedBox(height: AppSpacing.s3.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppSpacing.s4.w),
                    decoration: BoxDecoration(
                      color: AppColors.bgPaperRaised,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      boxShadow: [
                        BoxShadow(color: AppColors.ink900.withAlpha(12), blurRadius: 6, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise.topic.toUpperCase(),
                          style: AppTypography.labelMd(color: AppColors.marigold),
                        ),
                        SizedBox(height: AppSpacing.s3.h),
                        _HighlightedSentence(sentence: exercise.original, target: exercise.targetWord),
                        SizedBox(height: AppSpacing.s4.h),
                        Text('Try rewriting with:', style: AppTypography.labelSm(color: AppColors.ink500)),
                        SizedBox(height: AppSpacing.s2.h),
                        Wrap(
                          spacing: AppSpacing.s2.w,
                          runSpacing: AppSpacing.s2.h,
                          children: exercise.hintSynonyms
                              .map(
                                (s) => Container(
                              padding: EdgeInsets.symmetric(horizontal: AppSpacing.s3.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: AppColors.sageDim,
                                borderRadius: BorderRadius.circular(AppRadius.pill),
                              ),
                              child: Text(s, style: AppTypography.labelSm(color: AppColors.sage)),
                            ),
                          )
                              .toList(),
                        ),
                        SizedBox(height: AppSpacing.s5.h),
                        if (!controller.isRevealed.value)
                          CustomElevatedButton(
                            onPressed: controller.reveal,
                            isOutLined: true,
                            outLineColour: AppColors.marigold,
                            height: 44,
                            buttonBorderRadius: AppRadius.lg,
                            child: CustomText(
                              title: 'Show Sample Answer',
                              textColor: AppColors.marigold,
                              fontWeight: FontWeight.w600,
                              textSize: 14.sp,
                            ),
                          )
                        else
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(AppSpacing.s3.w),
                            decoration: BoxDecoration(
                              color: AppColors.bgPaperSunken,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            child: Text(exercise.sampleParaphrase, style: AppTypography.bodyLg()),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.s4.h),
              Row(
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      onPressed: controller.currentIndex.value > 0 ? controller.previous : null,
                      isOutLined: true,
                      outLineColour: AppColors.ink100,
                      height: 48,
                      buttonBorderRadius: AppRadius.lg,
                      child: CustomText(
                        title: 'Previous',
                        textColor: AppColors.ink900,
                        fontWeight: FontWeight.w600,
                        textSize: 14.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.s3.w),
                  Expanded(
                    child: CustomElevatedButton(
                      onPressed: controller.next,
                      color: AppColors.marigold,
                      height: 48,
                      buttonBorderRadius: AppRadius.lg,
                      child: CustomText(
                        title: 'Next',
                        textColor: AppColors.ink900Fixed,
                        fontWeight: FontWeight.w600,
                        textSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _HighlightedSentence extends StatelessWidget {
  final String sentence;
  final String target;
  const _HighlightedSentence({required this.sentence, required this.target});

  @override
  Widget build(BuildContext context) {
    final lower = sentence.toLowerCase();
    final targetLower = target.toLowerCase();
    final index = lower.indexOf(targetLower);

    if (index == -1) {
      return Text(sentence, style: AppTypography.bodyLg());
    }

    return RichText(
      text: TextSpan(
        style: AppTypography.bodyLg(),
        children: [
          TextSpan(text: sentence.substring(0, index)),
          TextSpan(
            text: sentence.substring(index, index + target.length),
            style: AppTypography.bodyLg(color: AppColors.marigold).copyWith(fontWeight: FontWeight.w700),
          ),
          TextSpan(text: sentence.substring(index + target.length)),
        ],
      ),
    );
  }
}