import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/config/constant/constantText.dart';
import 'package:cholo_bd/feature/onboarding/onboarding_controller.dart';

class OnboardingPage extends GetView<OnboardingController> {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      _OnboardingData(
        icon: Icons.explore_rounded,
        title: AppStrings.onboarding1Title,
        titleBn: AppStrings.onboarding1TitleBn,
        subtitle: AppStrings.onboarding1Sub,
        subtitleBn: AppStrings.onboarding1SubBn,
        color: AppColor.primary,
      ),
      _OnboardingData(
        icon: Icons.map_rounded,
        title: AppStrings.onboarding2Title,
        titleBn: AppStrings.onboarding2TitleBn,
        subtitle: AppStrings.onboarding2Sub,
        subtitleBn: AppStrings.onboarding2SubBn,
        color: AppColor.accent,
      ),
      _OnboardingData(
        icon: Icons.wifi_off_rounded,
        title: AppStrings.onboarding3Title,
        titleBn: AppStrings.onboarding3TitleBn,
        subtitle: AppStrings.onboarding3Sub,
        subtitleBn: AppStrings.onboarding3SubBn,
        color: AppColor.primary,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColor.bgDark,
      body: SafeArea(
        child: Stack(
          children: [
            // Skip button
            Positioned(
              top: 16,
              right: 16,
              child: TextButton(
                onPressed: controller.skip,
                child: Text(AppStrings.skip,
                    style: AppTextStyle.labelMedium
                        .copyWith(color: AppColor.textSecondary)),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: controller.onPageChanged,
                    itemCount: pages.length,
                    itemBuilder: (_, i) => _OnboardingItem(data: pages[i]),
                  ),
                ),
                // Dots indicator
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        controller.totalPages,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: controller.currentPage.value == i ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: controller.currentPage.value == i
                                ? AppColor.primary
                                : AppColor.border,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    )),
                const SizedBox(height: 32),
                // Next / Done button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Obx(() => SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: controller.nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text(
                            controller.currentPage.value ==
                                    controller.totalPages - 1
                                ? AppStrings.done
                                : AppStrings.next,
                            style: AppTextStyle.button,
                          ),
                        ),
                      )),
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

class _OnboardingData {
  final IconData icon;
  final String title;
  final String titleBn;
  final String subtitle;
  final String subtitleBn;
  final Color color;

  const _OnboardingData({
    required this.icon,
    required this.title,
    required this.titleBn,
    required this.subtitle,
    required this.subtitleBn,
    required this.color,
  });
}

class _OnboardingItem extends StatelessWidget {
  final _OnboardingData data;
  const _OnboardingItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, size: 80, color: data.color),
          ),
          const SizedBox(height: 48),
          Text(data.title,
              style: AppTextStyle.heading2, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(data.titleBn,
              style: AppTextStyle.banglaHeading, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(data.subtitle,
              style: AppTextStyle.bodyMedium, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
