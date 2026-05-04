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

class HomePageController extends GetxController {
  final GetDistrictsUseCase _getDistrictsUseCase;
  final GetFeaturedPlacesUseCase _getFeaturedPlacesUseCase;

  HomePageController(this._getDistrictsUseCase, this._getFeaturedPlacesUseCase);

  // State
  final RxList<DistrictModel> districts = <DistrictModel>[].obs;
  final RxList<PlaceModel> featuredPlaces = <PlaceModel>[].obs;
  final RxBool isLoadingDistricts = true.obs;
  final RxBool isLoadingFeatured = true.obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();
  final RxList<String> recentSearches = <String>[].obs;
  final RxList<DistrictModel> filteredDistricts = <DistrictModel>[].obs;

  List<DistrictModel> get popularDistricts {
    if (searchQuery.value.trim().isNotEmpty) return filteredDistricts;
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
    recentSearches.value = getRecentSearches();
    _loadData();
    ever(searchQuery, _filterDistricts);
  }

  Future<void> _loadData() async {
    await Future.wait([_loadDistricts(), _loadFeaturedPlaces()]);
  }

  Future<void> _loadDistricts() async {
    isLoadingDistricts.value = true;
    final result = await _getDistrictsUseCase.execute();
    result.fold(
      (failure) => log('Districts error: ${failure.message}'),
      (data) {
        districts.value = data;
        filteredDistricts.value = data;
      },
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

  void _filterDistricts(String query) {
    if (query.trim().isEmpty) {
      filteredDistricts.value = districts;
      return;
    }
    final lower = query.toLowerCase();
    filteredDistricts.value = districts.where((d) {
      return d.name.toLowerCase().contains(lower) ||
          d.nameBn.contains(query) ||
          d.description.toLowerCase().contains(lower);
    }).toList();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void onSearchSubmit(String query) {
    if (query.trim().isEmpty) return;
    addRecentSearch(query);
    recentSearches.value = getRecentSearches();
    searchQuery.value = query;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  void toggleLanguage() {
    MyApp.isEnglish.value = !MyApp.isEnglish.value;
    saveLanguageIsEnglish(MyApp.isEnglish.value);
  }

  void navigateToAllDistricts() {
    Get.toNamed(AppRoutes.allDistricts);
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

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
