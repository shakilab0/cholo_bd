import 'package:get/get.dart';
import 'package:cholo_bd/feature/trip_details/trip_details_controller.dart';

class TripDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TripDetailsController>(() => TripDetailsController());
  }
}
