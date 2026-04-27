import 'package:get/get.dart';
import 'package:cholo_bd/feature/tabbar/tabbar_controller.dart';
import 'package:cholo_bd/feature/homepage/presentation/home_page_binding.dart';
import 'package:cholo_bd/feature/trips/trips_binding.dart';
import 'package:cholo_bd/feature/profile/profile_binding.dart';
import 'package:cholo_bd/feature/map/map_binding.dart';

class TabbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabbarController>(() => TabbarController());
    HomePageBinding().dependencies();
    TripsBinding().dependencies();
    MapBinding().dependencies();
    ProfileBinding().dependencies();
  }
}
