import 'package:get/get.dart';
import 'package:cholo_bd/core/di/homepage_dependencies.dart';
import 'package:cholo_bd/feature/featured_places/featured_places_controller.dart';

class FeaturedPlacesBinding extends Bindings {
  @override
  void dependencies() {
    registerHomepageDependencies();
    Get.lazyPut<FeaturedPlacesController>(
        () => FeaturedPlacesController(Get.find()));
  }
}
