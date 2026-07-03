import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/app_typography.dart';

/// Plain headword row used while search results are still just strings
/// (dictionaryapi.dev has no batch endpoint, so full previews aren't
/// fetched per keystroke). Visually a lighter sibling of [WordResultRow].
class HeadwordRow extends StatefulWidget {
  final String headword;
  final VoidCallback onTap;
  final bool highlighted;

  const HeadwordRow({super.key, required this.headword, required this.onTap, this.highlighted = false});

  @override
  State<HeadwordRow> createState() => _HeadwordRowState();
}

class _HeadwordRowState extends State<HeadwordRow> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: AppMotion.fast,
        constraints: BoxConstraints(minHeight: 52.h),
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.s4.w, vertical: AppSpacing.s3.h),
        decoration: BoxDecoration(
          color: _pressed
              ? AppColors.bgPaperSunken
              : widget.highlighted
              ? AppColors.marigoldDim
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            Expanded(child: Text(widget.headword, style: AppTypography.headwordMd())),
            Icon(Icons.chevron_right, size: 20.sp, color: AppColors.ink300),
          ],
        ),
      ),
    );
  }
}
