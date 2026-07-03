import 'package:get/get_navigation/src/routes/get_route.dart';
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
];
