import 'package:get/get.dart';
import 'package:cholo_bd/core/routes/routes.dart';
import 'package:cholo_bd/feature/homepage/data/model/district_model.dart';
import 'package:cholo_bd/feature/homepage/data/model/place_model.dart';

class DistrictPlacesController extends GetxController {
  late final DistrictModel district;

  final RxList<PlaceModel> allPlaces = <PlaceModel>[].obs;
  final RxList<PlaceModel> filteredPlaces = <PlaceModel>[].obs;
  final RxString activeFilter = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is DistrictModel) {
      district = args;
    } else if (args is Map && args['district'] is DistrictModel) {
      district = args['district'] as DistrictModel;
    }
    _loadPlaces();
  }

  void _loadPlaces() {
    final places = seedPlaces.where((p) => p.districtId == district.id).toList();
    allPlaces.assignAll(places);
    filteredPlaces.assignAll(places);
  }

  void setFilter(String filter) {
    activeFilter.value = filter;
    switch (filter) {
      case 'popular':
        filteredPlaces.assignAll(
            List.from(allPlaces)..sort((a, b) => b.reviewCount.compareTo(a.reviewCount)));
        break;
      case 'free':
        filteredPlaces.assignAll(allPlaces.where((p) => p.isFreeEntry).toList());
        break;
      case 'top_rated':
        filteredPlaces.assignAll(
            List.from(allPlaces)..sort((a, b) => b.rating.compareTo(a.rating)));
        break;
      default:
        filteredPlaces.assignAll(allPlaces);
    }
  }

  void navigateToPlaceDetails(PlaceModel place) {
    Get.toNamed(AppRoutes.placeDetails, arguments: place);
  }

  void startTripHere() {
    Get.toNamed(AppRoutes.tripPlanning, arguments: {'district': district});
  }
}
