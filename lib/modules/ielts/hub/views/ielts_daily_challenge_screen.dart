import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/tts_helper.dart';
import '../../../../widget/appbar/global_app_bar.dart';
import '../../../../widget/common/skeleton_loader.dart';
import '../../../../widget/dictionary/pos_chip.dart';
import '../../../ielts_topic/views/ielts_word_entry.dart';
import 'ielts_daily_challenge_controller.dart';

class IeltsDailyChallengeScreen extends GetView<IeltsDailyChallengeController> {
  const IeltsDailyChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPaper,
      appBar: const GlobalAppBar(title: 'Daily Word Challenge'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.s2.h),
            itemCount: 6,
            itemBuilder: (_, __) => const WordResultRowSkeleton(),
          );
        }
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(AppSpacing.s4.w, AppSpacing.s3.h, AppSpacing.s4.w, AppSpacing.s2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Today\'s progress', style: AppTypography.labelMd(color: AppColors.ink500)),
                      Text(
                        '${controller.ticked.length}/${controller.total}',
                        style: AppTypography.labelMd(color: AppColors.marigold),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.s2.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: LinearProgressIndicator(
                      value: controller.total == 0 ? 0 : controller.ticked.length / controller.total,
                      minHeight: 8.h,
                      backgroundColor: AppColors.bgPaperSunken,
                      valueColor: AlwaysStoppedAnimation(AppColors.marigold),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(AppSpacing.s4.w),
                itemCount: controller.words.length,
                separatorBuilder: (_, __) => SizedBox(height: AppSpacing.s3.h),
                itemBuilder: (context, index) {
                  final entry = controller.words[index];
                  final isTicked = controller.ticked.contains(entry.headword);
                  return _ChallengeWordRow(
                    entry: entry,
                    isTicked: isTicked,
                    onTap: () => controller.toggle(entry.headword),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _ChallengeWordRow extends StatelessWidget {
  final IeltsWordEntry entry;
  final bool isTicked;
  final VoidCallback onTap;

  const _ChallengeWordRow({required this.entry, required this.isTicked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.fast,
        padding: EdgeInsets.all(AppSpacing.s4.w),
        decoration: BoxDecoration(
          color: isTicked ? AppColors.sageDim : AppColors.bgPaperRaised,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: isTicked ? AppColors.sage : Colors.transparent, width: 1),
        ),
        child: Row(
          children: [
            Icon(
              isTicked ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              size: 22.sp,
              color: isTicked ? AppColors.sage : AppColors.ink300,
            ),
            SizedBox(width: AppSpacing.s3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(child: Text(entry.headword, style: AppTypography.headwordMd())),
                      SizedBox(width: AppSpacing.s2.w),
                      PosChip(partOfSpeech: entry.partOfSpeech),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => TtsHelper.speak(entry.headword),
                        child: Icon(Icons.volume_up_rounded, size: 20.sp, color: AppColors.marigold),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(entry.bnMeaning, style: AppTypography.bodyMd(color: AppColors.ink500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}