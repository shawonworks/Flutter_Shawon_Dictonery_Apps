import 'package:get/get.dart';
import 'ielts_paraphrase_controller.dart';

class IeltsParaphraseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IeltsParaphraseController(), fenix: true);
  }
}