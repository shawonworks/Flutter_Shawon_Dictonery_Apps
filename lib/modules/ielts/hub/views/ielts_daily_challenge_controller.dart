import 'package:get/get.dart';
import '../../../../data/repositories/ielts_progress_repository.dart';
import '../../../../widget/common/app_snackbar.dart';
import '../../../ielts_topic/views/ielts_word_entry.dart';

class IeltsDailyChallengeController extends GetxController {
  final IeltsProgressRepository _repo = Get.find<IeltsProgressRepository>();

  final RxList<IeltsWordEntry> words = <IeltsWordEntry>[].obs;
  final RxSet<String> ticked = <String>{}.obs;
  final RxBool isLoading = true.obs;

  int get total => words.length;
  bool get isDone => total > 0 && ticked.length >= total;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    isLoading.value = true;
    final loadedWords = await _repo.todayChallengeWords();
    final loadedTicked = await _repo.tickedHeadwordsToday();
    words.value = loadedWords;
    ticked.value = loadedTicked;
    isLoading.value = false;
  }

  Future<void> toggle(String headword) async {
    final wasDone = isDone;
    if (ticked.contains(headword)) {
      ticked.remove(headword);
    } else {
      ticked.add(headword);
    }
    await _repo.toggleWord(headword);
    if (!wasDone && isDone) {
      AppSnackbar.show("🔥 Today's 10 words done — streak extended!");
    }
  }
}