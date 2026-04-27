import 'package:get/get.dart';
import 'package:cholo_bd/app/my_app.dart';
import 'package:cholo_bd/core/hiveCacheData/hive_cache_data.dart';
import 'package:cholo_bd/core/routes/routes.dart';

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;

  void continueAsGuest() async {
    isLoading.value = true;
    await saveIsGuestMode(true);
    MyApp.isGuestMode.value = true;
    isLoading.value = false;
    Get.offAllNamed(AppRoutes.tabbar);
  }

  void loginWithGoogle() {
    // TODO: implement Google OAuth via Appwrite
    Get.snackbar('Coming Soon', 'Google login will be available soon.',
        snackPosition: SnackPosition.BOTTOM);
  }

  void loginWithPhone() {
    // TODO: implement Phone OTP via Appwrite
    Get.snackbar('Coming Soon', 'Phone login will be available soon.',
        snackPosition: SnackPosition.BOTTOM);
  }
}
