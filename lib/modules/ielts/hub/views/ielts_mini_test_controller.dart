import 'package:get/get.dart';
import '../../../../data/repositories/ielts_test_result_repository.dart';
import '../../../../data/repositories/ielts_word_bank_repository.dart';
import '../../../../data/services/ielts_mini_test_generator.dart';
import 'ielts_mini_test_question.dart';

class IeltsMiniTestController extends GetxController {
  final IeltsWordBankRepository _wordBank = Get.find<IeltsWordBankRepository>();
  final IeltsTestResultRepository _resultsRepo = Get.find<IeltsTestResultRepository>();

  final RxList<IeltsMiniTestQuestion> questions = <IeltsMiniTestQuestion>[].obs;
  final RxInt currentIndex = 0.obs;
  final RxInt score = 0.obs;
  final Rxn<int> selectedOption = Rxn<int>();
  final RxBool isLoading = true.obs;
  final RxBool isFinished = false.obs;

  int get total => questions.length;
  IeltsMiniTestQuestion? get currentQuestion =>
      currentIndex.value < questions.length ? questions[currentIndex.value] : null;

  @override
  void onInit() {
    super.onInit();
    start();
  }

  Future<void> start() async {
    isLoading.value = true;
    isFinished.value = false;
    currentIndex.value = 0;
    score.value = 0;
    selectedOption.value = null;

    final all = await _wordBank.allWords();
    questions.value = IeltsMiniTestGenerator.generate(all, count: 10);
    isLoading.value = false;
  }

  void selectOption(int index) {
    if (selectedOption.value != null) return;
    selectedOption.value = index;
    if (index == currentQuestion?.correctIndex) score.value++;
  }

  Future<void> next() async {
    if (currentIndex.value + 1 >= questions.length) {
      isFinished.value = true;
      await _resultsRepo.recordAttempt(score.value, total);
    } else {
      currentIndex.value++;
      selectedOption.value = null;
    }
  }
}