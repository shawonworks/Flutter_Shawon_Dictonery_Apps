import 'package:get/get.dart';
import 'ielts_mini_test_controller.dart';

class IeltsMiniTestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IeltsMiniTestController(), fenix: true);
  }
}