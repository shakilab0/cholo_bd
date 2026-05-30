import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/config/app_colors.dart';
import 'package:cholo_bd/feature/trip_planning/data/model/trip_model.dart';
import 'package:cholo_bd/feature/trip_planning/domain/useCase/delete_trip_use_case.dart';
import 'package:cholo_bd/feature/trips/trips_controller.dart';

class TripDetailsController extends GetxController {
  final DeleteTripUseCase _deleteTripUseCase;
  TripDetailsController(this._deleteTripUseCase);

  late final TripModel trip;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is TripModel) {
      trip = args;
    } else if (args is Map && args['trip'] is TripModel) {
      trip = args['trip'] as TripModel;
    }
  }

  String get statusLabel {
    switch (trip.status) {
      case TripStatus.upcoming:
        return 'Upcoming';
      case TripStatus.active:
        return 'Active';
      case TripStatus.completed:
        return 'Completed';
    }
  }

  bool get canCancelTrip => trip.status == TripStatus.upcoming;

  void shareTrip() {
    Get.snackbar(
      'Coming Soon',
      'Trip sharing will be available in the next update.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> confirmCancelTrip() async {
    if (!canCancelTrip) return;

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
    await cancelTrip();
  }

  Future<void> cancelTrip() async {
    final result = await _deleteTripUseCase.execute(trip.id);
    result.fold(
      (failure) => Get.snackbar(
        'Error',
        failure.message,
        snackPosition: SnackPosition.BOTTOM,
      ),
      (_) {
        if (Get.isRegistered<TripsController>()) {
          Get.find<TripsController>().loadTrips();
        }
        Get.back();
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
