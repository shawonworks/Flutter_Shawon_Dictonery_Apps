import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../constant/const_string.dart';
import '../../../routes/app_routes.dart';
import '../../../widget/appbar/global_app_bar.dart';
import '../../../widget/common/app_snackbar.dart';
import '../../../widget/common/confirm_bottom_sheet.dart';
import '../../../widget/common/empty_state_widget.dart';
import '../../../widget/common/skeleton_loader.dart';
import '../../../widget/dictionary/word_result_row.dart';
import '../../main_nav/controllers/navbar_controller.dart';
import '../controllers/favorites_controller.dart';

class FavoritesScreen extends GetView<FavoritesController> {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPaper,
      appBar: GlobalAppBar(
        title: ConstString.favoritesTitle,
        showBack: false,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline_rounded, size: 20.sp, color: AppColors.ink500),
            onPressed: () async {
              if (controller.favorites.isEmpty) return;
              final count = controller.favorites.length;
              final confirmed = await ConfirmBottomSheet.show(
                message: ConstString.removeAllFavorites.replaceAll('%s', '$count'),
                confirmLabel: ConstString.removeAll,
              );
              if (confirmed) controller.clearAll();
            },
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

        if (controller.favorites.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.star_outline_rounded,
            title: ConstString.noFavoritesYet,
            body: ConstString.noFavoritesBody,
            actionLabel: ConstString.searchAWord,
            onAction: () => Get.find<NavbarController>().changeTab(0),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.s5.w, vertical: AppSpacing.s2.h),
              child: Text(
                '${controller.favorites.length} words saved',
                style: AppTypography.labelSm(color: AppColors.ink500),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.s2.w),
                itemCount: controller.favorites.length,
                itemBuilder: (context, index) {
                  final entry = controller.favorites[index];
                  return Dismissible(
                    key: ValueKey(entry.headword),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s5.w),
                      decoration: BoxDecoration(
                        color: AppColors.brick,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Icon(Icons.delete_outline_rounded, color: Colors.white, size: 20.sp),
                    ),
                    onDismissed: (_) {
                      controller.remove(entry.headword);
                      AppSnackbar.show(
                        ConstString.removedFromFavorites,
                        actionLabel: ConstString.undo,
                        onAction: () => controller.undoRemove(entry.headword),
                      );
                    },
                    child: WordResultRow(
                      entry: entry,
                      onTap: () => Get.toNamed(AppRoutes.wordDetailScreen, arguments: entry.headword),
                    ),
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
