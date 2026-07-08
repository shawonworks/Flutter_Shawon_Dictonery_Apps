import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widget/appbar/global_app_bar.dart';
import '../../../../widget/button/custom_elevated_button.dart';
import '../../../../widget/text/custom_text.dart';
import 'ielts_progress_controller.dart';

class IeltsProgressScreen extends GetView<IeltsProgressController> {
  const IeltsProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPaper,
      appBar: const GlobalAppBar(title: 'Progress Tracker'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final s = controller.summary.value;
        return ListView(
          padding: EdgeInsets.all(AppSpacing.s4.w),
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.local_fire_department_rounded,
                    iconColor: AppColors.marigold,
                    label: 'Current Streak',
                    value: '${s.currentStreak}',
                    suffix: s.currentStreak == 1 ? 'day' : 'days',
                  ),
                ),
                SizedBox(width: AppSpacing.s3.w),
                Expanded(
                  child: _StatCard(
                    icon: Icons.emoji_events_rounded,
                    iconColor: AppColors.sage,
                    label: 'Longest Streak',
                    value: '${s.longestStreak}',
                    suffix: s.longestStreak == 1 ? 'day' : 'days',
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.s3.h),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.calendar_month_rounded,
                    iconColor: AppColors.ink500,
                    label: 'Days Completed',
                    value: '${s.totalDaysCompleted}',
                    suffix: 'total',
                  ),
                ),
                SizedBox(width: AppSpacing.s3.w),
                Expanded(
                  child: _StatCard(
                    icon: Icons.menu_book_rounded,
                    iconColor: AppColors.ink500,
                    label: 'Words Learned',
                    value: '${s.totalWordsLearned}',
                    suffix: 'lifetime',
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.s3.h),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.track_changes_rounded,
                    iconColor: AppColors.sage,
                    label: 'Test Accuracy',
                    value: controller.accuracy.value.totalTestsCompleted > 0
                        ? '${controller.accuracy.value.averageAccuracyPercent.round()}%'
                        : '—',
                    suffix: 'average',
                  ),
                ),
                SizedBox(width: AppSpacing.s3.w),
                Expanded(
                  child: _StatCard(
                    icon: Icons.quiz_rounded,
                    iconColor: AppColors.ink500,
                    label: 'Tests Taken',
                    value: '${controller.accuracy.value.totalTestsCompleted}',
                    suffix: 'total',
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.s6.h),
            CustomElevatedButton(
              onPressed: () =>
                  Get.toNamed(AppRoutes.ieltsDailyChallengeScreen)?.then((_) => controller.refresh_()),
              color: AppColors.marigold,
              buttonBorderRadius: AppRadius.lg,
              height: 52,
              child: const CustomText(
                title: "Continue Today's Challenge",
                textColor: AppColors.ink900Fixed,
                fontWeight: FontWeight.w600,
                textSize: 15,
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String suffix;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.s4.w),
      decoration: BoxDecoration(
        color: AppColors.bgPaperRaised,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [BoxShadow(color: AppColors.ink900.withAlpha(12), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24.sp, color: iconColor),
          SizedBox(height: AppSpacing.s2.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: AppTypography.headwordLg()),
              SizedBox(width: 4.w),
              Text(suffix, style: AppTypography.labelSm(color: AppColors.ink500)),
            ],
          ),
          SizedBox(height: 2.h),
          Text(label, style: AppTypography.labelMd(color: AppColors.ink500)),
        ],
      ),
    );
  }
}