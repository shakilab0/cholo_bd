import 'dart:developer';
import 'package:get/get.dart';
import 'package:cholo_bd/app/my_app.dart';
import 'package:cholo_bd/core/hiveCacheData/hive_cache_data.dart';
import 'package:cholo_bd/core/routes/routes.dart';
import 'package:cholo_bd/dio_helper/appwrite_provider.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    final bool onboardingCompleted = getOnboardingCompleted();
    if (!onboardingCompleted) {
      Get.offAllNamed(AppRoutes.onboardingStep1);
      return;
    }

    // Check for existing Appwrite session
    try {
      final appWrite = AppWriteProvider();
      final user = await appWrite.account.get();
      await saveIsGuestMode(false);
      await saveUserId(user.$id);
      final name = user.name.trim().isNotEmpty
          ? user.name.trim()
          : user.email.split('@').first;
      await saveDisplayName(name);
      MyApp.isGuestMode.value = false;
      log('Session restored: ${user.email}');
      Get.offAllNamed(AppRoutes.tabbar);
      return;
    } catch (e) {
      log('No active session: $e');
    }

    // No Appwrite session — check if user previously chose guest mode
    final bool wasGuest = getIsGuestMode();
    if (wasGuest) {
      MyApp.isGuestMode.value = true;
      Get.offAllNamed(AppRoutes.tabbar);
    } else {
      Get.offAllNamed(AppRoutes.auth);
    }
  }
}
