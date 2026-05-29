import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:cholo_bd/app/my_app.dart';
import 'package:cholo_bd/config/api_keys.dart';
import 'package:cholo_bd/core/routes/routes.dart';
import 'package:cholo_bd/core/services/gemini_transport_filter_service.dart';
import 'package:cholo_bd/core/services/google_routes_service.dart'
    show GoogleRoutesService, RouteResult;
import 'package:cholo_bd/core/services/location_service.dart';
import 'package:cholo_bd/core/services/notification_service.dart';
import 'package:cholo_bd/feature/homepage/data/model/district_model.dart';
import 'package:cholo_bd/feature/homepage/data/model/place_model.dart';
import 'package:cholo_bd/feature/homepage/data/model/sub_district_data.dart';
import 'package:cholo_bd/feature/homepage/data/model/sub_district_model.dart';
import 'package:cholo_bd/feature/homepage/domain/useCase/get_districts_use_case.dart';
import 'package:cholo_bd/feature/homepage/domain/useCase/get_places_by_district_use_case.dart';
import 'package:cholo_bd/feature/trip_planning/data/model/transport_estimate.dart';
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

  LocationService get _location => Get.find<LocationService>();
  GeminiTransportFilterService get _gemini =>
      Get.find<GeminiTransportFilterService>();
  GoogleRoutesService get _routes => Get.find<GoogleRoutesService>();

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

  final Rx<DistrictModel?> selectedDistrict = Rx<DistrictModel?>(null);
  final RxList<PlaceModel> selectedPlaces = <PlaceModel>[].obs;
  static const int maxPlacesPerDay = 5;

  final Rx<DateTime> selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  final Rx<TimeOfDay> selectedStartTime = const TimeOfDay(hour: 8, minute: 0).obs;

  final RxBool useCurrentLocationAsStart = true.obs;
  final RxString startLocationLabel = ''.obs;
  final Rx<DistrictModel?> selectedStartDistrict = Rx<DistrictModel?>(null);
  final Rx<SubDistrictModel?> selectedStartSubDistrict =
      Rx<SubDistrictModel?>(null);
  final RxList<SubDistrictModel> startSubDistricts = <SubDistrictModel>[].obs;

  final Rx<TransportOptionModel?> selectedTransport =
      Rx<TransportOptionModel?>(null);

  final RxMap<String, TransportEstimate> transportEstimates =
      <String, TransportEstimate>{}.obs;
  final RxBool isLoadingTransportEstimates = false.obs;
  String? _estimatesCacheKey;

  final RxBool isCreating = false.obs;
  final RxString tripName = ''.obs;

  String get estimatedDuration {
    final hrs = selectedPlaces.length * 2;
    return '~$hrs hrs';
  }

  LatLng? get tripStart {
    if (useCurrentLocationAsStart.value) {
      return _location.position.value;
    }
    final sub = selectedStartSubDistrict.value;
    if (sub == null) return null;
    return LatLng(sub.latitude, sub.longitude);
  }

  LatLng? get tripDestination {
    if (selectedPlaces.isEmpty) return null;
    final place = selectedPlaces.first;
    if (place.latitude == 0 && place.longitude == 0) return null;
    return LatLng(place.latitude, place.longitude);
  }

  String get destinationPlaceName =>
      selectedPlaces.isNotEmpty ? selectedPlaces.first.name : '';

  DateTime get tripDateTime {
    final date = selectedDate.value;
    final time = selectedStartTime.value;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  String get startTimeLabel {
    final time = selectedStartTime.value;
    final dt = DateTime(2000, 1, 1, time.hour, time.minute);
    return DateFormat('h:mm a').format(dt);
  }

  bool get isStartTimeValid {
    final now = DateTime.now();
    return tripDateTime.isAfter(now);
  }

  bool get canProceedStep0 => selectedDistrict.value != null;
  bool get canProceedStep1 => selectedPlaces.isNotEmpty;

  bool get canProceedStep2 {
    if (!isStartTimeValid) return false;
    if (useCurrentLocationAsStart.value) {
      return _location.hasValidPosition && _location.permissionGranted.value;
    }
    return selectedStartDistrict.value != null &&
        selectedStartSubDistrict.value != null;
  }

  bool get canProceedStep3 {
    final t = selectedTransport.value;
    if (t == null) return false;
    final est = transportEstimates[t.id];
    if (est != null) return est.isAvailable;
    return true;
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['district'] != null) {
      selectedDistrict.value = args['district'] as DistrictModel;
      if (currentStep.value == 0) currentStep.value = 1;
    }
    selectedTransport.value = bangladeshTransports.first;
    _syncStartLabel();
    _loadDistricts();
    ever(selectedDistrict, (DistrictModel? district) {
      if (district != null) _loadPlacesForDistrict(district.id);
    });
    ever(useCurrentLocationAsStart, (_) {
      _syncStartLabel();
      _clearTransportEstimates();
    });
    ever(_location.areaLabel, (_) => _syncStartLabel());
    ever(_location.position, (_) => _syncStartLabel());
    ever(selectedStartSubDistrict, (_) {
      _syncStartLabel();
      _clearTransportEstimates();
    });
    ever(currentStep, (int step) {
      if (step == 3) loadTransportEstimates();
    });
    if (selectedDistrict.value != null) {
      _loadPlacesForDistrict(selectedDistrict.value!.id);
    }
    if (!_location.hasValidPosition) {
      _location.requestAndRefresh();
    }
    _ensureValidStartTimeForDate();
  }

  void _syncStartLabel() {
    if (useCurrentLocationAsStart.value) {
      startLocationLabel.value = _location.displayLabel;
      return;
    }
    final district = selectedStartDistrict.value;
    final sub = selectedStartSubDistrict.value;
    if (district != null && sub != null) {
      startLocationLabel.value = '${sub.name}, ${district.name}';
    } else {
      startLocationLabel.value = '';
    }
  }

  void _clearTransportEstimates() {
    _estimatesCacheKey = null;
    transportEstimates.clear();
  }

  void _loadStartSubDistricts(String districtId) {
    startSubDistricts.assignAll(subDistrictsForDistrict(districtId));
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
    _estimatesCacheKey = null;
    transportEstimates.clear();

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
    _estimatesCacheKey = null;
    transportEstimates.clear();
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
    _estimatesCacheKey = null;
    transportEstimates.clear();
  }

  bool isPlaceSelected(PlaceModel place) =>
      selectedPlaces.any((p) => p.id == place.id);

  void selectDate(DateTime date) {
    selectedDate.value = date;
    _ensureValidStartTimeForDate();
  }

  void selectDateQuick(int offsetDays) {
    final now = DateTime.now();
    selectedDate.value = DateTime(now.year, now.month, now.day + offsetDays);
    _ensureValidStartTimeForDate();
  }

  void selectThisWeekend() {
    final now = DateTime.now();
    final daysUntilSat = (6 - now.weekday) % 7;
    final offset = daysUntilSat == 0 ? 7 : daysUntilSat;
    selectedDate.value = DateTime(now.year, now.month, now.day + offset);
    _ensureValidStartTimeForDate();
  }

  void selectStartTime(TimeOfDay time) {
    selectedStartTime.value = time;
  }

  void selectStartTimePreset(int hour, int minute) {
    selectedStartTime.value = TimeOfDay(hour: hour, minute: minute);
  }

  void _ensureValidStartTimeForDate() {
    if (isStartTimeValid) return;
    final bumped = DateTime.now().add(const Duration(minutes: 30));
    selectedStartTime.value =
        TimeOfDay(hour: bumped.hour, minute: bumped.minute);
  }

  void setUseCurrentLocationAsStart(bool value) {
    useCurrentLocationAsStart.value = value;
    if (value) {
      selectedStartDistrict.value = null;
      selectedStartSubDistrict.value = null;
      startSubDistricts.clear();
      if (!_location.hasValidPosition) {
        _location.requestAndRefresh();
      }
    }
    _syncStartLabel();
  }

  void selectStartDistrict(DistrictModel? district) {
    selectedStartDistrict.value = district;
    selectedStartSubDistrict.value = null;
    if (district != null) {
      _loadStartSubDistricts(district.id);
    } else {
      startSubDistricts.clear();
    }
    _syncStartLabel();
    _clearTransportEstimates();
  }

  void selectStartSubDistrict(SubDistrictModel? subDistrict) {
    selectedStartSubDistrict.value = subDistrict;
    _syncStartLabel();
  }

  Future<void> refreshStartLocation() => _location.requestAndRefresh();

  Future<void> enableLocationForTrip() async {
    await _location.requestAndRefresh();
    if (!_location.permissionGranted.value) {
      await _location.openSettings();
    }
    _syncStartLabel();
  }

  void selectTransport(TransportOptionModel transport) {
    final est = transportEstimates[transport.id];
    if (est != null && !est.isAvailable) return;
    selectedTransport.value = transport;
  }

  TransportEstimate? estimateFor(String transportId) =>
      transportEstimates[transportId];

  String timeLabelFor(TransportOptionModel transport) {
    final est = transportEstimates[transport.id];
    if (est != null) return est.displayTime;
    return transport.estimatedTime;
  }

  Future<void> loadTransportEstimates() async {
    final start = tripStart;
    final dest = tripDestination;
    if (start == null || dest == null) return;

    final key =
        '${start.latitude.toStringAsFixed(3)},${start.longitude.toStringAsFixed(3)}->${dest.latitude.toStringAsFixed(3)},${dest.longitude.toStringAsFixed(3)}';
    if (_estimatesCacheKey == key && transportEstimates.isNotEmpty) return;

    isLoadingTransportEstimates.value = true;
    transportEstimates.clear();
    _estimatesCacheKey = key;

    final straightKm = _haversineKm(start, dest);
    final district = selectedDistrict.value;
    final destName = destinationPlaceName;

    if (!ApiKeys.hasGemini && !ApiKeys.hasGoogleMaps) {
      Get.snackbar(
        'API keys',
        'Add GEMINI_API_KEY and GOOGLE_MAPS_API_KEY via --dart-define for live estimates.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    }

    final filter = await _gemini.filterFeasibleTransports(
      origin: start,
      destination: dest,
      startLabel: startLocationLabel.value.isNotEmpty
          ? startLocationLabel.value
          : 'Current location',
      destinationName: destName,
      districtName: district?.name ?? '',
    );

    final estimates = <String, TransportEstimate>{};

    for (final transport in bangladeshTransports) {
      if (!filter.availableIds.contains(transport.id)) {
        estimates[transport.id] = TransportEstimate(
          transportId: transport.id,
          isAvailable: false,
          reasonUnavailable:
              filter.unavailableReasons[transport.id] ?? 'Not suitable',
        );
        continue;
      }

      RouteResult? route;
      if (transport.id == 'boat') {
        estimates[transport.id] = TransportEstimate(
          transportId: transport.id,
          isAvailable: true,
          durationMinutes: (straightKm / 25 * 60).ceil(),
          distanceKm: straightKm * 1.2,
        );
        continue;
      }

      route = await _routes.routeForTransport(
        transportId: transport.id,
        origin: start,
        destination: dest,
        straightLineKm: straightKm,
      );

      if (route != null) {
        estimates[transport.id] = TransportEstimate(
          transportId: transport.id,
          isAvailable: true,
          durationMinutes: route.durationMinutes,
          distanceKm: route.distanceKm,
        );
      } else {
        estimates[transport.id] = TransportEstimate(
          transportId: transport.id,
          isAvailable: true,
          durationMinutes: _fallbackDurationMinutes(transport.id, straightKm),
          distanceKm: straightKm * 1.3,
        );
      }
    }

    transportEstimates.assignAll(estimates);

    final selected = selectedTransport.value;
    if (selected != null) {
      final est = estimates[selected.id];
      if (est != null && !est.isAvailable) {
        final firstAvailable = bangladeshTransports
            .where((t) => estimates[t.id]?.isAvailable == true)
            .firstOrNull;
        selectedTransport.value = firstAvailable;
      }
    }

    isLoadingTransportEstimates.value = false;
  }

  int _fallbackDurationMinutes(String transportId, double km) {
    switch (transportId) {
      case 'rickshaw':
        return (km / 12 * 60).ceil();
      case 'cng':
        return (km / 25 * 60).ceil();
      case 'bus':
        return (km / 45 * 60).ceil();
      case 'train':
        return (km / 55 * 60).ceil();
      case 'private_car':
        return (km / 50 * 60).ceil();
      default:
        return (km / 40 * 60).ceil();
    }
  }

  double _haversineKm(LatLng a, LatLng b) {
    const earthRadiusKm = 6371.0;
    final dLat = _toRad(b.latitude - a.latitude);
    final dLon = _toRad(b.longitude - a.longitude);
    final lat1 = _toRad(a.latitude);
    final lat2 = _toRad(b.latitude);
    final h = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    return earthRadiusKm * 2 * math.atan2(math.sqrt(h), math.sqrt(1 - h));
  }

  double _toRad(double deg) => deg * math.pi / 180.0;

  void nextStep() {
    if (currentStep.value == 2 && !canProceedStep2) {
      final en = MyApp.isEnglish.value;
      if (!isStartTimeValid) {
        Get.snackbar(
          en ? 'Invalid start time' : 'ভুল শুরুর সময়',
          en
              ? 'Pick a start time that is still in the future.'
              : 'এমন একটি সময় বেছে নিন যা এখনো আসেনি।',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      if (useCurrentLocationAsStart.value) {
        Get.snackbar(
          en ? 'Location required' : 'লোকেশন প্রয়োজন',
          en
              ? 'Enable location to use your current position as the trip start.'
              : 'ট্রিপ শুরু করতে বর্তমান লোকেশন চালু করুন।',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          en ? 'Start location required' : 'শুরুর লোকেশন প্রয়োজন',
          en
              ? 'Select a district and sub-district for your trip start.'
              : 'ট্রিপ শুরুর জন্য জেলা ও উপজেলা বেছে নিন।',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return;
    }
    if (currentStep.value < totalSteps - 1) {
      currentStep.value++;
      if (currentStep.value == 3) {
        loadTransportEstimates();
      }
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
    final start = tripStart;
    final est = transportEstimates[transport.id];

    final draft = TripModel(
      id: '',
      name: tripName.value.isNotEmpty
          ? tripName.value
          : 'Trip to ${district.name}',
      districtId: district.id,
      districtName: district.name,
      places: selectedPlaces.toList(),
      transport: transport,
      tripDate: tripDateTime,
      createdAt: DateTime.now(),
      startLat: start?.latitude,
      startLng: start?.longitude,
      startLabel: startLocationLabel.value.isNotEmpty
          ? startLocationLabel.value
          : null,
      transportRouteDisplay: est?.displayTime,
      transportDistanceKm: est?.distanceKm,
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
