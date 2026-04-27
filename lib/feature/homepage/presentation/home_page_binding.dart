import 'package:get/get.dart';
import 'package:cholo_bd/dio_helper/appwrite_provider.dart';
import 'package:cholo_bd/feature/homepage/data/dataSource/homepage_remote_data_source.dart';
import 'package:cholo_bd/feature/homepage/data/repositoryImpl/homepage_repository_impl.dart';
import 'package:cholo_bd/feature/homepage/domain/useCase/get_districts_use_case.dart';
import 'package:cholo_bd/feature/homepage/domain/useCase/get_featured_places_use_case.dart';
import 'package:cholo_bd/feature/homepage/presentation/home_page_controller.dart';

class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppWriteProvider>(() => AppWriteProvider(), fenix: true);
    Get.lazyPut<HomepageRemoteDataSource>(
        () => HomepageRemoteDataSource(Get.find()));
    Get.lazyPut<HomepageRepositoryImpl>(
        () => HomepageRepositoryImpl(Get.find()));
    Get.lazyPut<GetDistrictsUseCase>(
        () => GetDistrictsUseCase(Get.find<HomepageRepositoryImpl>()));
    Get.lazyPut<GetFeaturedPlacesUseCase>(
        () => GetFeaturedPlacesUseCase(Get.find<HomepageRepositoryImpl>()));
    Get.lazyPut<HomePageController>(
        () => HomePageController(Get.find(), Get.find()));
  }
}
