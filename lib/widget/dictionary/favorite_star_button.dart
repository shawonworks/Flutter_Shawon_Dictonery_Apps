import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';

class FavoriteStarButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onToggle;

  const FavoriteStarButton({super.key, required this.isFavorite, required this.onToggle});

  @override
  State<FavoriteStarButton> createState() => _FavoriteStarButtonState();
}

class _FavoriteStarButtonState extends State<FavoriteStarButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: AppMotion.instant);
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 50),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.selectionClick();
    _controller.forward(from: 0);
    widget.onToggle();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.isFavorite ? 'Remove from favorites' : 'Add to favorites',
      child: GestureDetector(
        onTap: _handleTap,
        child: SizedBox(
          width: 40.w,
          height: 40.w,
          child: Center(
            child: ScaleTransition(
              scale: _scale,
              child: Icon(
                widget.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                size: 24.sp,
                color: widget.isFavorite ? AppColors.marigold : AppColors.ink500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
