import 'package:get/get.dart';
import 'package:cholo_bd/feature/district_places/district_places_controller.dart';

class DistrictPlacesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DistrictPlacesController>(() => DistrictPlacesController());
  }
}
