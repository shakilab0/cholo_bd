import 'package:get/get.dart';
import 'package:cholo_bd/core/hiveCacheData/hive_cache_data.dart';
import 'package:cholo_bd/core/routes/routes.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    final bool isFirstLaunch = getIsFirstLaunch();
    if (isFirstLaunch) {
      await saveIsFirstLaunch(false);
      Get.offAllNamed(AppRoutes.onboarding);
    } else {
      Get.offAllNamed(AppRoutes.tabbar);
    }
  }
}
