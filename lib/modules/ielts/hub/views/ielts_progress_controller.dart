import 'package:get/get.dart';
import '../../../../data/models/ielts_test_accuracy_summary.dart';
import '../../../../data/repositories/ielts_progress_repository.dart';
import '../../../../data/repositories/ielts_test_result_repository.dart';
import '../../../ielts_progress_summary/ielts_progress_summary.dart';

class IeltsProgressController extends GetxController {
  final IeltsProgressRepository _repo = Get.find<IeltsProgressRepository>();
  final IeltsTestResultRepository _testResultsRepo = Get.find<IeltsTestResultRepository>();

  final Rx<IeltsProgressSummary> summary = IeltsProgressSummary.empty.obs;
  final Rx<IeltsTestAccuracySummary> accuracy = IeltsTestAccuracySummary.empty.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    refresh_();
  }

  Future<void> refresh_() async {
    isLoading.value = true;
    summary.value = await _repo.summary();
    accuracy.value = await _testResultsRepo.summary();
    isLoading.value = false;
  }
}