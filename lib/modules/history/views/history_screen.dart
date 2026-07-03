import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../constant/const_string.dart';
import '../../../routes/app_routes.dart';
import '../../../widget/appbar/global_app_bar.dart';
import '../../../widget/common/confirm_bottom_sheet.dart';
import '../../../widget/common/empty_state_widget.dart';
import '../../../widget/common/skeleton_loader.dart';
import '../../../widget/dictionary/word_result_row.dart';
import '../controllers/history_controller.dart';

class HistoryScreen extends GetView<HistoryController> {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPaper,
      appBar: GlobalAppBar(
        title: ConstString.historyTitle,
        showBack: false,
        actions: [
          TextButton(
            onPressed: () async {
              if (controller.isEmpty) return;
              final confirmed = await ConfirmBottomSheet.show(
                message: ConstString.clearHistoryConfirm,
                confirmLabel: ConstString.remove,
              );
              if (confirmed) controller.clearAll();
            },
            child: Text(ConstString.clear, style: AppTypography.labelMd(color: AppColors.ink500)),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.s2.h),
            itemCount: 5,
            itemBuilder: (_, __) => const WordResultRowSkeleton(),
          );
        }

        if (controller.groups.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.history_rounded,
            title: ConstString.nothingLookedUp,
            body: ConstString.nothingLookedUpBody,
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s3.w, vertical: AppSpacing.s2.h),
          itemCount: controller.groups.length,
          itemBuilder: (context, groupIndex) {
            final group = controller.groups[groupIndex];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(AppSpacing.s2.w, AppSpacing.s3.h, 0, AppSpacing.s2.h),
                  child: Text(group.label, style: AppTypography.labelMd(color: AppColors.ink500)),
                ),
                ...group.items.map(
                  (item) => WordResultRow(
                    entry: item.entry,
                    trailing: Text(_formatTime(item.viewedAt), style: AppTypography.labelSm(color: AppColors.ink300)),
                    onTap: () => Get.toNamed(AppRoutes.wordDetailScreen, arguments: item.entry.headword)
                        ?.then((_) => controller.refresh_()),
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
