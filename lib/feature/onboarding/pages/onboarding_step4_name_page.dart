import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/config/constant/constantText.dart';
import 'package:cholo_bd/feature/onboarding/onboarding_controller.dart';

class OnboardingStep4NamePage extends GetView<OnboardingController> {
  const OnboardingStep4NamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.bgDark,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
            ),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 40,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 16),

                          Container(
                            width: 150,
                            height: 150,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColor.accent.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.badge_rounded,
                              size: 70,
                              color: AppColor.accent,
                            ),
                          ),

                          const SizedBox(height: 28),

                          Text(
                            'What should we call you?',
                            style: AppTextStyle.heading2,
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'আপনার নাম লিখুন',
                            style: AppTextStyle.banglaHeading,
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 18),

                          TextField(
                            controller: controller.nameController,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.done,
                            style: AppTextStyle.bodyMedium,
                            decoration: InputDecoration(
                              hintText: 'Your name',
                              hintStyle: AppTextStyle.bodyMedium.copyWith(
                                color: AppColor.textSecondary,
                              ),
                              filled: true,
                              fillColor: AppColor.bgCard,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide:
                                const BorderSide(color: AppColor.border),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide:
                                const BorderSide(color: AppColor.border),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: AppColor.primary,
                                  width: 1.2,
                                ),
                              ),
                              prefixIcon: const Icon(
                                Icons.person_rounded,
                                color: AppColor.primary,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'We’ll use this name for your guest profile. You can change it later.',
                            style: AppTextStyle.bodySmall.copyWith(
                              color: AppColor.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 80),
                        ],
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        OnboardingController.totalSteps,
                            (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: i == 3 ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color:
                            i == 3 ? AppColor.primary : AppColor.border,
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
                          onPressed: controller.submitNameAndGoToPreference,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            AppStrings.next,
                            style: AppTextStyle.button,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
