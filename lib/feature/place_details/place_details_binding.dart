import 'package:get/get.dart';
import 'package:cholo_bd/feature/place_details/place_details_controller.dart';

class PlaceDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlaceDetailsController>(() => PlaceDetailsController());
  }
}
