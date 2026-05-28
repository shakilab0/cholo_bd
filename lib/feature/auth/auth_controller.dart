import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/app/my_app.dart';
import 'package:cholo_bd/core/hiveCacheData/hive_cache_data.dart';
import 'package:cholo_bd/core/routes/routes.dart';
import 'package:cholo_bd/dio_helper/appwrite_provider.dart';

class AuthController extends GetxController {
  final AppWriteProvider _appWrite;
  AuthController(this._appWrite);

  final RxBool isLoading = false.obs;

  void continueAsGuest() async {
    isLoading.value = true;
    await saveIsGuestMode(true);
    MyApp.isGuestMode.value = true;
    isLoading.value = false;
    Get.offAllNamed(AppRoutes.tabbar);
  }

  Future<void> loginWithGoogle() async {
    isLoading.value = true;
    try {
      await _appWrite.account.createOAuth2Session(
        provider: OAuthProvider.google,
      );
      final user = await _appWrite.account.get();
      final name = user.name.trim().isNotEmpty
          ? user.name.trim()
          : user.email.split('@').first;

      await saveIsGuestMode(false);
      await saveUserId(user.$id);
      await saveDisplayName(name);
      MyApp.isGuestMode.value = false;

      Get.offAllNamed(AppRoutes.tabbar);
    } on AppwriteException catch (e) {
      log('Google login error: ${e.message}');
      Get.snackbar(
        'Login Failed',
        e.message ?? 'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      log('Google login error: $e');
      Get.snackbar('Login Failed', 'Please try again.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void loginWithPhone() {
    Get.snackbar('Coming Soon', 'Phone login will be available soon.',
        snackPosition: SnackPosition.BOTTOM);
  }
}
