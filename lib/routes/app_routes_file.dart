import 'package:get/get_navigation/src/routes/get_route.dart';
import '../modules/ielts/hub/views/ielts_daily_challenge_binding.dart';
import '../modules/ielts/hub/views/ielts_daily_challenge_screen.dart';
import '../modules/ielts/hub/views/ielts_hub_screen.dart';
import '../modules/ielts/hub/views/ielts_progress_binding.dart';
import '../modules/ielts/hub/views/ielts_progress_screen.dart';
import '../modules/ielts/hub/views/ielts_topic_picker_binding.dart';
import '../modules/ielts/hub/views/ielts_topic_picker_screen.dart';
import '../modules/ielts/hub/views/ielts_word_list_binding.dart';
import '../modules/ielts/hub/views/ielts_word_list_screen.dart';
import 'app_routes.dart';
import '../modules/splash/views/splash_screen.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_screen.dart';
import '../modules/main_nav/bindings/main_nav_binding.dart';
import '../modules/main_nav/views/main_nav_screen.dart';
import '../modules/word_detail/bindings/word_detail_binding.dart';
import '../modules/word_detail/views/word_detail_screen.dart';

List<GetPage> appRouteFile = <GetPage>[
  ////////////First Launch////////////
  GetPage(name: AppRoutes.splashScreen, page: () => const SplashScreen()),
  GetPage(name: AppRoutes.onboardingScreen, page: () => const OnboardingScreen(), binding: OnboardingBinding()),

  ////////////Main Tabs////////////
  GetPage(name: AppRoutes.mainNavScreen, page: () => const MainNavScreen(), binding: MainNavBinding()),

  ////////////Word Detail////////////
  GetPage(
    name: AppRoutes.wordDetailScreen,
    page: () => const WordDetailScreen(),
    binding: WordDetailBinding(),
  ),


  //////////IELTS //////////
  GetPage(name: AppRoutes.ieltsHubScreen, page: () => const IeltsHubScreen()),
  GetPage(
    name: AppRoutes.ieltsTopicPickerScreen,
    page: () => const IeltsTopicPickerScreen(),
    binding: IeltsTopicPickerBinding(),
  ),
  GetPage(
    name: AppRoutes.ieltsWordListScreen,
    page: () => const IeltsWordListScreen(),
    binding: IeltsWordListBinding(),
  ),
  GetPage(
    name: AppRoutes.ieltsDailyChallengeScreen,
    page: () => const IeltsDailyChallengeScreen(),
    binding: IeltsDailyChallengeBinding(),
  ),
  GetPage(
    name: AppRoutes.ieltsProgressScreen,
    page: () => const IeltsProgressScreen(),
    binding: IeltsProgressBinding(),
  ),
];
