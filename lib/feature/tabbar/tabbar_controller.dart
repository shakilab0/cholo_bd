import 'package:get/get.dart';
import 'package:cholo_bd/feature/profile/profile_controller.dart';
import 'package:cholo_bd/feature/trips/trips_controller.dart';

class TabbarController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
    if (index == 1 && Get.isRegistered<TripsController>()) {
      Get.find<TripsController>().loadTrips();
    }
    if (index == 3 && Get.isRegistered<ProfileController>()) {
      Get.find<ProfileController>().refreshData();
    }
  }
}
