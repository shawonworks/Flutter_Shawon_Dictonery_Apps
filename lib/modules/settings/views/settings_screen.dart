import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/theme/text_scale_controller.dart';
import '../../../constant/const_string.dart';
import '../../../widget/appbar/global_app_bar.dart';
import '../../../widget/common/confirm_bottom_sheet.dart';
import '../../../widget/common/segmented_control.dart';
import '../controllers/settings_controller.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPaper,
      appBar: const GlobalAppBar(title: ConstString.settingsTitle, showBack: false),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.s2.h),
        children: [
          const _SectionHeader(ConstString.appearance),
          Obx(
            () => _SettingsRow(
              label: ConstString.theme,
              value: _themeLabel(controller.themeController.themeOption.value),
              onTap: () => _openThemeSheet(context),
            ),
          ),
          const _SectionHeader(ConstString.reading),
          Obx(
            () => _SettingsRow(
              label: ConstString.textSize,
              value: _sizeLabel(controller.textScaleController.option.value),
              onTap: () => _openTextSizeSheet(context),
            ),
          ),
          _SectionHeader(ConstString.data),
          _SettingsRow(
            label: ConstString.clearSearchHistory,
            destructive: true,
            onTap: () async {
              final confirmed = await ConfirmBottomSheet.show(
                message: ConstString.clearHistoryConfirm,
                confirmLabel: ConstString.remove,
              );
              if (confirmed) controller.clearSearchHistory();
            },
          ),
          _SettingsRow(
            label: ConstString.clearAllFavorites,
            destructive: true,
            onTap: () async {
              final confirmed = await ConfirmBottomSheet.show(
                message: ConstString.removeAllFavorites.replaceAll('%s', 'your'),
                confirmLabel: ConstString.removeAll,
              );
              if (confirmed) controller.clearAllFavorites();
            },
          ),
          _SectionHeader(ConstString.about),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) => _SettingsRow(
              label: ConstString.appVersion,
              value: snapshot.hasData ? snapshot.data!.version : '—',
              onTap: null,
            ),
          ),
          _SettingsRow(label: ConstString.rateThisApp, onTap: () {}),
          _SettingsRow(
            label: ConstString.licenses,
            onTap: () => showLicensePage(context: context, applicationName: ConstString.appName),
          ),
          SizedBox(height: AppSpacing.s8.h),
        ],
      ),
    );
  }

  String _themeLabel(AppThemeOption option) {
    switch (option) {
      case AppThemeOption.light:
        return ConstString.light;
      case AppThemeOption.dark:
        return ConstString.dark;
      case AppThemeOption.system:
        return ConstString.system;
    }
  }

  String _sizeLabel(TextSizeOption option) {
    switch (option) {
      case TextSizeOption.small:
        return ConstString.small;
      case TextSizeOption.defaultSize:
        return ConstString.defaultSize;
      case TextSizeOption.large:
        return ConstString.large;
      case TextSizeOption.xLarge:
        return ConstString.xLarge;
    }
  }

  void _openThemeSheet(BuildContext context) {
    Get.bottomSheet(
      _PickerSheet(
        child: Obx(
          () => AppSegmentedControl(
            labels: const [ConstString.light, ConstString.dark, ConstString.system],
            selectedIndex: AppThemeOption.values.indexOf(controller.themeController.themeOption.value),
            onChanged: (i) => controller.themeController.setTheme(AppThemeOption.values[i]),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  void _openTextSizeSheet(BuildContext context) {
    Get.bottomSheet(
      _PickerSheet(
        child: Column(
          children: [
            Obx(
              () => AppSegmentedControl(
                labels: const [ConstString.small, ConstString.defaultSize, ConstString.large, ConstString.xLarge],
                selectedIndex: TextSizeOption.values.indexOf(controller.textScaleController.option.value),
                onChanged: (i) => controller.textScaleController.setOption(TextSizeOption.values[i]),
              ),
            ),
            SizedBox(height: AppSpacing.s5.h),
            Obx(() {
              final scale = controller.textScaleController.option.value.scale;
              return Text(
                'The quick fox reads clearly.',
                style: AppTypography.bodyLg().copyWith(fontSize: 17.sp * scale),
              );
            }),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}

class _PickerSheet extends StatelessWidget {
  final Widget child;
  const _PickerSheet({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(AppSpacing.s5.w, AppSpacing.s3.h, AppSpacing.s5.w, AppSpacing.s8.h),
      decoration: BoxDecoration(
        color: AppColors.bgPaperRaised,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36.w,
            height: 4.h,
            decoration: BoxDecoration(color: AppColors.ink100, borderRadius: BorderRadius.circular(AppRadius.pill)),
          ),
          SizedBox(height: AppSpacing.s5.h),
          child,
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.s5.w, AppSpacing.s5.h, AppSpacing.s5.w, AppSpacing.s2.h),
      child: Text(label.toUpperCase(), style: AppTypography.labelMd(color: AppColors.ink500)),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final String label;
  final String? value;
  final VoidCallback? onTap;
  final bool destructive;

  const _SettingsRow({required this.label, this.value, required this.onTap, this.destructive = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.s5.w, vertical: AppSpacing.s4.h),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.ink100, width: 1))),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyLg(color: destructive ? AppColors.brick : AppColors.ink900),
              ),
            ),
            if (value != null) ...[
              Text(value!, style: AppTypography.bodyMd(color: AppColors.ink500)),
              SizedBox(width: AppSpacing.s2.w),
            ],
            if (onTap != null) Icon(Icons.chevron_right, size: 18.sp, color: AppColors.ink300),
          ],
        ),
      ),
    );
  }
}
