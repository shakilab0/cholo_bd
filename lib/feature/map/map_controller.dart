import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:cholo_bd/core/routes/routes.dart';
import 'package:cholo_bd/feature/homepage/data/model/place_model.dart';

class PlacesMapController extends GetxController {
  final RxList<PlaceModel> places = <PlaceModel>[].obs;
  final Rx<PlaceModel?> selectedPlace = Rx<PlaceModel?>(null);
  final RxString activeFilter = 'all'.obs;

  // Bangladesh center
  static const LatLng bangladeshCenter = LatLng(23.6850, 90.3563);

  @override
  void onInit() {
    super.onInit();
    places.assignAll(seedPlaces);
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
