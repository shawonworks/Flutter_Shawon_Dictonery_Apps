import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeOption { light, dark, system }

class ThemeController extends GetxController {
  static const _prefsKey = 'app_theme_option';

  final Rx<AppThemeOption> themeOption = AppThemeOption.system.obs;

  @override
  void onInit() {
    super.onInit();
    _restore();
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved != null) {
      themeOption.value = AppThemeOption.values.firstWhere(
        (e) => e.name == saved,
        orElse: () => AppThemeOption.system,
      );
      _apply();
    }
  }

  Future<void> setTheme(AppThemeOption option) async {
    themeOption.value = option;
    _apply();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, option.name);
  }

  void _apply() {
    switch (themeOption.value) {
      case AppThemeOption.light:
        Get.changeThemeMode(ThemeMode.light);
        break;
      case AppThemeOption.dark:
        Get.changeThemeMode(ThemeMode.dark);
        break;
      case AppThemeOption.system:
        Get.changeThemeMode(ThemeMode.system);
        break;
    }
  }
}
