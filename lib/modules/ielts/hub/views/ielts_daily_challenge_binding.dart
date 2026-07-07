import 'package:get/get.dart';
import 'ielts_daily_challenge_controller.dart';

class IeltsDailyChallengeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IeltsDailyChallengeController(), fenix: true);
  }
}