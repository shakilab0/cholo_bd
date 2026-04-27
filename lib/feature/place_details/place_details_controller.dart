import 'package:get/get.dart';
import 'package:cholo_bd/core/routes/routes.dart';
import 'package:cholo_bd/feature/homepage/data/model/place_model.dart';

class PlaceDetailsController extends GetxController {
  late final PlaceModel place;

  final RxInt currentImageIndex = 0.obs;
  final RxBool isSaved = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is PlaceModel) {
      place = args;
    } else if (args is Map<String, dynamic> && args['place'] is PlaceModel) {
      place = args['place'] as PlaceModel;
    }
  }

  void onImageChanged(int index) => currentImageIndex.value = index;

  void toggleSave() => isSaved.value = !isSaved.value;

  void planTripHere() {
    Get.toNamed(AppRoutes.tripPlanning, arguments: {'district': null});
  }
}
