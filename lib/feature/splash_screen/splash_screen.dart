import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/config/constant/constantText.dart';
import 'package:cholo_bd/feature/splash_screen/splash_screen_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashScreenController());
    return Scaffold(
      backgroundColor: AppColor.bgDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo with map-pin drop animation
            TweenAnimationBuilder<double>(
              tween: Tween(begin: -60.0, end: 0.0),
              duration: const Duration(milliseconds: 700),
              curve: Curves.bounceOut,
              builder: (_, val, child) =>
                  Transform.translate(offset: Offset(0, val), child: child),
              child: Image.asset(
                'assets/icons/app_icon.png',
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 24),
            Text(AppStrings.appName, style: AppTextStyle.heading2),
            const SizedBox(height: 8),
            Text(
              AppStrings.taglineBn,
              style: AppTextStyle.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
