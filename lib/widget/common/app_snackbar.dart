import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';

class AppSnackbar {
  AppSnackbar._();

  static void show(String message, {String? actionLabel, VoidCallback? onAction}) {
    Get.rawSnackbar(
      messageText: Text(message, style: TextStyle(color: AppColors.inkPaperFixed, fontSize: 14.sp)),
      backgroundColor: AppColors.ink900Fixed,
      borderRadius: AppRadius.md,
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.s5.w, vertical: AppSpacing.s4.h),
      duration: const Duration(milliseconds: 2500),
      snackPosition: SnackPosition.BOTTOM,
      mainButton: actionLabel != null
          ? TextButton(
              onPressed: () {
                onAction?.call();
                Get.closeCurrentSnackbar();
              },
              child: Text(
                actionLabel,
                style: TextStyle(color: AppColors.marigold, fontWeight: FontWeight.w600, fontSize: 14.sp),
              ),
            )
          : null,
    );
  }
}
