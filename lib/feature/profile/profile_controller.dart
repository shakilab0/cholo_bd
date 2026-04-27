import 'package:get/get.dart';
import 'package:cholo_bd/app/my_app.dart';
import 'package:cholo_bd/core/hiveCacheData/hive_cache_data.dart';
import 'package:cholo_bd/feature/trip_planning/data/model/trip_model.dart';
import 'package:cholo_bd/feature/trip_planning/domain/useCase/get_trips_use_case.dart';

class ProfileController extends GetxController {
  final GetTripsUseCase _getTripsUseCase;
  ProfileController(this._getTripsUseCase);

  final RxInt totalTrips = 0.obs;
  final RxInt placesVisited = 0.obs;
  final RxInt districtsExplored = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadStats();
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

  bool get isGuest => MyApp.isGuestMode.value;

  String get displayName =>
      isGuest ? 'Guest Explorer' : 'Smart Traveler';

  String get displaySubtitle =>
      isGuest ? 'Sign in to sync your trips' : 'Bangladesh explorer';
}
