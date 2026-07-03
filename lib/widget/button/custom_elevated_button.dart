import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant/const_color.dart';
class CustomElevatedButton extends StatelessWidget {
  final Widget child;
  final void Function()? onPressed;
  final Color? color;
  final double height;
  final double fontSize;
  final double? width;
  final double top;
  final double right;
  final double left;
  final double bottom;
  final FontWeight fontWeight;
  final double horizontal;
  final bool isOutLined;
  final double buttonBorderRadius;
  final double vertical;
  final Color outLineColour;
  final double? borderWidth;
  final double? elevation;
  final Color? borderColor;
  final List<Color>? gradient;
  final Widget? icon;
  final double iconGap;

  const CustomElevatedButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.color = ConstColor.primaryColor,
    this.height = 56,
    this.fontSize = 12,
    this.width,
    this.top = 12,
    this.right = 0,
    this.left = 0,
    this.bottom = 0,
    this.fontWeight = FontWeight.w400,
    this.horizontal = 20,
    this.isOutLined = false,
    this.buttonBorderRadius = 12,
    this.vertical = 0,
    this.outLineColour = ConstColor.primaryColor,
    this.borderWidth,
    this.elevation,
    this.borderColor,
    this.gradient,
    this.icon,
    this.iconGap = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasGradient = gradient != null && !isOutLined;

    // --- Main Wrapper ---
    return Padding(
      padding: EdgeInsets.only(top: top.h, right: right.w, left: left.w, bottom: bottom.h),
      child: Container(
        height: height.h,
        // Double.infinity does not need screen util, so handled via condition
        width: width != null ? width!.w : double.infinity,
        decoration: hasGradient
            ? BoxDecoration(
          gradient: LinearGradient(
            colors: gradient!,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(buttonBorderRadius.r),
          boxShadow: [
            if (elevation != null && elevation! > 0)
              BoxShadow(
                color: Colors.black.withAlpha(51), // Rule5: withOpacity(0.2) is now withAlpha(51)
                offset: Offset(0, 2.h),
                blurRadius: 4.r,
              ),
          ],
        )
            : null,

        // --- Elevated Button ---
        child: ElevatedButton(
          onPressed: onPressed ?? () => print("Elevated Button Pressed"),
          style: (isOutLined)
              ? _outlinedButtonStyle(
            fontSize.sp,
            fontWeight,
            width != null ? width!.w : double.infinity,
            height.h,
            buttonBorderRadius.r,
            vertical.h,
            horizontal.w,
            outLineColour,
            borderWidth?.w,
            elevation,
            borderColor,
          )
              : _filledButtonStyle(
            hasGradient ? Colors.transparent : color,
            fontSize.sp,
            fontWeight,
            width != null ? width!.w : double.infinity,
            height.h,
            buttonBorderRadius.r,
            vertical.h,
            horizontal.w,
            hasGradient ? 0 : elevation,
            borderColor,
            borderWidth?.w,
          ),
          child: icon != null
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 24.h, width: 24.w, child: icon),
              SizedBox(width: iconGap.w),
              Flexible(child: child),
            ],
          )
              : child,
        ),
      ),
    );
  }
}

// --- Outlined Button Style Logic ---
ButtonStyle _outlinedButtonStyle(
    double fontSize,
    FontWeight fontWeight,
    double width,
    double height,
    double buttonBorderRadius,
    double vertical,
    double horizontal,
    Color outLineColour,
    double? borderWidth,
    double? elevation,
    Color? borderColor,
    ) {
  return ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: outLineColour,
    textStyle: GoogleFonts.poppins(
        fontSize: fontSize, fontWeight: fontWeight, textStyle: const TextStyle()),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(buttonBorderRadius),
      side: BorderSide(
        width: borderWidth ?? 1.w,
        color: borderColor ?? outLineColour,
      ),
    ),
    minimumSize: Size(width, height),
    elevation: elevation,
    padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
  );
}

// --- Filled Button Style Logic ---
ButtonStyle _filledButtonStyle(
    Color? color,
    double fontSize,
    FontWeight fontWeight,
    double width,
    double height,
    double buttonBorderRadius,
    double vertical,
    double horizontal,
    double? elevation,
    Color? borderColor,
    double? borderWidth,
    ) {
  return ElevatedButton.styleFrom(
    backgroundColor: color,
    shadowColor: Colors.transparent,
    foregroundColor: ConstColor.titleColor,
    textStyle: GoogleFonts.poppins(
        fontSize: fontSize, fontWeight: fontWeight, textStyle: const TextStyle()),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(buttonBorderRadius),
      side: borderColor != null
          ? BorderSide(color: borderColor, width: borderWidth ?? 1.w)
          : BorderSide.none,
    ),
    minimumSize: Size(width, height),
    elevation: elevation,
    padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
  );
}