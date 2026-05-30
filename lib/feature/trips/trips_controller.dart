import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/core/routes/routes.dart';
import 'package:cholo_bd/feature/homepage/data/model/district_model.dart';
import 'package:cholo_bd/feature/trip_planning/data/model/trip_model.dart';
import 'package:cholo_bd/feature/trip_planning/domain/useCase/delete_trip_use_case.dart';
import 'package:cholo_bd/feature/trip_planning/domain/useCase/get_trips_use_case.dart';

class TripsController extends GetxController {
  final GetTripsUseCase _getTripsUseCase;
  final DeleteTripUseCase _deleteTripUseCase;
  TripsController(this._getTripsUseCase, this._deleteTripUseCase);

  final RxList<TripModel> trips = <TripModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedFilter = 'upcoming'.obs;

  List<TripModel> get filteredTrips {
    switch (selectedFilter.value) {
      case 'upcoming':
        return trips.where((t) => t.status == TripStatus.upcoming).toList();
      case 'completed':
        return trips.where((t) => t.status == TripStatus.completed).toList();
      default:
        return trips.toList();
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadTrips();
  }

  Future<void> loadTrips() async {
    isLoading.value = true;
    final result = await _getTripsUseCase.execute();
    isLoading.value = false;
    result.fold(
      (_) {},
      (list) => trips.assignAll(list),
    );
  }

  void setFilter(String filter) => selectedFilter.value = filter;

  void startNewTrip() => Get.toNamed(AppRoutes.tripPlanning);

  void startTripForDistrict(DistrictModel district) {
    Get.toNamed(AppRoutes.tripPlanning, arguments: {'district': district});
  }

  bool canCancelTrip(TripModel trip) => trip.status == TripStatus.upcoming;

  Future<void> confirmCancelTrip(TripModel trip) async {
    if (!canCancelTrip(trip)) return;

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AppColor.bgCard,
        title: const Text('Cancel Trip'),
        content: Text(
          'Cancel "${trip.name}"? Scheduled reminders will be removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Keep'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              'Cancel Trip',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await cancelTrip(trip);
  }

  Future<void> cancelTrip(TripModel trip) async {
    final result = await _deleteTripUseCase.execute(trip.id);
    result.fold(
      (failure) => Get.snackbar(
        'Error',
        failure.message,
        snackPosition: SnackPosition.BOTTOM,
      ),
      (_) {
        trips.removeWhere((t) => t.id == trip.id);
        Get.snackbar(
          'Trip Cancelled',
          '${trip.name} has been cancelled.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.bgCard,
          colorText: AppColor.textPrimary,
        );
      },
    );
  }
}
