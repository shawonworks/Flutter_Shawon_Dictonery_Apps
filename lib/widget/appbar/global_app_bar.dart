import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Single global app bar reused across every screen in the app.
/// - Transparent over `bg/paper` at rest.
/// - Gains `bg/paper-raised` + a hairline bottom border once the screen
///   content scrolls under it (pass [raised] from a ScrollController listener).
/// - `showBack` renders a plain ink-colored back chevron (no colored pill),
///   matching the quiet "Annotated Paper" chrome.
class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final bool raised;
  final bool centerTitle;

  const GlobalAppBar({
    super.key,
    this.title,
    this.showBack = true,
    this.onBack,
    this.actions,
    this.raised = false,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: raised ? AppColors.bgPaperRaised : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: raised ? AppColors.ink100 : Colors.transparent,
            width: 1,
          ),
        ),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: centerTitle,
        titleSpacing: showBack ? 0 : 20.w,
        leading: showBack
            ? IconButton(
                onPressed: onBack ?? () => Get.back(),
                icon: Icon(Icons.arrow_back, size: 22.sp, color: AppColors.ink900),
              )
            : null,
        title: title != null
            ? Text(title!, style: AppTypography.h1(), maxLines: 1, overflow: TextOverflow.ellipsis)
            : null,
        actions: actions != null
            ? [...actions!, SizedBox(width: 8.w)]
            : null,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}
