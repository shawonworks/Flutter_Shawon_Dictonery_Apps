import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/app_typography.dart';
import '../button/custom_elevated_button.dart';
import '../text/custom_text.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? body;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool isError;
  final List<Widget>? extra;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.body,
    this.actionLabel,
    this.onAction,
    this.isError = false,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    final tint = isError ? AppColors.brick : AppColors.marigold;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s6.w, vertical: AppSpacing.s10.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isError ? AppColors.brickDim : AppColors.bgPaperSunken,
            ),
            child: Icon(icon, size: 32.sp, color: tint),
          ),
          SizedBox(height: AppSpacing.s5.h),
          Text(title, style: AppTypography.h2(), textAlign: TextAlign.center),
          if (body != null) ...[
            SizedBox(height: AppSpacing.s2.h),
            CustomText(
              title: body!,
              textAlign: TextAlign.center,
              textColor: AppColors.ink500,
              textSize: 15.sp,
              maxLine: 3,
            ),
          ],
          if (extra != null) ...[SizedBox(height: AppSpacing.s4.h), ...extra!],
          if (actionLabel != null && onAction != null) ...[
            CustomElevatedButton(
              onPressed: onAction,
              width: 220,
              height: 48,
              color: AppColors.marigold,
              buttonBorderRadius: AppRadius.lg,
              top: AppSpacing.s6,
              child: CustomText(
                title: actionLabel!,
                textColor: AppColors.ink900Fixed,
                fontWeight: FontWeight.w600,
                textSize: 15.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
