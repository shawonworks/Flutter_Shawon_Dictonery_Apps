import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/tts_helper.dart';
import '../../../../widget/appbar/global_app_bar.dart';
import '../../../../widget/common/empty_state_widget.dart';
import '../../../../widget/common/skeleton_loader.dart';
import '../../../../widget/dictionary/pos_chip.dart';
import '../../../ielts_topic/views/ielts_word_entry.dart';
import 'ielts_word_list_controller.dart';

class IeltsWordListScreen extends StatelessWidget {
  const IeltsWordListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>? ?? const {};
    final title = args['title'] as String? ?? 'Word List';
    final mode = args['mode'] as String? ?? 'all';
    final topicId = args['topicId'] as String?;
    final controller = Get.find<IeltsWordListController>(tag: '$mode-${topicId ?? ''}');

    return Scaffold(
      backgroundColor: AppColors.bgPaper,
      appBar: GlobalAppBar(title: title),
      body: Obx(() {
        if (controller.isLoading.value) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.s2.h),
            itemCount: 6,
            itemBuilder: (_, __) => const WordResultRowSkeleton(),
          );
        }
        if (controller.hasError.value) {
          return EmptyStateWidget(
            icon: Icons.wifi_off_rounded,
            title: 'Could not load data',
            body: 'Check the asset is registered correctly and restart the app',
            isError: true,
            actionLabel: 'Try Again',
            onAction: controller.retry,
          );
        }
        return ListView.separated(
          padding: EdgeInsets.all(AppSpacing.s4.w),
          itemCount: controller.words.length,
          separatorBuilder: (_, __) => SizedBox(height: AppSpacing.s3.h),
          itemBuilder: (context, index) => _WordCard(entry: controller.words[index]),
        );
      }),
    );
  }
}

class _WordCard extends StatelessWidget {
  final IeltsWordEntry entry;
  const _WordCard({required this.entry});

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
          Row(
            children: [
              Flexible(child: Text(entry.headword, style: AppTypography.headwordMd())),
              SizedBox(width: AppSpacing.s2.w),
              PosChip(partOfSpeech: entry.partOfSpeech),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.volume_up_rounded, size: 20.sp, color: AppColors.marigold),
                onPressed: () => TtsHelper.speak(entry.headword),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(entry.bnMeaning, style: AppTypography.bodyMd(color: AppColors.sage)),
          SizedBox(height: AppSpacing.s2.h),
          Text(entry.definition, style: AppTypography.bodyLg()),
          SizedBox(height: 4.h),
          Text(
            '"${entry.example}"',
            style: AppTypography.bodyMd(color: AppColors.ink500).copyWith(fontStyle: FontStyle.italic),
          ),
          if (entry.synonyms.isNotEmpty || entry.antonyms.isNotEmpty) ...[
            SizedBox(height: AppSpacing.s3.h),
            Wrap(
              spacing: AppSpacing.s2.w,
              runSpacing: AppSpacing.s2.h,
              children: [
                ...entry.synonyms.map((s) => _LabelChip(label: s, color: AppColors.sage, bg: AppColors.sageDim)),
                ...entry.antonyms.map((a) => _LabelChip(label: a, color: AppColors.brick, bg: AppColors.brickDim)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _LabelChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;
  const _LabelChip({required this.label, required this.color, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s2.w, vertical: 4.h),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppRadius.pill)),
      child: Text(label, style: AppTypography.labelSm(color: color)),
    );
  }
}