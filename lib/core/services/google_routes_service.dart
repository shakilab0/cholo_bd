import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:cholo_bd/config/api_keys.dart';

class RouteResult {
  final int durationMinutes;
  final double distanceKm;

  const RouteResult({
    required this.durationMinutes,
    required this.distanceKm,
  });
}

class GoogleRoutesService {
  GoogleRoutesService() : _dio = Dio();

  final Dio _dio;
  static const _baseUrl =
      'https://routes.googleapis.com/directions/v2:computeRoutes';

  Future<RouteResult?> computeRoute({
    required LatLng origin,
    required LatLng destination,
    required String travelMode,
  }) async {
    if (!ApiKeys.hasGoogleMaps) return null;

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _baseUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'X-Goog-Api-Key': ApiKeys.googleMaps,
            'X-Goog-FieldMask': 'routes.duration,routes.distanceMeters',
          },
          sendTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
        ),
        data: {
          'origin': {
            'location': {
              'latLng': {
                'latitude': origin.latitude,
                'longitude': origin.longitude,
              },
            },
          },
          'destination': {
            'location': {
              'latLng': {
                'latitude': destination.latitude,
                'longitude': destination.longitude,
              },
            },
          },
          'travelMode': travelMode,
          'routingPreference': 'TRAFFIC_AWARE',
        },
      );

      final routes = response.data?['routes'] as List?;
      if (routes == null || routes.isEmpty) return null;

      final route = routes.first as Map<String, dynamic>;
      final durationStr = route['duration'] as String?; // e.g. "1234s"
      final distanceMeters = (route['distanceMeters'] as num?)?.toDouble();
      if (durationStr == null || distanceMeters == null) return null;

      final seconds = int.tryParse(durationStr.replaceAll('s', '')) ?? 0;
      return RouteResult(
        durationMinutes: (seconds / 60).ceil().clamp(1, 9999),
        distanceKm: distanceMeters / 1000,
      );
    } on DioException catch (e) {
      log('GoogleRoutesService $travelMode: ${e.response?.data ?? e.message}');
      return null;
    } catch (e) {
      log('GoogleRoutesService error: $e');
      return null;
    }
  }

  /// Maps app transport id to Google Routes travelMode.
  String? travelModeForTransport(String transportId, {double? distanceKm}) {
    switch (transportId) {
      case 'private_car':
        return 'DRIVE';
      case 'bus':
      case 'train':
        return 'TRANSIT';
      case 'cng':
        return 'TWO_WHEELER';
      case 'rickshaw':
        if (distanceKm != null && distanceKm <= 5) return 'WALK';
        return 'DRIVE';
      case 'boat':
        return null;
      default:
        return 'DRIVE';
    }
  }

  Future<RouteResult?> routeForTransport({
    required String transportId,
    required LatLng origin,
    required LatLng destination,
    double? straightLineKm,
  }) async {
    var mode = travelModeForTransport(transportId, distanceKm: straightLineKm);
    if (mode == null) return null;

    var result = await computeRoute(
      origin: origin,
      destination: destination,
      travelMode: mode,
    );

    if (result == null &&
        (transportId == 'bus' || transportId == 'train') &&
        mode == 'TRANSIT') {
      result = await computeRoute(
        origin: origin,
        destination: destination,
        travelMode: 'DRIVE',
      );
    }

    return result;
  }
}
