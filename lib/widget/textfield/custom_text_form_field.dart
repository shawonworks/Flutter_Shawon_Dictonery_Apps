import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constant/const_color.dart';
import '../text/custom_text.dart';

class CustomTextFormField extends StatelessWidget {
  final bool numeric;
  final String fromTitle;
  final Widget? titleIcon;
  final Widget? hintText;
  final int maxLine;
  final int? minLines;
  final TextEditingController? textController;
  final String? Function(String?)? validator;
  final Color? backgroundColor;
  final Widget? prefixIcon;
  final double? borderRadius;
  final AutovalidateMode? autoValidateMode;
  final BoxConstraints? prefixIconConstraints;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final String? suffixText;
  final Color? suffixTextColor;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;
  final BoxConstraints? suffixIconConstraints;
  final bool obscureText;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool? enabled;

  const CustomTextFormField({
    super.key,
    this.fromTitle = "",
    this.titleIcon,
    this.numeric = false,
    this.hintText,
    this.maxLine = 1,
    this.minLines,
    this.backgroundColor,
    this.textController,
    this.validator,
    this.autoValidateMode,
    this.prefixIcon,
    this.borderRadius,
    this.prefixIconConstraints,
    this.textInputAction,
    this.focusNode,
    this.keyboardType,
    this.suffixText,
    this.suffixTextColor,
    this.onChanged,
    this.suffixIcon,
    this.suffixIconConstraints,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          if (fromTitle.isNotEmpty || titleIcon != null)
            Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (titleIcon != null) ...[
                    titleIcon!,
                    SizedBox(width: 8.w),
                  ],
                  if (fromTitle.isNotEmpty)
                    CustomText(
                      top: 0,
                      bottom: 0,
                      title: fromTitle,
                      textSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                ],
              ),
            ),

          TextFormField(
            controller: textController,
            focusNode: focusNode,
            style: TextStyle(
              color: ConstColor.titleColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              decorationThickness: 0,
            ),
            validator: validator ??
                    (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "This field is required";
                  }
                  return null;
                },
            minLines: minLines,
            maxLines: maxLine,
            textInputAction: textInputAction ?? TextInputAction.done,
            keyboardType: keyboardType ?? (numeric ? TextInputType.number : null),
            cursorColor: ConstColor.primaryColor,
            onChanged: onChanged,
            obscureText: obscureText,
            readOnly: readOnly,
            onTap: onTap,
            autovalidateMode: autoValidateMode,
            enabled: enabled,

            // --- Input Decoration ---
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              prefixIconConstraints: prefixIconConstraints,
              suffixIcon: suffixIcon,
              suffixIconConstraints: suffixIconConstraints,
              suffixText: suffixText,
              suffixStyle: TextStyle(
                color: suffixTextColor ?? ConstColor.bodyColor ,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
              filled: backgroundColor != null,
              fillColor: backgroundColor,
              hoverColor: ConstColor.primaryColor,
              label: hintText,
              hintStyle: TextStyle(
                color: ConstColor.outLineColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 14.h,
                horizontal: 16.w,
              ),

              // --- Borders ---
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: ConstColor.iconColor),
                borderRadius: BorderRadius.circular((borderRadius ?? 12).r),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: ConstColor.iconColor),
                borderRadius: BorderRadius.circular((borderRadius ?? 12).r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: ConstColor.titleColor),
                borderRadius: BorderRadius.circular((borderRadius ?? 12).r),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: ConstColor.red),
                borderRadius: BorderRadius.circular((borderRadius ?? 12).r),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: ConstColor.red),
                borderRadius: BorderRadius.circular((borderRadius ?? 12).r),
              ),
              errorStyle: TextStyle(
                color: ConstColor.red,
                fontSize: 11.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}