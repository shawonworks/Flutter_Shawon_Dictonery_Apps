import 'package:get/get.dart';
import '../../../../data/repositories/ielts_word_bank_repository.dart';
import '../../../ielts_topic/ielts_topic.dart';

class IeltsTopicPickerController extends GetxController {
  final IeltsWordBankRepository _repo = Get.find<IeltsWordBankRepository>();

  final RxList<IeltsTopic> topics = <IeltsTopic>[].obs;
  final RxMap<String, int> wordCounts = <String, int>{}.obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final loadedTopics = await _repo.topics();
      final counts = <String, int>{};
      for (final t in loadedTopics) {
        counts[t.id] = await _repo.wordCountForTopic(t.id);
      }
      topics.value = loadedTopics;
      wordCounts.value = counts;
    } catch (_) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void retry() => _load();

}