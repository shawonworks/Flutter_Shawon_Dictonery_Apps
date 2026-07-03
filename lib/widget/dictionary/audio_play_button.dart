import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';
import '../../constant/const_string.dart';

class AudioPlayButton extends StatefulWidget {
  final bool isPlaying;
  final VoidCallback onTap;

  const AudioPlayButton({super.key, required this.isPlaying, required this.onTap});

  @override
  State<AudioPlayButton> createState() => _AudioPlayButtonState();
}

class _AudioPlayButtonState extends State<AudioPlayButton> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.isPlaying ? ConstString.stopPronunciation : ConstString.playPronunciation,
      child: GestureDetector(
        onTap: widget.onTap,
        child: SizedBox(
          width: 44.w,
          height: 44.w,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final pulse = widget.isPlaying ? _pulseController.value : 0.0;
              return Stack(
                alignment: Alignment.center,
                children: [
                  if (widget.isPlaying)
                    Container(
                      width: 44.w + (pulse * 10.w),
                      height: 44.w + (pulse * 10.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.marigold.withAlpha((80 * (1 - pulse)).round()),
                      ),
                    ),
                  child!,
                ],
              );
            },
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isPlaying ? AppColors.marigold : AppColors.bgPaperSunken,
              ),
              child: Icon(
                widget.isPlaying ? Icons.volume_up_rounded : Icons.volume_up_outlined,
                size: 20.sp,
                color: widget.isPlaying ? Colors.white : AppColors.ink500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
