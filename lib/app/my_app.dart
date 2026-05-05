import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/core/routes/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // App-level reactive flags
  static RxBool isEnglish = true.obs;
  static RxBool isGuestMode = true.obs;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Smart Travel BD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColor.bgDark,
        primaryColor: AppColor.primary,
        colorScheme: const ColorScheme.light(
          primary: AppColor.primary,
          secondary: AppColor.accent,
          surface: AppColor.bgCard,
          error: AppColor.alertRed,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColor.bgDark,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          elevation: 8,
          selectedItemColor: AppColor.primary,
          unselectedItemColor: AppColor.textSecondary,
        ),
      ),
      getPages: appRoutes,
      initialRoute: AppRoutes.splash,
    );
  }
}
