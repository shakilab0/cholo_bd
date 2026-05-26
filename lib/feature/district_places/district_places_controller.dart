import 'package:get/get.dart';
import 'package:cholo_bd/core/routes/routes.dart';
import 'package:cholo_bd/feature/homepage/data/model/district_model.dart';
import 'package:cholo_bd/feature/homepage/data/model/place_model.dart';
import 'package:cholo_bd/feature/homepage/domain/useCase/get_places_by_district_use_case.dart';

class DistrictPlacesController extends GetxController {
  DistrictPlacesController(this._getPlacesByDistrict);

  final GetPlacesByDistrictUseCase _getPlacesByDistrict;

  late final DistrictModel district;

  final RxList<PlaceModel> allPlaces = <PlaceModel>[].obs;
  final RxList<PlaceModel> filteredPlaces = <PlaceModel>[].obs;
  final RxString activeFilter = 'all'.obs;
  final RxBool isLoadingPlaces = true.obs;
  final RxBool usedSeedFallback = false.obs;

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

  Future<void> _loadPlaces() async {
    isLoadingPlaces.value = true;
    usedSeedFallback.value = false;

    final result = await _getPlacesByDistrict.execute(district.id);
    result.fold(
      (_) => _applyPlaces(_seedForDistrict()),
      (remote) {
        if (remote.isEmpty) {
          usedSeedFallback.value = true;
          _applyPlaces(_seedForDistrict());
        } else {
          _applyPlaces(remote);
        }
      },
    );

    isLoadingPlaces.value = false;
  }

  List<PlaceModel> _seedForDistrict() =>
      seedPlaces.where((p) => p.districtId == district.id).toList();

  void _applyPlaces(List<PlaceModel> places) {
    allPlaces.assignAll(places);
    setFilter(activeFilter.value);
  }

  void setFilter(String filter) {
    activeFilter.value = filter;
    switch (filter) {
      case 'popular':
        filteredPlaces.assignAll(
          List.from(allPlaces)
            ..sort((a, b) => b.reviewCount.compareTo(a.reviewCount)),
        );
        break;
      case 'free':
        filteredPlaces.assignAll(allPlaces.where((p) => p.isFreeEntry).toList());
        break;
      case 'top_rated':
        filteredPlaces.assignAll(
          List.from(allPlaces)..sort((a, b) => b.rating.compareTo(a.rating)),
        );
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
