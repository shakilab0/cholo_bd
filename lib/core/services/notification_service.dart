import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cholo_bd/core/services/trip_packing_service.dart';
import 'package:cholo_bd/feature/trip_planning/data/model/trip_model.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
        android: androidSettings, iOS: iosSettings);

    await _plugin.initialize(settings);
    _initialized = true;
  }

  Future<void> scheduleForTrip(TripModel trip) async {
    await init();
    final now = DateTime.now();
    final tripDate = trip.tripDate;

    await cancelForTrip(trip.id);

    final baseId = trip.id.hashCode.abs() % 100000;

    // D-2 reminder
    final dMinus2 = tripDate.subtract(const Duration(days: 2));
    if (dMinus2.isAfter(now)) {
      await _schedule(
        id: baseId,
        title: '📅 Trip Reminder',
        body:
            'Your trip to ${trip.districtName} is in 2 days — tap to review your itinerary.',
        scheduledDate: dMinus2.copyWith(hour: 9, minute: 0, second: 0),
      );
    }

    // D-1 weather/packing alert
    final dMinus1 = tripDate.subtract(const Duration(days: 1));
    if (dMinus1.isAfter(now)) {
      final body =
          await TripPackingService.instance.buildD1NotificationBody(trip);
      await _schedule(
        id: baseId + 1,
        title: '🎒 Pack & Get Ready',
        body: body,
        scheduledDate: dMinus1.copyWith(hour: 20, minute: 0, second: 0),
      );
    }

    // Transport-aware departure alert
    final departureMinutes = _departureOffsetMinutes(trip.transport.id);
    final departureAlert =
        tripDate.subtract(Duration(minutes: departureMinutes));
    if (departureAlert.isAfter(now)) {
      await _schedule(
        id: baseId + 2,
        title: '🚌 Time to Head Out!',
        body: _departureMessage(trip.transport.id, trip.districtName),
        scheduledDate: departureAlert,
      );
    }
  }

  Future<void> scheduleTripComplete(TripModel trip) async {
    await init();
    await _schedule(
      id: trip.id.hashCode.abs() % 100000 + 3,
      title: '🎉 Trip Complete!',
      body:
          'You explored ${trip.places.length} places in ${trip.districtName}! View your trip summary.',
      scheduledDate: DateTime.now().add(const Duration(seconds: 3)),
    );
  }

  Future<void> cancelForTrip(String tripId) async {
    final baseId = tripId.hashCode.abs() % 100000;
    for (int i = 0; i < 4; i++) {
      await _plugin.cancel(baseId + i);
    }
  }

  Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'smart_travel_bd',
      'Smart Travel BD',
      channelDescription: 'Trip reminders and alerts',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails();
    const details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      _toTZDateTime(scheduledDate),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // ignore: deprecated_member_use
  dynamic _toTZDateTime(DateTime dt) => dt;

  int _departureOffsetMinutes(String transportId) {
    switch (transportId) {
      case 'air':
        return 270; // 4.5 hours
      case 'train':
        return 120;
      case 'bus':
        return 180;
      case 'boat':
        return 180;
      case 'private_car':
        return 120;
      default:
        return 60;
    }
  }

  String _departureMessage(String transportId, String districtName) {
    switch (transportId) {
      case 'air':
        return 'Time to head to the airport for your trip to $districtName!';
      case 'train':
        return 'Time to head to the station for your trip to $districtName!';
      case 'bus':
        return 'Time to head to the bus stop for your trip to $districtName!';
      case 'boat':
        return 'Time to head to the launch ghat for your trip to $districtName!';
      default:
        return 'Time to get moving! Your trip to $districtName starts today.';
    }
  }
}
