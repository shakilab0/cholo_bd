import 'package:get/get.dart';
import 'package:cholo_bd/feature/map/map_controller.dart';

class MapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlacesMapController>(() => PlacesMapController());
  }
}
