import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cholo_bd/feature/homepage/data/model/place_model.dart';
import 'package:cholo_bd/feature/trip_planning/data/model/trip_model.dart';
import 'package:cholo_bd/feature/trip_planning/data/repositoryImpl/trip_repository_impl.dart';

class ActiveTripController extends GetxController {
  final TripRepositoryImpl _repository;
  ActiveTripController(this._repository);

  late TripModel trip;
  final RxSet<String> visitedPlaceIds = <String>{}.obs;

  int get totalPlaces => trip.places.length;
  int get visitedCount => visitedPlaceIds.length;
  double get progress =>
      totalPlaces == 0 ? 0 : visitedCount / totalPlaces;

  bool isVisited(PlaceModel place) => visitedPlaceIds.contains(place.id);

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

  void markVisited(PlaceModel place) {
    if (visitedPlaceIds.contains(place.id)) {
      visitedPlaceIds.remove(place.id);
    } else {
      visitedPlaceIds.add(place.id);
    }
  }

  Future<void> endTrip() async {
    final updated = TripModel(
      id: trip.id,
      name: trip.name,
      districtId: trip.districtId,
      districtName: trip.districtName,
      places: trip.places,
      transport: trip.transport,
      tripDate: trip.tripDate,
      createdAt: trip.createdAt,
      status: TripStatus.completed,
      notes: trip.notes,
    );
    await _repository.updateTrip(updated);
    Get.back();
    Get.snackbar(
      '🎉 Trip Complete!',
      'You visited $visitedCount of $totalPlaces places in ${trip.districtName}.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF00C896),
      colorText: const Color(0xFF0D1117),
      duration: const Duration(seconds: 4),
    );
  }
}
