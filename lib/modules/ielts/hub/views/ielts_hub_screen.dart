import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widget/appbar/global_app_bar.dart';

class _FeatureDef {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  const _FeatureDef({required this.icon, required this.title, required this.subtitle, this.onTap});
}

class IeltsHubScreen extends StatelessWidget {
  const IeltsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = <_FeatureDef>[
      _FeatureDef(
        icon: Icons.menu_book_rounded,
        title: 'Topic Vocabulary',
        subtitle: 'Education, health, tech and more — grouped by topic',
        onTap: () => Get.toNamed(AppRoutes.ieltsTopicPickerScreen),
      ),
      _FeatureDef(
        icon: Icons.swap_horiz_rounded,
        title: 'Synonyms & Antonyms',
        subtitle: 'Paraphrasing-focused word pairs',
        onTap: () => Get.toNamed(
          AppRoutes.ieltsWordListScreen,
          arguments: {'title': 'Synonyms & Antonyms', 'mode': 'all'},
        ),
      ),
      _FeatureDef(
        icon: Icons.workspace_premium_rounded,
        title: 'Cambridge Word Bank',
        subtitle: 'Curated, exam-frequent vocabulary',
        onTap: () => Get.toNamed(
          AppRoutes.ieltsWordListScreen,
          arguments: {'title': 'Cambridge Word Bank', 'mode': 'highFrequency'},
        ),
      ),
      _FeatureDef(
        icon: Icons.edit_note_rounded,
        title: 'Paraphrasing Practice',
        subtitle: 'Sentence rewrite practice',
        onTap: () => Get.toNamed(AppRoutes.ieltsParaphraseScreen),
      ),
      _FeatureDef(
        icon: Icons.quiz_rounded,
        title: 'Mini Tests',
        subtitle: 'MCQ & fill in the blanks',
        onTap: () => Get.toNamed(AppRoutes.ieltsMiniTestScreen),
      ),
      _FeatureDef(
        icon: Icons.calendar_today_rounded,
        title: 'Daily Word Challenge',
        subtitle: "Today's 10 words + streak",
        onTap: () => Get.toNamed(AppRoutes.ieltsDailyChallengeScreen),
      ),
      _FeatureDef(
        icon: Icons.insights_rounded,
        title: 'Progress Tracker',
        subtitle: 'Accuracy & streak history',
        onTap: () => Get.toNamed(AppRoutes.ieltsProgressScreen),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgPaper,
      appBar: const GlobalAppBar(title: 'IELTS Prep'),
      body: ListView.separated(
        padding: EdgeInsets.all(AppSpacing.s4.w),
        itemCount: features.length,
        separatorBuilder: (_, __) => SizedBox(height: AppSpacing.s3.h),
        itemBuilder: (context, index) {
          final f = features[index];
          final enabled = f.onTap != null;
          return Opacity(
            opacity: enabled ? 1 : 0.5,
            child: InkWell(
              onTap: f.onTap,
              splashFactory: NoSplash.splashFactory,
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Container(
                padding: EdgeInsets.all(AppSpacing.s4.w),
                decoration: BoxDecoration(
                  color: AppColors.bgPaperRaised,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  boxShadow: [
                    BoxShadow(color: AppColors.ink900.withAlpha(12), blurRadius: 6, offset: const Offset(0, 2)),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(color: AppColors.marigoldDim, shape: BoxShape.circle),
                      child: Icon(f.icon, size: 22.sp, color: AppColors.marigold),
                    ),
                    SizedBox(width: AppSpacing.s3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(f.title, style: AppTypography.h2()),
                          SizedBox(height: 2.h),
                          Text(f.subtitle, style: AppTypography.bodyMd(color: AppColors.ink500)),
                        ],
                      ),
                    ),
                    if (enabled) Icon(Icons.chevron_right, size: 20.sp, color: AppColors.ink300),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}