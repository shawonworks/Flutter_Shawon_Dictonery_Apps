import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/bindings/initial_binding.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/text_scale_controller.dart';
import 'constant/const_string.dart';
import 'routes/app_routes.dart';
import 'routes/app_routes_file.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = true;
  runApp(const LexiconApp());
}

class LexiconApp extends StatelessWidget {
  const LexiconApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(

          title: ConstString.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          initialBinding: InitialBinding(),
          initialRoute: AppRoutes.splashScreen,
          getPages: appRouteFile,
          builder: (context, widget) {
            // Applies the Settings > Text Size multiplier app-wide via
            // MediaQuery, so it composes with system accessibility scaling
            // rather than overriding per-widget fonts.
            final textScaleController = Get.find<TextScaleController>();
            return Obx(() {
              final mq = MediaQuery.of(context);
              return MediaQuery(
                data: mq.copyWith(
                  textScaler: TextScaler.linear(textScaleController.option.value.scale),
                ),
                child: widget!,
              );
            });
          },
        );
      },
    );
  }
}
