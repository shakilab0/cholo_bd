import 'package:cholo_bd/core/hiveCacheData/hive_cache_data.dart';
import 'package:cholo_bd/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/core/hiveCacheData/hive_cache_data.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/config/app_text_style.dart';
import 'package:cholo_bd/config/constant/constantText.dart';

class OnboardingStep5PreferencePage extends StatefulWidget {
  const OnboardingStep5PreferencePage({super.key});

  @override
  State<OnboardingStep5PreferencePage> createState() => _OnboardingStep5PreferencePageState();
}

class _OnboardingStep5PreferencePageState extends State<OnboardingStep5PreferencePage> {

  final RxSet<String> preferredLocationTypes = <String>{}.obs;

  static const List<LocationTypeOption> locationTypeOptions = [
    LocationTypeOption(
      label: 'Hill / Pahar',
      icon: Icons.terrain_rounded,
    ),
    LocationTypeOption(
      label: 'River / Nodi',
      icon: Icons.waves_rounded,
    ),
    LocationTypeOption(
      label: 'Sea / Sagor',
      icon: Icons.beach_access_rounded,
    ),
    LocationTypeOption(
      label: 'Park',
      icon: Icons.park_rounded,
    ),
    LocationTypeOption(
      label: 'Historical Place',
      icon: Icons.account_balance_rounded,
    ),
    LocationTypeOption(
      label: 'Forest',
      icon: Icons.forest_rounded,
    ),
    LocationTypeOption(
      label: 'Waterfall',
      icon: Icons.waterfall_chart_rounded,
    ),
    LocationTypeOption(
      label: 'Lake',
      icon: Icons.pool_rounded,
    ),
    LocationTypeOption(
      label: 'Museum',
      icon: Icons.museum_rounded,
    ),
  ];


  @override
  void initState() {
    final cached = getPreferredLocationTypes();
    if (cached.isNotEmpty) preferredLocationTypes.addAll(cached);
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }


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
                onPressed: goToAuth,
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
                              child: Text('What places do you like?', style: AppTextStyle.heading3),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Expanded(
                          child: Obx(() {
                            final selected = preferredLocationTypes;
                            return SingleChildScrollView(
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children:locationTypeOptions.map((option) {
                                  final isSelected = selected.contains(option.label);
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
                  children: List.generate(5, (i) => AnimatedContainer(
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
                      onPressed: finishOnboarding,
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

  Future<void> finishOnboarding() async {
    await savePreferredLocationTypes(preferredLocationTypes.toList());
    await goToAuth();
  }

  Future<void> goToAuth() async {
    await saveOnboardingCompleted(true);
    await saveIsFirstLaunch(false);
    Get.offAllNamed(AppRoutes.auth);
  }

}


class LocationTypeOption {
  final String label;
  final IconData icon;

  const LocationTypeOption({
    required this.label,
    required this.icon,
  });
}
