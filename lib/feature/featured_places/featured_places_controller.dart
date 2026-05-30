import 'package:get/get.dart';
import 'package:cholo_bd/core/routes/routes.dart';
import 'package:cholo_bd/feature/homepage/data/model/place_model.dart';
import 'package:cholo_bd/feature/homepage/domain/useCase/get_map_places_use_case.dart';

class FeaturedPlacesController extends GetxController {
  FeaturedPlacesController(this._getMapPlacesUseCase);

  final GetMapPlacesUseCase _getMapPlacesUseCase;

  final RxList<PlaceModel> places = <PlaceModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    isLoading.value = true;
    final result = await _getMapPlacesUseCase.execute();
    result.fold(
      (_) => places.clear(),
      (all) {
        places.assignAll(
          List<PlaceModel>.from(all)
            ..sort((a, b) => b.rating.compareTo(a.rating)),
        );
      },
    );
    isLoading.value = false;
  }

  void navigateToPlaceDetails(PlaceModel place) {
    Get.toNamed(AppRoutes.placeDetails, arguments: place);
  }
}
