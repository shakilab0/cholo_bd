import 'package:get/get.dart';
import 'package:cholo_bd/feature/trip_details/trip_details_controller.dart';
import 'package:cholo_bd/feature/trip_planning/data/repositoryImpl/trip_repository_impl.dart';
import 'package:cholo_bd/feature/trip_planning/domain/useCase/delete_trip_use_case.dart';

class TripDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TripRepositoryImpl>(() => TripRepositoryImpl());
    Get.lazyPut<DeleteTripUseCase>(
        () => DeleteTripUseCase(Get.find<TripRepositoryImpl>()));
    Get.lazyPut<TripDetailsController>(
        () => TripDetailsController(Get.find<DeleteTripUseCase>()));
  }
}
