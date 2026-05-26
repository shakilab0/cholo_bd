import 'package:get/get.dart';
import 'package:cholo_bd/core/di/homepage_dependencies.dart';
import 'package:cholo_bd/feature/homepage/presentation/home_page_controller.dart';

class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    registerHomepageDependencies();
    Get.lazyPut<HomePageController>(
        () => HomePageController(Get.find(), Get.find()));
  }
}
