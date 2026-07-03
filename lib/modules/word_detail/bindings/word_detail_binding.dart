import 'package:get/get.dart';
import '../controllers/word_detail_controller.dart';

/// Tagged by headword: Word Detail can push a new Word Detail screen for
/// a synonym (stack grows), so each instance needs its own controller —
/// a plain untagged Get.put would overwrite the previous screen's state.
class WordDetailBinding extends Bindings {
  @override
  void dependencies() {
    final headword = Get.arguments as String? ?? '';
    Get.put(WordDetailController(headword: headword), tag: headword);
  }
}
