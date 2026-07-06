import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widget/appbar/global_app_bar.dart';
import '../../../../widget/common/skeleton_loader.dart';
import 'ielts_topic_picker_controller.dart';

IconData _iconFor(String name) {
  switch (name) {
    case 'school':
      return Icons.school_rounded;
    case 'favorite':
      return Icons.favorite_rounded;
    case 'memory':
      return Icons.memory_rounded;
    case 'eco':
      return Icons.eco_rounded;
    case 'work':
      return Icons.work_rounded;
    case 'groups':
      return Icons.groups_rounded;
    case 'flight':
      return Icons.flight_rounded;
    case 'gavel':
      return Icons.gavel_rounded;
    default:
      return Icons.label_rounded;
  }
}

class IeltsTopicPickerScreen extends GetView<IeltsTopicPickerController> {
  const IeltsTopicPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPaper,
      appBar: const GlobalAppBar(title: 'Topic Vocabulary'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.s2.h),
            itemCount: 6,
            itemBuilder: (_, __) => const WordResultRowSkeleton(),
          );
        }
        return GridView.builder(
          padding: EdgeInsets.all(AppSpacing.s4.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.s3.h,
            crossAxisSpacing: AppSpacing.s3.w,
            childAspectRatio: 1.15,
          ),
          itemCount: controller.topics.length,
          itemBuilder: (context, index) {
            final topic = controller.topics[index];
            final count = controller.wordCounts[topic.id] ?? 0;
            return InkWell(
              borderRadius: BorderRadius.circular(AppRadius.md),
              splashFactory: NoSplash.splashFactory,
              onTap: () => Get.toNamed(
                AppRoutes.ieltsWordListScreen,
                arguments: {'title': topic.title, 'mode': 'topic', 'topicId': topic.id},
              ),
              child: Container(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(_iconFor(topic.icon), size: 28.sp, color: AppColors.marigold),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(topic.title, style: AppTypography.h2()),
                        SizedBox(height: 2.h),
                        Text('$count words', style: AppTypography.labelSm(color: AppColors.ink500)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}