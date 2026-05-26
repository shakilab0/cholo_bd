import 'package:get/get.dart';
import 'package:cholo_bd/core/di/homepage_dependencies.dart';
import 'package:cholo_bd/dio_helper/appwrite_provider.dart';
import 'package:cholo_bd/feature/trip_planning/data/repositoryImpl/trip_repository_impl.dart';
import 'package:cholo_bd/feature/trip_planning/domain/useCase/get_trips_use_case.dart';
import 'package:cholo_bd/feature/profile/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    registerHomepageDependencies();
    if (!Get.isRegistered<AppWriteProvider>()) {
      Get.lazyPut<AppWriteProvider>(() => AppWriteProvider(), fenix: true);
    }
    Get.lazyPut<TripRepositoryImpl>(() => TripRepositoryImpl());
    Get.lazyPut<GetTripsUseCase>(
        () => GetTripsUseCase(Get.find<TripRepositoryImpl>()));
    Get.lazyPut<ProfileController>(() => ProfileController(
          Get.find<GetTripsUseCase>(),
          Get.find<AppWriteProvider>(),
        ));
  }
}
