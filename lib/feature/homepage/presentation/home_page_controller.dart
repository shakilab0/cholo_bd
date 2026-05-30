import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/app/my_app.dart';
import 'package:cholo_bd/core/hiveCacheData/hive_cache_data.dart';
import 'package:cholo_bd/core/routes/routes.dart';
import 'package:cholo_bd/feature/homepage/data/model/district_model.dart';
import 'package:cholo_bd/feature/homepage/data/model/place_model.dart';
import 'package:cholo_bd/feature/homepage/domain/useCase/get_districts_use_case.dart';
import 'package:cholo_bd/feature/homepage/domain/useCase/get_featured_places_use_case.dart';
import 'package:cholo_bd/core/services/location_service.dart';
import 'package:cholo_bd/feature/tabbar/tabbar_controller.dart';

class HomePageController extends GetxController {
  final GetDistrictsUseCase _getDistrictsUseCase;
  final GetFeaturedPlacesUseCase _getFeaturedPlacesUseCase;

  HomePageController(this._getDistrictsUseCase, this._getFeaturedPlacesUseCase);

  LocationService get _location => Get.find<LocationService>();

  String get locationLabel => _location.displayLabel;

  bool get isLocationLoading => _location.isLoading.value;

  // State
  final RxList<DistrictModel> districts = <DistrictModel>[].obs;
  final RxList<PlaceModel> featuredPlaces = <PlaceModel>[].obs;
  final RxBool isLoadingDistricts = true.obs;
  final RxBool isLoadingFeatured = true.obs;

  List<DistrictModel> get popularDistricts {
    final sorted = [...districts]
      ..sort((a, b) => b.placeCount.compareTo(a.placeCount));
    return sorted.take(20).toList();
  }

  // Season banner (derived from current month)
  String get seasonBannerText {
    final month = DateTime.now().month;
    final bool en = MyApp.isEnglish.value;
    if (month >= 6 && month <= 9) {
      return en
          ? 'Monsoon Season — Enjoy the lush green Sundarbans'
          : 'বর্ষা মৌসুম — সবুজ সুন্দরবনের সৌন্দর্য উপভোগ করুন';
    } else if (month >= 12 || month <= 2) {
      return en
          ? "Winter Season — Best time for Cox's Bazar beach"
          : 'শীতের মৌসুম — কক্সবাজারের সেরা সময়';
    } else {
      return en
          ? 'Summer — Explore the hill tracts of Bandarban'
          : 'গ্রীষ্মকাল — বান্দরবানের পার্বত্য অঞ্চল অন্বেষণ করুন';
    }
  }

  IconData get seasonIcon {
    final month = DateTime.now().month;
    if (month >= 6 && month <= 9) return Icons.water_drop_rounded;
    if (month >= 12 || month <= 2) return Icons.ac_unit_rounded;
    return Icons.wb_sunny_rounded;
  }

  @override
  void onInit() {
    super.onInit();
    _loadData();
    _location.requestAndRefresh();
  }

  Future<void> refreshLocation() => _location.requestAndRefresh();

  Future<void> onLocationPillTap() async {
    if (!_location.permissionGranted.value) {
      await _location.requestAndRefresh();
      if (!_location.permissionGranted.value) {
        await _location.openSettings();
      }
    }
  }

  Future<void> _loadData() async {
    await Future.wait([_loadDistricts(), _loadFeaturedPlaces()]);
  }

  Future<void> _loadDistricts() async {
    isLoadingDistricts.value = true;
    final result = await _getDistrictsUseCase.execute();
    result.fold(
      (failure) => log('Districts error: ${failure.message}'),
      (data) => districts.value = data,
    );
    isLoadingDistricts.value = false;
  }

  Future<void> _loadFeaturedPlaces() async {
    isLoadingFeatured.value = true;
    final result = await _getFeaturedPlacesUseCase.execute();
    result.fold(
      (failure) => log('Featured places error: ${failure.message}'),
      (data) => featuredPlaces.value = data,
    );
    isLoadingFeatured.value = false;
  }

  void toggleLanguage() {
    MyApp.isEnglish.value = !MyApp.isEnglish.value;
    saveLanguageIsEnglish(MyApp.isEnglish.value);
  }

  void navigateToProfile() {
    if (Get.isRegistered<TabbarController>()) {
      Get.find<TabbarController>().changeTab(3);
    } else {
      Get.toNamed(AppRoutes.profile);
    }
  }

  void navigateToAllDistricts({bool autofocusSearch = false}) {
    Get.toNamed(
      AppRoutes.allDistricts,
      arguments: autofocusSearch ? {'autofocusSearch': true} : null,
    );
  }

  void navigateToDistrictPlaces(DistrictModel district) {
    Get.toNamed(AppRoutes.districtPlaces, arguments: district);
  }

  void navigateToPlaceDetails(PlaceModel place) {
    Get.toNamed(AppRoutes.placeDetails, arguments: place);
  }

  void navigateToTripPlanning({DistrictModel? district}) {
    Get.toNamed(AppRoutes.tripPlanning,
        arguments: district != null ? {'district': district} : null);
  }

  void navigateToCategoryPlaces(String categoryId) {
    Get.toNamed(AppRoutes.categoryPlaces, arguments: categoryId);
  }

  void navigateToFeaturedPlaces() {
    Get.toNamed(AppRoutes.featuredPlaces);
  }
}
