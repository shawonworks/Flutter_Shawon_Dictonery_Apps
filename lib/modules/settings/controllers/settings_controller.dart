import 'package:get/get.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/theme/text_scale_controller.dart';
import '../../../data/repositories/favorites_repository.dart';
import '../../../data/repositories/history_repository.dart';
import '../../favorites/controllers/favorites_controller.dart';
import '../../history/controllers/history_controller.dart';

class SettingsController extends GetxController {
  final ThemeController themeController = Get.find<ThemeController>();
  final TextScaleController textScaleController = Get.find<TextScaleController>();
  final FavoritesRepository _favoritesRepository = Get.find<FavoritesRepository>();
  final HistoryRepository _historyRepository = Get.find<HistoryRepository>();

  Future<void> clearSearchHistory() async {
    await _historyRepository.clearAll();
    if (Get.isRegistered<HistoryController>()) {
      Get.find<HistoryController>().refresh_();
    }
  }

  Future<void> clearAllFavorites() async {
    await _favoritesRepository.clearAll();
    if (Get.isRegistered<FavoritesController>()) {
      Get.find<FavoritesController>().refresh_();
    }
  }
}
