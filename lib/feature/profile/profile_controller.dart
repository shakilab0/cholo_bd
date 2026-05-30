import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/app/my_app.dart';
import 'package:cholo_bd/core/hiveCacheData/hive_cache_data.dart';
import 'package:cholo_bd/core/routes/routes.dart';
import 'package:cholo_bd/core/services/notification_service.dart';
import 'package:cholo_bd/dio_helper/appwrite_provider.dart';
import 'package:cholo_bd/feature/trip_planning/data/model/trip_model.dart';
import 'package:cholo_bd/feature/trip_planning/domain/useCase/get_trips_use_case.dart';

class ProfileController extends GetxController {
  final GetTripsUseCase _getTripsUseCase;
  final AppWriteProvider _appWrite;

  ProfileController(this._getTripsUseCase, this._appWrite);

  final RxInt totalTrips = 0.obs;
  final RxInt placesVisited = 0.obs;
  final RxInt districtsExplored = 0.obs;
  final RxString displayName = 'Guest Explorer'.obs;
  final RxBool isLoadingProfile = false.obs;

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  Future<void> refreshData() async {
    await Future.wait([_loadProfile(), _loadStats()]);
  }

  Future<void> _loadProfile() async {
    isLoadingProfile.value = true;
    if (MyApp.isGuestMode.value) {
      final cached = getDisplayName();
      displayName.value = cached ?? 'Guest Explorer';
      isLoadingProfile.value = false;
      return;
    }

    final cached = getDisplayName();
    if (cached != null) {
      displayName.value = cached;
    }

    try {
      final user = await _appWrite.account.get();
      final name = user.name.trim();
      final email = user.email.trim();
      if (name.isNotEmpty) {
        displayName.value = name;
        await saveDisplayName(name);
      } else if (email.isNotEmpty) {
        displayName.value = email.split('@').first;
        await saveDisplayName(displayName.value);
      } else if (cached == null) {
        displayName.value = 'Traveler';
      }
    } catch (e) {
      log('Profile account load: $e');
      if (cached == null) displayName.value = 'Traveler';
    }
    isLoadingProfile.value = false;
  }

  Future<void> _loadStats() async {
    final result = await _getTripsUseCase.execute();
    result.fold(
      (_) {},
      (trips) {
        totalTrips.value = trips.length;
        final completed =
            trips.where((t) => t.status == TripStatus.completed).toList();
        placesVisited.value =
            completed.fold(0, (sum, t) => sum + t.places.length);
        districtsExplored.value =
            trips.map((t) => t.districtId).toSet().length;
      },
    );
  }

  void toggleLanguage() {
    MyApp.isEnglish.value = !MyApp.isEnglish.value;
    saveLanguageIsEnglish(MyApp.isEnglish.value);
  }

  Future<void> testNotification() async {
    try {
      await NotificationService.instance.showTestNotification();
      Get.snackbar(
        'Test sent',
        'Check your notification bar — you should see a test alert.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1C2128),
        colorText: const Color(0xFFE6EDF3),
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      log('Test notification error: $e');
      Get.snackbar(
        'Notification failed',
        'Could not show test notification. Check app notification permission.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1C2128),
        colorText: const Color(0xFFE6EDF3),
        duration: const Duration(seconds: 4),
      );
    }
  }

  Future<void> logout() async {
    try {
      await _appWrite.account.deleteSession(sessionId: 'current');
    } catch (e) {
      log('Logout Appwrite error: $e');
    }
    await clearUserSession();
    await saveTripsToCache([]);
    MyApp.isGuestMode.value = true;
    Get.offAllNamed(AppRoutes.auth);
  }

  bool get isGuest => MyApp.isGuestMode.value;

  String get displaySubtitle =>
      isGuest ? 'Sign in to sync your trips' : 'Bangladesh explorer';
}
