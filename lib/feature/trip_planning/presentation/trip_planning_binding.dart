import 'package:get/get.dart';
import 'package:cholo_bd/feature/trip_planning/data/repositoryImpl/trip_repository_impl.dart';
import 'package:cholo_bd/feature/trip_planning/domain/useCase/create_trip_use_case.dart';
import 'package:cholo_bd/feature/trip_planning/presentation/trip_planning_controller.dart';

class TripPlanningBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TripRepositoryImpl>(() => TripRepositoryImpl());
    Get.lazyPut<CreateTripUseCase>(
        () => CreateTripUseCase(Get.find<TripRepositoryImpl>()));
    Get.lazyPut<TripPlanningController>(
        () => TripPlanningController(Get.find()));
  }
}
