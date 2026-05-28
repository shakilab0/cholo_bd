import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/config/constant/constantText.dart';
import 'package:cholo_bd/feature/onboarding/onboarding_controller.dart';

class OnboardingStep5PreferencePage extends GetView<OnboardingController> {
  const OnboardingStep5PreferencePage({super.key});

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
                const SizedBox(height:30),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color:
                                    AppColor.primary.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.tune_rounded,
                                  color: AppColor.primary, size: 26),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('What places do you like?',
                                      style: AppTextStyle.heading3),
                                  const SizedBox(height: 2),
                                  Text('পছন্দের জায়গা নির্বাচন করুন (একাধিক)',
                                      style: AppTextStyle.bodySmall.copyWith(
                                          color: AppColor.textSecondary)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Expanded(
                          child: Obx(() {
                            final selected =
                                controller.preferredLocationTypes;
                            return SingleChildScrollView(
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: OnboardingController
                                    .locationTypeOptions
                                    .map((option) {
                                  final isSelected =
                                      selected.contains(option.label);
                                  final iconColor = isSelected
                                      ? AppColor.inkDark
                                      : AppColor.primary;
                                  return FilterChip(
                                    selected: isSelected,
                                    showCheckmark: false,
                                    avatar: Icon(
                                      option.icon,
                                      size: 18,
                                      color: iconColor,
                                    ),
                                    label: Text(
                                      option.label,
                                      style: AppTextStyle.labelSmall.copyWith(
                                        color: isSelected
                                            ? AppColor.inkDark
                                            : AppColor.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onSelected: (_) {
                                      if (isSelected) {
                                        selected.remove(option.label);
                                      } else {
                                        selected.add(option.label);
                                      }
                                    },
                                    selectedColor: AppColor.primary,
                                    backgroundColor: AppColor.bgCard,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 2,
                                    ),
                                    shape: StadiumBorder(
                                      side: BorderSide(
                                        color: isSelected
                                            ? AppColor.primary
                                            : AppColor.border,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'These preferences are saved locally for future personalization.',
                          style: AppTextStyle.bodySmall
                              .copyWith(color: AppColor.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
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
                      width: i == 4 ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == 4 ? AppColor.primary : AppColor.border,
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
                      onPressed: controller.finishOnboarding,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(AppStrings.done, style: AppTextStyle.button),
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
