import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:cholo_bd/core/routes/routes.dart';
import 'package:cholo_bd/feature/homepage/data/model/place_model.dart';
import 'package:cholo_bd/feature/homepage/domain/useCase/get_map_places_use_case.dart';

class PlacesMapController extends GetxController {
  PlacesMapController(this._getMapPlacesUseCase);

  final GetMapPlacesUseCase _getMapPlacesUseCase;

  final RxList<PlaceModel> places = <PlaceModel>[].obs;
  final Rx<PlaceModel?> selectedPlace = Rx<PlaceModel?>(null);
  final RxString activeFilter = 'all'.obs;
  final RxBool isLoading = true.obs;

  static const LatLng bangladeshCenter = LatLng(23.6850, 90.3563);

  @override
  void onInit() {
    super.onInit();
    loadPlaces();
  }

  Future<void> loadPlaces() async {
    isLoading.value = true;
    final result = await _getMapPlacesUseCase.execute();
    result.fold(
      (_) {},
      (data) => places.assignAll(data),
    );
    isLoading.value = false;
  }

  List<PlaceModel> get filteredPlaces {
    switch (activeFilter.value) {
      case 'free':
        return places.where((p) => p.isFreeEntry).toList();
      case 'top_rated':
        return List.from(places)
          ..sort((a, b) => b.rating.compareTo(a.rating));
      default:
        return places.toList();
    }
  }

  void selectPlace(PlaceModel place) => selectedPlace.value = place;
  void clearSelection() => selectedPlace.value = null;
  void setFilter(String f) => activeFilter.value = f;

  void goToPlaceDetails(PlaceModel place) {
    Get.toNamed(AppRoutes.placeDetails, arguments: place);
  }
}
