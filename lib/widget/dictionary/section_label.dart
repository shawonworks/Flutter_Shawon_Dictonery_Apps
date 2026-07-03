import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'squiggle_underline.dart';

class SectionLabel extends StatelessWidget {
  final String text;

  const SectionLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text.toUpperCase(), style: AppTypography.labelMd(color: AppColors.ink500)),
        SizedBox(height: 4.h),
        const SquiggleUnderline(width: 24, strokeWidth: 2),
      ],
    );
  }
}
