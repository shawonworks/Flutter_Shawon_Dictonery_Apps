import 'package:get/get.dart';
import 'ielts_progress_controller.dart';

class IeltsProgressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IeltsProgressController(), fenix: true);
  }
}