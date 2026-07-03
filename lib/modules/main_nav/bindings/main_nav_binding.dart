import 'package:get/get.dart';
import '../../favorites/controllers/favorites_controller.dart';
import '../../history/controllers/history_controller.dart';
import '../../home_search/controllers/home_search_controller.dart';
import '../../settings/controllers/settings_controller.dart';
import '../controllers/navbar_controller.dart';

class MainNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavbarController(), fenix: true);
    Get.lazyPut(() => HomeSearchController(), fenix: true);
    Get.lazyPut(() => FavoritesController(), fenix: true);
    Get.lazyPut(() => HistoryController(), fenix: true);
    Get.lazyPut(() => SettingsController(), fenix: true);
  }
}
