import 'package:get/get.dart';
import 'ielts_topic_picker_controller.dart';

class IeltsTopicPickerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IeltsTopicPickerController(), fenix: true);
  }
}