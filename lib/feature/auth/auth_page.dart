import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/feature/auth/auth_controller.dart';

class AuthPage extends GetView<AuthController> {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              Image.asset(
                'assets/icons/app_icon.png',
                width: 90,
                height: 90,
              ),
              const SizedBox(height: 24),
              Text('Smart Travel BD',
                  style: AppTextStyle.heading1, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('Explore Bangladesh the smart way',
                  style: AppTextStyle.bodyMedium, textAlign: TextAlign.center),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.continueAsGuest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(
                              color: AppColor.inkDark)
                          : Text('Continue as Guest',
                              style: AppTextStyle.button),
                    )),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.snackbar('Coming Soon',
                        'Google login will be available soon.',
                        snackPosition: SnackPosition.BOTTOM);
                  },
                  icon: const Icon(Icons.g_mobiledata_rounded,
                      color: AppColor.textPrimary, size: 24),
                  label:
                      Text('Login with Google', style: AppTextStyle.labelMedium),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColor.border),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: controller.loginWithPhone,
                child: Text('Login with Phone',
                    style: AppTextStyle.labelMedium
                        .copyWith(color: AppColor.textSecondary)),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
