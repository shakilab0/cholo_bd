import 'package:get/get.dart';
import 'package:cholo_bd/feature/trip_planning/data/model/trip_model.dart';

class TripDetailsController extends GetxController {
  late final TripModel trip;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is TripModel) {
      trip = args;
    } else if (args is Map && args['trip'] is TripModel) {
      trip = args['trip'] as TripModel;
    }
  }

  String get statusLabel {
    switch (trip.status) {
      case TripStatus.upcoming:
        return 'Upcoming';
      case TripStatus.active:
        return 'Active';
      case TripStatus.completed:
        return 'Completed';
    }
  }

  void shareTrip() {
    // TODO: Implement share trip as a poster card (v1.1)
    Get.snackbar(
      'Coming Soon',
      'Trip sharing will be available in the next update.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
