import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/config/constant/constantText.dart';
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
              const Icon(Icons.travel_explore,
                  color: AppColor.primary, size: 72),
              const SizedBox(height: 24),
              Text(AppStrings.appName,
                  style: AppTextStyle.heading1, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(AppStrings.taglineBn,
                  style: AppTextStyle.banglaBody, textAlign: TextAlign.center),
              const Spacer(),
              // PRIMARY: Continue as Guest
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
                          : Text(AppStrings.continueAsGuest,
                              style: AppTextStyle.button),
                    )),
              ),
              const SizedBox(height: 16),
              // SECONDARY: Google Sign-In
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: controller.loginWithGoogle,
                  icon: const Icon(Icons.g_mobiledata_rounded,
                      color: AppColor.textPrimary, size: 24),
                  label: Text(AppStrings.loginWithGoogle,
                      style: AppTextStyle.labelMedium),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColor.border),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // TERTIARY: Phone OTP
              TextButton(
                onPressed: controller.loginWithPhone,
                child: Text(AppStrings.loginWithPhone,
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
