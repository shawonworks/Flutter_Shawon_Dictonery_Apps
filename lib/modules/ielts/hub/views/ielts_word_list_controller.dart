import 'package:get/get.dart';
import '../../../../data/repositories/ielts_word_bank_repository.dart';
import '../../../ielts_topic/views/ielts_word_entry.dart';

class IeltsWordListController extends GetxController {
  final IeltsWordBankRepository _repo = Get.find<IeltsWordBankRepository>();

  final String title;
  final String mode; // 'topic' | 'highFrequency' | 'all'
  final String? topicId;


  IeltsWordListController({required this.title, required this.mode, this.topicId});

  final RxList<IeltsWordEntry> words = <IeltsWordEntry>[].obs;
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
      switch (mode) {
        case 'topic':
          words.value = await _repo.wordsForTopic(topicId ?? '');
          break;
        case 'highFrequency':
          words.value = await _repo.highFrequencyWords();
          break;
        case 'all':
        default:
          words.value = await _repo.allWords();
      }
    } catch (_) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void retry() => _load();
}