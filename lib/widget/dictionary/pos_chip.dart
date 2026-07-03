import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/meaning.dart';

/// Pill chip for part-of-speech labels. Capped at three tag colors
/// (neutral / sage / marigold) to avoid a rainbow UI.
class PosChip extends StatelessWidget {
  final PartOfSpeech partOfSpeech;

  const PosChip({super.key, required this.partOfSpeech});

  @override
  Widget build(BuildContext context) {
    final style = _styleFor(partOfSpeech);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s3.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: style.outline ? Border.all(color: AppColors.ink100, width: 1) : null,
      ),
      child: Text(_label(partOfSpeech), style: AppTypography.labelMd(color: style.foreground)),
    );
  }

  String _label(PartOfSpeech pos) {
    switch (pos) {
      case PartOfSpeech.noun:
        return 'NOUN';
      case PartOfSpeech.verb:
        return 'VERB';
      case PartOfSpeech.adjective:
        return 'ADJECTIVE';
      case PartOfSpeech.adverb:
        return 'ADVERB';
      case PartOfSpeech.other:
        return 'WORD';
    }
  }

  _ChipStyle _styleFor(PartOfSpeech pos) {
    switch (pos) {
      case PartOfSpeech.verb:
        return _ChipStyle(background: AppColors.sageDim, foreground: AppColors.sage, outline: false);
      case PartOfSpeech.adjective:
        return _ChipStyle(background: AppColors.marigoldDim, foreground: _darkerMarigold(), outline: false);
      case PartOfSpeech.adverb:
        return _ChipStyle(background: Colors.transparent, foreground: AppColors.ink500, outline: true);
      case PartOfSpeech.noun:
      case PartOfSpeech.other:
        return _ChipStyle(background: AppColors.bgPaperSunken, foreground: AppColors.ink500, outline: false);
    }
  }

  Color _darkerMarigold() {
    final hsl = HSLColor.fromColor(AppColors.marigold);
    return hsl.withLightness((hsl.lightness - 0.18).clamp(0.0, 1.0)).toColor();
  }
}

class _ChipStyle {
  final Color background;
  final Color foreground;
  final bool outline;
  const _ChipStyle({required this.background, required this.foreground, required this.outline});
}
