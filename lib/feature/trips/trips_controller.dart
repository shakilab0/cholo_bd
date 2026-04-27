import 'package:get/get.dart';
import 'package:cholo_bd/core/routes/routes.dart';
import 'package:cholo_bd/feature/homepage/data/model/district_model.dart';
import 'package:cholo_bd/feature/trip_planning/data/model/trip_model.dart';
import 'package:cholo_bd/feature/trip_planning/domain/useCase/get_trips_use_case.dart';

class TripsController extends GetxController {
  final GetTripsUseCase _getTripsUseCase;
  TripsController(this._getTripsUseCase);

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
}
