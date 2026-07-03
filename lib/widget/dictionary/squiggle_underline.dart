import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';

/// The app's one recurring graphic device: a short tilde/breve stroke
/// borrowed from IPA stress marks. Purely decorative — excluded from
/// the semantics tree so screen readers don't announce it.
class SquiggleUnderline extends StatelessWidget {
  final double width;
  final double strokeWidth;
  final Color? color;

  const SquiggleUnderline({super.key, this.width = 24, this.strokeWidth = 2.5, this.color});

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        width: width.w,
        height: 6.h,
        child: CustomPaint(
          painter: _SquigglePainter(color: color ?? AppColors.marigold, strokeWidth: strokeWidth),
        ),
      ),
    );
  }
}

class _SquigglePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _SquigglePainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(0, size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.25, 0, size.width * 0.5, size.height * 0.55)
      ..quadraticBezierTo(size.width * 0.75, size.height * 1.1, size.width, size.height * 0.35);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SquigglePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}
