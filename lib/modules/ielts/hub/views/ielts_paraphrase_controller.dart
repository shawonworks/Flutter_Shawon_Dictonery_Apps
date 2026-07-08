import 'package:get/get.dart';
import '../../../../data/repositories/ielts_paraphrase_repository.dart';
import 'ielts_paraphrase_exercise.dart';

class IeltsParaphraseController extends GetxController {
  final IeltsParaphraseRepository _repo = Get.find<IeltsParaphraseRepository>();

  final RxList<IeltsParaphraseExercise> exercises = <IeltsParaphraseExercise>[].obs;
  final RxInt currentIndex = 0.obs;
  final RxBool isRevealed = false.obs;
  final RxBool isLoading = true.obs;

  int get total => exercises.length;
  IeltsParaphraseExercise? get current =>
      currentIndex.value < exercises.length ? exercises[currentIndex.value] : null;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    exercises.value = await _repo.all();
    isLoading.value = false;
  }

  void reveal() => isRevealed.value = true;

  void next() {
    if (currentIndex.value + 1 < exercises.length) {
      currentIndex.value++;
    } else {
      currentIndex.value = 0;
    }
    isRevealed.value = false;
  }

  void previous() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      isRevealed.value = false;
    }
  }
}