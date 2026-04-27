import 'package:get/get.dart';
import 'package:cholo_bd/feature/active_trip/active_trip_controller.dart';
import 'package:cholo_bd/feature/trip_planning/data/repositoryImpl/trip_repository_impl.dart';

class ActiveTripBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TripRepositoryImpl>(() => TripRepositoryImpl());
    Get.lazyPut<ActiveTripController>(
        () => ActiveTripController(Get.find<TripRepositoryImpl>()));
  }
}
