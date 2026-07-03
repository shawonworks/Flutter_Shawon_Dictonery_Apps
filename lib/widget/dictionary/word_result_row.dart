import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/word_entry.dart';
import 'pos_chip.dart';

/// Shared list row for a word: headword + POS chip + one-line preview.
/// Reused by Search results, Favorites, and History (History swaps the
/// trailing chevron for a timestamp via [trailing]).
class WordResultRow extends StatefulWidget {
  final WordEntry entry;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool highlighted;

  const WordResultRow({
    super.key,
    required this.entry,
    required this.onTap,
    this.trailing,
    this.highlighted = false,
  });

  @override
  State<WordResultRow> createState() => _WordResultRowState();
}

class _WordResultRowState extends State<WordResultRow> {
  bool _pressed = false;

  void _setPressed(bool value) => setState(() => _pressed = value);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: AppMotion.fast,
        curve: AppMotion.fastCurve,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          constraints: BoxConstraints(minHeight: 56.h),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.entry.headword,
                            style: AppTypography.headwordMd(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: AppSpacing.s2.w),
                        PosChip(partOfSpeech: widget.entry.primaryPartOfSpeech),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      widget.entry.previewDefinition,
                      style: AppTypography.bodyMd(color: AppColors.ink500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.s2.w),
              widget.trailing ?? Icon(Icons.chevron_right, size: 20.sp, color: AppColors.ink300),
            ],
          ),
        ),
      ),
    );
  }
}
