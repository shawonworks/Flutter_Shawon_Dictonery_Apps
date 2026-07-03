import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TextSizeOption { small, defaultSize, large, xLarge }

extension TextSizeOptionScale on TextSizeOption {
  double get scale {
    switch (this) {
      case TextSizeOption.small:
        return 0.9;
      case TextSizeOption.defaultSize:
        return 1.0;
      case TextSizeOption.large:
        return 1.15;
      case TextSizeOption.xLarge:
        return 1.3;
    }
  }
}

class TextScaleController extends GetxController {
  static const _prefsKey = 'app_text_size_option';

  final Rx<TextSizeOption> option = TextSizeOption.defaultSize.obs;

  @override
  void onInit() {
    super.onInit();
    _restore();
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt(_prefsKey);
    if (saved != null && saved >= 0 && saved < TextSizeOption.values.length) {
      option.value = TextSizeOption.values[saved];
    }
  }

  Future<void> setOption(TextSizeOption value) async {
    option.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKey, value.index);
  }
}
