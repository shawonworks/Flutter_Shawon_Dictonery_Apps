import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/app_typography.dart';
import '../../constant/const_string.dart';
import '../button/custom_elevated_button.dart';
import '../text/custom_text.dart';

class ConfirmBottomSheet {
  ConfirmBottomSheet._();

  static Future<bool> show({required String message, required String confirmLabel}) async {
    final result = await Get.bottomSheet<bool>(
      Container(
        padding: EdgeInsets.fromLTRB(AppSpacing.s5.w, AppSpacing.s3.h, AppSpacing.s5.w, AppSpacing.s8.h),
        decoration: BoxDecoration(
          color: AppColors.bgPaperRaised,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 36.w, height: 4.h, decoration: BoxDecoration(
              color: AppColors.ink100,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            )),
            SizedBox(height: AppSpacing.s5.h),
            Text(message, style: AppTypography.bodyLg(), textAlign: TextAlign.center),
            SizedBox(height: AppSpacing.s6.h),
            Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    onPressed: () => Get.back(result: false),
                    isOutLined: true,
                    outLineColour: AppColors.ink100,
                    height: 48,
                    buttonBorderRadius: AppRadius.lg,
                    child: CustomText(
                      title: ConstString.cancel,
                      textColor: AppColors.ink900,
                      fontWeight: FontWeight.w600,
                      textSize: 15.sp,
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.s3.w),
                Expanded(
                  child: CustomElevatedButton(
                    onPressed: () => Get.back(result: true),
                    color: AppColors.brick,
                    height: 48,
                    buttonBorderRadius: AppRadius.lg,
                    child: CustomText(
                      title: confirmLabel,
                      textColor: Colors.white,
                      fontWeight: FontWeight.w600,
                      textSize: 15.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
    return result ?? false;
  }
}
