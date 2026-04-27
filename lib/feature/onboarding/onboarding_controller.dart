import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/core/routes/routes.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;
  final int totalPages = 3;

  void onPageChanged(int index) => currentPage.value = index;

  void nextPage() {
    if (currentPage.value < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      goToAuth();
    }
  }

  void skip() => goToAuth();

  void goToAuth() => Get.offAllNamed(AppRoutes.auth);

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
