import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/core/routes/routes.dart';
import 'package:cholo_bd/core/services/notification_service.dart';
import 'package:cholo_bd/feature/homepage/data/model/district_model.dart';
import 'package:cholo_bd/feature/homepage/data/model/place_model.dart';
import 'package:cholo_bd/feature/homepage/domain/useCase/get_districts_use_case.dart';
import 'package:cholo_bd/feature/homepage/domain/useCase/get_places_by_district_use_case.dart';
import 'package:cholo_bd/feature/trip_planning/data/model/transport_option_model.dart';
import 'package:cholo_bd/feature/trip_planning/data/model/trip_model.dart';
import 'package:cholo_bd/feature/trip_planning/domain/useCase/create_trip_use_case.dart';

class TripPlanningController extends GetxController {
  final CreateTripUseCase _createTripUseCase;
  final GetDistrictsUseCase _getDistrictsUseCase;
  final GetPlacesByDistrictUseCase _getPlacesByDistrictUseCase;

  TripPlanningController(
    this._createTripUseCase,
    this._getDistrictsUseCase,
    this._getPlacesByDistrictUseCase,
  );

  // Steps: 0=District, 1=Places, 2=DateTime, 3=Transport, 4=Confirm
  final RxInt currentStep = 0.obs;
  static const int totalSteps = 5;

  final RxList<DistrictModel> districts = <DistrictModel>[].obs;
  final RxBool isLoadingDistricts = true.obs;
  final RxString districtsError = ''.obs;

  final RxList<PlaceModel> districtPlaces = <PlaceModel>[].obs;
  final RxBool isLoadingPlaces = false.obs;
  final RxString placesError = ''.obs;
  final RxBool usedSeedPlacesFallback = false.obs;

  // Step 1 — District
  final Rx<DistrictModel?> selectedDistrict = Rx<DistrictModel?>(null);

  // Step 2 — Places
  final RxList<PlaceModel> selectedPlaces = <PlaceModel>[].obs;
  static const int maxPlacesPerDay = 5;

  // Step 3 — Date / Time
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  // Step 4 — Transport
  final Rx<TransportOptionModel?> selectedTransport =
      Rx<TransportOptionModel?>(null);

  // Step 5 — Confirm / loading
  final RxBool isCreating = false.obs;
  final RxString tripName = ''.obs;

  String get estimatedDuration {
    final hrs = selectedPlaces.length * 2;
    return '~$hrs hrs';
  }

  bool get canProceedStep0 => selectedDistrict.value != null;
  bool get canProceedStep1 => selectedPlaces.isNotEmpty;
  bool get canProceedStep2 => true;
  bool get canProceedStep3 => selectedTransport.value != null;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['district'] != null) {
      selectedDistrict.value = args['district'] as DistrictModel;
      if (currentStep.value == 0) currentStep.value = 1;
    }
    selectedTransport.value = bangladeshTransports.first;
    _loadDistricts();
    ever(selectedDistrict, (DistrictModel? district) {
      if (district != null) _loadPlacesForDistrict(district.id);
    });
    if (selectedDistrict.value != null) {
      _loadPlacesForDistrict(selectedDistrict.value!.id);
    }
  }

  Future<void> _loadDistricts() async {
    isLoadingDistricts.value = true;
    districtsError.value = '';
    final result = await _getDistrictsUseCase.execute();
    result.fold(
      (failure) => districtsError.value = failure.message,
      (data) => districts.assignAll(data),
    );
    isLoadingDistricts.value = false;
  }

  Future<void> _loadPlacesForDistrict(String districtId) async {
    isLoadingPlaces.value = true;
    placesError.value = '';
    usedSeedPlacesFallback.value = false;
    districtPlaces.clear();

    final result = await _getPlacesByDistrictUseCase.execute(districtId);
    result.fold(
      (_) {
        placesError.value = 'Could not load places. Check your connection.';
        _applySeedPlaces(districtId);
      },
      (remote) {
        if (remote.isEmpty) {
          usedSeedPlacesFallback.value = true;
          _applySeedPlaces(districtId);
        } else {
          districtPlaces.assignAll(remote);
        }
      },
    );
    isLoadingPlaces.value = false;
  }

  void _applySeedPlaces(String districtId) {
    final seeded =
        seedPlaces.where((p) => p.districtId == districtId).toList();
    if (seeded.isNotEmpty) {
      usedSeedPlacesFallback.value = true;
      districtPlaces.assignAll(seeded);
      placesError.value = '';
    }
  }

  void selectDistrict(DistrictModel district) {
    selectedDistrict.value = district;
    selectedPlaces.clear();
  }

  void togglePlace(PlaceModel place) {
    if (selectedPlaces.any((p) => p.id == place.id)) {
      selectedPlaces.removeWhere((p) => p.id == place.id);
    } else if (selectedPlaces.length < maxPlacesPerDay) {
      selectedPlaces.add(place);
    } else {
      Get.snackbar(
        'Maximum reached',
        'You can select up to $maxPlacesPerDay places per day.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  bool isPlaceSelected(PlaceModel place) =>
      selectedPlaces.any((p) => p.id == place.id);

  void selectDate(DateTime date) => selectedDate.value = date;

  void selectDateQuick(int offsetDays) {
    final now = DateTime.now();
    selectedDate.value = DateTime(now.year, now.month, now.day + offsetDays);
  }

  void selectThisWeekend() {
    final now = DateTime.now();
    final daysUntilSat = (6 - now.weekday) % 7;
    final offset = daysUntilSat == 0 ? 7 : daysUntilSat;
    selectedDate.value =
        DateTime(now.year, now.month, now.day + offset);
  }

  void selectTransport(TransportOptionModel transport) =>
      selectedTransport.value = transport;

  void nextStep() {
    if (currentStep.value < totalSteps - 1) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }

  bool get canGoNext {
    switch (currentStep.value) {
      case 0:
        return canProceedStep0;
      case 1:
        return canProceedStep1;
      case 2:
        return canProceedStep2;
      case 3:
        return canProceedStep3;
      default:
        return true;
    }
  }

  Future<void> confirmTrip() async {
    isCreating.value = true;
    final district = selectedDistrict.value!;
    final transport = selectedTransport.value!;

    final draft = TripModel(
      id: '',
      name: tripName.value.isNotEmpty
          ? tripName.value
          : 'Trip to ${district.name}',
      districtId: district.id,
      districtName: district.name,
      places: selectedPlaces.toList(),
      transport: transport,
      tripDate: selectedDate.value,
      createdAt: DateTime.now(),
    );

    final result = await _createTripUseCase.execute(draft);
    isCreating.value = false;

    result.fold(
      (failure) {
        log('Trip creation failed: ${failure.message}');
        Get.snackbar('Error', failure.message,
            snackPosition: SnackPosition.BOTTOM);
      },
      (trip) {
        log('Trip created: ${trip.name}');
        NotificationService.instance.scheduleForTrip(trip);
        Get.offAllNamed(AppRoutes.tabbar);
        Get.snackbar('Trip Created!', '${trip.name} has been saved.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF00C896),
            colorText: const Color(0xFF0D1117));
      },
    );
  }
}
