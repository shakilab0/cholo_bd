import 'package:get/get.dart';
import 'package:cholo_bd/core/di/homepage_dependencies.dart';
import 'package:cholo_bd/feature/map/map_controller.dart';

class MapBinding extends Bindings {
  @override
  void dependencies() {
    registerHomepageDependencies();
    Get.lazyPut<PlacesMapController>(
        () => PlacesMapController(Get.find()));
  }
}
