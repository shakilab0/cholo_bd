import 'package:dio/dio.dart';
import 'package:cholo_bd/feature/trip_planning/data/model/trip_model.dart';

class TripPackingService {
  TripPackingService._();
  static final TripPackingService instance = TripPackingService._();

  final Dio _dio = Dio();

  Future<String> buildD1NotificationBody(TripModel trip) async {
    final placesLabel = _formatPlacesLabel(trip);
    final items = await _packingItemsForTrip(trip);
    final buffer = StringBuffer(
      'Your trip to $placesLabel is tomorrow! Check your packing list.',
    );
    if (items.isNotEmpty) {
      buffer.write(' ${items.join(', ')}.');
    }
    return buffer.toString();
  }

  String _formatPlacesLabel(TripModel trip) {
    if (trip.places.isEmpty) return trip.districtName;
    final names = trip.places.map((p) => p.name).take(3).toList();
    if (trip.places.length > 3) {
      return '${names.join(', ')} & ${trip.places.length - 3} more';
    }
    return names.join(', ');
  }

  Future<List<String>> _packingItemsForTrip(TripModel trip) async {
    try {
      if (trip.places.isEmpty) return _defaultItems();

      final lat = trip.places.first.latitude;
      final lng = trip.places.first.longitude;
      if (lat == 0 && lng == 0) return _defaultItems();

      final date = trip.tripDate;
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      final response = await _dio.get(
        'https://api.open-meteo.com/v1/forecast',
        queryParameters: {
          'latitude': lat,
          'longitude': lng,
          'daily':
              'temperature_2m_max,temperature_2m_min,precipitation_probability_max,weathercode',
          'timezone': 'Asia/Dhaka',
          'start_date': dateStr,
          'end_date': dateStr,
        },
      );

      final daily = response.data['daily'] as Map<String, dynamic>?;
      if (daily == null) return _defaultItems();

      final maxTemp = (daily['temperature_2m_max'] as List?)?.first as num?;
      final minTemp = (daily['temperature_2m_min'] as List?)?.first as num?;
      final rainProb =
          (daily['precipitation_probability_max'] as List?)?.first as num?;
      final weatherCode = (daily['weathercode'] as List?)?.first as num?;

      return _itemsFromWeather(
        maxTemp: maxTemp?.toDouble(),
        minTemp: minTemp?.toDouble(),
        rainProb: rainProb?.toDouble(),
        weatherCode: weatherCode?.toInt(),
      );
    } catch (_) {
      return _defaultItems();
    }
  }

  List<String> _itemsFromWeather({
    double? maxTemp,
    double? minTemp,
    double? rainProb,
    int? weatherCode,
  }) {
    final items = <String>[];
    if (maxTemp != null && maxTemp >= 30) {
      items.add('water bottle');
      items.add('sunscreen');
    }
    if (minTemp != null && minTemp <= 18) {
      items.add('cold cream');
      items.add('warm layer');
    }
    final rainy =
        (rainProb != null && rainProb >= 40) || _isRainCode(weatherCode);
    if (rainy) items.add('umbrella');
    if (items.isEmpty) return _defaultItems();
    return items;
  }

  bool _isRainCode(int? code) {
    if (code == null) return false;
    return (code >= 51 && code <= 67) ||
        (code >= 80 && code <= 82) ||
        (code >= 95 && code <= 99);
  }

  List<String> _defaultItems() => ['water bottle', 'umbrella'];
}
