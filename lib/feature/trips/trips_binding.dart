import 'package:get/get.dart';
import 'package:cholo_bd/feature/trip_planning/data/repositoryImpl/trip_repository_impl.dart';
import 'package:cholo_bd/feature/trip_planning/domain/useCase/get_trips_use_case.dart';
import 'package:cholo_bd/feature/trips/trips_controller.dart';

class TripsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TripRepositoryImpl>(() => TripRepositoryImpl());
    Get.lazyPut<GetTripsUseCase>(
        () => GetTripsUseCase(Get.find<TripRepositoryImpl>()));
    Get.lazyPut<TripsController>(
        () => TripsController(Get.find<GetTripsUseCase>()));
  }
}
