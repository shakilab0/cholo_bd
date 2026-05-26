import 'package:get/get.dart';
import 'package:cholo_bd/dio_helper/appwrite_provider.dart';
import 'package:cholo_bd/feature/district_places/district_places_controller.dart';
import 'package:cholo_bd/feature/homepage/data/dataSource/homepage_remote_data_source.dart';
import 'package:cholo_bd/feature/homepage/data/repositoryImpl/homepage_repository_impl.dart';
import 'package:cholo_bd/feature/homepage/domain/useCase/get_places_by_district_use_case.dart';

class DistrictPlacesBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AppWriteProvider>()) {
      Get.lazyPut<AppWriteProvider>(() => AppWriteProvider(), fenix: true);
    }
    if (!Get.isRegistered<HomepageRemoteDataSource>()) {
      Get.lazyPut<HomepageRemoteDataSource>(
          () => HomepageRemoteDataSource(Get.find()));
    }
    if (!Get.isRegistered<HomepageRepositoryImpl>()) {
      Get.lazyPut<HomepageRepositoryImpl>(
          () => HomepageRepositoryImpl(Get.find()));
    }
    Get.lazyPut<GetPlacesByDistrictUseCase>(
        () => GetPlacesByDistrictUseCase(Get.find<HomepageRepositoryImpl>()));
    Get.lazyPut<DistrictPlacesController>(
        () => DistrictPlacesController(Get.find()));
  }
}
