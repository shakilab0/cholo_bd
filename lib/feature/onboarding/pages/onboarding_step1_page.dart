import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/config/constant/constantText.dart';
import 'package:cholo_bd/feature/onboarding/onboarding_controller.dart';

class OnboardingStep1Page extends GetView<OnboardingController> {
  const OnboardingStep1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgDark,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 8,
              right: 16,
              child: TextButton(
                onPressed: controller.skip,
                child: Text(
                  AppStrings.skip,
                  style: AppTextStyle.labelMedium
                      .copyWith(color: AppColor.textSecondary),
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            color: AppColor.primary.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.explore_rounded,
                              size: 80, color: AppColor.primary),
                        ),
                        const SizedBox(height: 48),
                        Text(AppStrings.onboarding1Title,
                            style: AppTextStyle.heading2,
                            textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        Text(AppStrings.onboarding1TitleBn,
                            style: AppTextStyle.banglaHeading,
                            textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        Text(AppStrings.onboarding1Sub,
                            style: AppTextStyle.bodyMedium,
                            textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    OnboardingController.totalSteps,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: i == 0 ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == 0 ? AppColor.primary : AppColor.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: controller.goToStep2,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(AppStrings.next, style: AppTextStyle.button),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
