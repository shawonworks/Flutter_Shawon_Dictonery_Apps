import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  static const _onboardedKey = 'has_onboarded';

  final PageController pageController = PageController();
  final RxInt pageIndex = 0.obs;
  final int totalSlides = 3;

  void onPageChanged(int index) => pageIndex.value = index;

  void next() {
    if (pageIndex.value < totalSlides - 1) {
      pageController.nextPage(duration: const Duration(milliseconds: 240), curve: Curves.easeInOutCubic);
    } else {
      getStarted();
    }
  }

  Future<void> getStarted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardedKey, true);
    Get.offAllNamed(AppRoutes.mainNavScreen);
  }

  void skip() => getStarted();

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
