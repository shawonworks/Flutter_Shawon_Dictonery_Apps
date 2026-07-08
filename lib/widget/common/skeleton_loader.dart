import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';

class SkeletonBlock extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonBlock(
      {super.key,
      required this.width,
      required this.height,
      this.borderRadius});

  @override
  State<SkeletonBlock> createState() => _SkeletonBlockState();
}

class _SkeletonBlockState extends State<SkeletonBlock>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: AppMotion.base * 2)
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: AppColors.bgPaperSunken
                .withAlpha((160 + 60 * _controller.value).round()),
            borderRadius:
                widget.borderRadius ?? BorderRadius.circular(AppRadius.sm),
          ),
        );
      },
    );
  }
}

class WordResultRowSkeleton extends StatelessWidget {
  const WordResultRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.s4.w, vertical: AppSpacing.s3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBlock(width: 140.w, height: 20.h),
          SizedBox(height: 8.h),
          SkeletonBlock(width: 220.w, height: 14.h),
        ],
      ),
    );
  }
}
