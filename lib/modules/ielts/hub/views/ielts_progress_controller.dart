import 'package:get/get.dart';
import '../../../../data/repositories/ielts_progress_repository.dart';
import '../../../ielts_progress_summary/ielts_progress_summary.dart';

class IeltsProgressController extends GetxController {
  final IeltsProgressRepository _repo = Get.find<IeltsProgressRepository>();

  final Rx<IeltsProgressSummary> summary = IeltsProgressSummary.empty.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    refresh_();
  }

  Future<void> refresh_() async {
    isLoading.value = true;
    summary.value = await _repo.summary();
    isLoading.value = false;
  }
}