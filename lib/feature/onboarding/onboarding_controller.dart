import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/core/hiveCacheData/hive_cache_data.dart';
import 'package:cholo_bd/core/routes/routes.dart';

class OnboardingController extends GetxController {
  static const int totalSteps = 5;

  final TextEditingController nameController = TextEditingController();
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
  void onInit() {
    super.onInit();
    final cached = getPreferredLocationTypes();
    if (cached.isNotEmpty) preferredLocationTypes.addAll(cached);
    final n = getDisplayName();
    if (n != null && n.trim().isNotEmpty) nameController.text = n.trim();
  }

  void goToStep2() => Get.toNamed(AppRoutes.onboardingStep2);

  void goToStep3() => Get.toNamed(AppRoutes.onboardingStep3);

  void goToName() => Get.toNamed(AppRoutes.onboardingName);

  Future<void> submitNameAndGoToPreference() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar(
        'Name required',
        'Please enter your name to continue.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    await saveDisplayName(name);
    Get.toNamed(AppRoutes.onboardingPreference);
  }

  Future<void> finishOnboarding() async {
    await savePreferredLocationTypes(preferredLocationTypes.toList());
    await goToAuth();
  }

  void skip() => goToAuth();

  Future<void> goToAuth() async {
    await saveOnboardingCompleted(true);
    await saveIsFirstLaunch(false);
    if (Get.isRegistered<OnboardingController>()) {
      Get.delete<OnboardingController>();
    }
    Get.offAllNamed(AppRoutes.auth);
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
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
