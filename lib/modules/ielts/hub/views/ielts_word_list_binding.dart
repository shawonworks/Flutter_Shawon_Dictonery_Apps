import 'package:get/get.dart';
import 'ielts_word_list_controller.dart';

class IeltsWordListBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments as Map<String, dynamic>? ?? const {};
    final title = args['title'] as String? ?? 'Word List';
    final mode = args['mode'] as String? ?? 'all';
    final topicId = args['topicId'] as String?;

    Get.put(
      IeltsWordListController(title: title, mode: mode, topicId: topicId),
      tag: '$mode-${topicId ?? ''}',
    );
  }
}