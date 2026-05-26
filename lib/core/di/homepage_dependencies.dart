import 'package:get/get.dart';
import 'package:cholo_bd/dio_helper/appwrite_provider.dart';
import 'package:cholo_bd/feature/homepage/data/dataSource/homepage_remote_data_source.dart';
import 'package:cholo_bd/feature/homepage/data/repositoryImpl/homepage_repository_impl.dart';
import 'package:cholo_bd/feature/homepage/domain/repository/homepage_repository.dart';
import 'package:cholo_bd/feature/homepage/domain/useCase/get_districts_use_case.dart';
import 'package:cholo_bd/feature/homepage/domain/useCase/get_featured_places_use_case.dart';
import 'package:cholo_bd/feature/homepage/domain/useCase/get_map_places_use_case.dart';
import 'package:cholo_bd/feature/homepage/domain/useCase/get_places_by_district_use_case.dart';

/// Registers Appwrite + homepage repository stack if not already present.
void registerHomepageDependencies() {
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
  if (!Get.isRegistered<HomepageRepository>()) {
    Get.lazyPut<HomepageRepository>(
        () => Get.find<HomepageRepositoryImpl>());
  }
  if (!Get.isRegistered<GetDistrictsUseCase>()) {
    Get.lazyPut<GetDistrictsUseCase>(
        () => GetDistrictsUseCase(Get.find<HomepageRepository>()));
  }
  if (!Get.isRegistered<GetPlacesByDistrictUseCase>()) {
    Get.lazyPut<GetPlacesByDistrictUseCase>(
        () => GetPlacesByDistrictUseCase(Get.find<HomepageRepository>()));
  }
  if (!Get.isRegistered<GetFeaturedPlacesUseCase>()) {
    Get.lazyPut<GetFeaturedPlacesUseCase>(
        () => GetFeaturedPlacesUseCase(Get.find<HomepageRepository>()));
  }
  if (!Get.isRegistered<GetMapPlacesUseCase>()) {
    Get.lazyPut<GetMapPlacesUseCase>(
        () => GetMapPlacesUseCase(Get.find<HomepageRepository>()));
  }
}
