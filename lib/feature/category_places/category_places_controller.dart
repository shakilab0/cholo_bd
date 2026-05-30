import 'package:get/get.dart';
import 'package:cholo_bd/core/routes/routes.dart';
import 'package:cholo_bd/feature/category_places/place_category.dart';
import 'package:cholo_bd/feature/homepage/data/model/place_model.dart';
import 'package:cholo_bd/feature/homepage/domain/useCase/get_map_places_use_case.dart';

class CategoryPlacesController extends GetxController {
  CategoryPlacesController(this._getMapPlacesUseCase);

  final GetMapPlacesUseCase _getMapPlacesUseCase;

  late final PlaceCategory category;

  final RxList<PlaceModel> places = <PlaceModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    final id = args is String ? args : args is PlaceCategory ? args.id : '';
    category = PlaceCategory.fromId(id) ?? PlaceCategory.beaches;
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    isLoading.value = true;
    final result = await _getMapPlacesUseCase.execute();
    result.fold(
      (_) => places.clear(),
      (all) {
        final tags = category.matchTags.map((t) => t.toLowerCase()).toSet();
        places.assignAll(all.where((p) {
          return p.tags.any((tag) => tags.contains(tag.toLowerCase()));
        }).toList()
          ..sort((a, b) => b.rating.compareTo(a.rating)));
      },
    );
    isLoading.value = false;
  }

  void navigateToPlaceDetails(PlaceModel place) {
    Get.toNamed(AppRoutes.placeDetails, arguments: place);
  }

  void navigateToTripPlanning() {
    Get.toNamed(AppRoutes.tripPlanning);
  }
}
