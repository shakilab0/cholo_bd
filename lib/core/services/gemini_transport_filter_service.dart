import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:latlong2/latlong.dart';
import 'package:cholo_bd/config/api_keys.dart';

class TransportFilterResult {
  final List<String> availableIds;
  final Map<String, String> unavailableReasons;

  const TransportFilterResult({
    required this.availableIds,
    required this.unavailableReasons,
  });
}

class GeminiTransportFilterService {
  static const _allIds = [
    'rickshaw',
    'cng',
    'bus',
    'train',
    'air',
    'boat',
    'private_car',
  ];

  /// Districts where boat/launch routes are commonly used for travel.
  static const _boatRouteDistrictIds = {
    'khulna',
    'bagerhat',
    'satkhira',
    'barishal',
    'bhola',
    'jhalokati',
    'patuakhali',
    'pirojpur',
    'barguna',
    'shariatpur',
    'madaripur',
    'chandpur',
    'gopalganj',
    'rangamati',
    'bandarban',
    'coxs-bazar',
    'chittagong',
    'sunamganj',
    'kishoreganj',
    'narail',
    'lakshmipur',
    'noakhali',
  };

  Future<TransportFilterResult> filterFeasibleTransports({
    required LatLng origin,
    required LatLng destination,
    required String startLabel,
    required String destinationName,
    required String districtName,
    String? districtId,
    bool destinationRequiresBoat = false,
  }) async {
    final distanceKm = _haversineKm(origin, destination);
    final hasBoatRoute = _hasBoatRoute(
      districtId: districtId,
      districtName: districtName,
      destinationRequiresBoat: destinationRequiresBoat,
    );

    if (ApiKeys.hasGemini) {
      try {
        final model = GenerativeModel(
          model: 'gemini-2.0-flash',
          apiKey: ApiKeys.gemini,
        );
        final prompt = '''
You are a Bangladesh travel expert. Given a trip route, decide which transport modes are realistically usable.

Origin: $startLabel (${origin.latitude.toStringAsFixed(4)}, ${origin.longitude.toStringAsFixed(4)})
Destination: $destinationName, $districtName (${destination.latitude.toStringAsFixed(4)}, ${destination.longitude.toStringAsFixed(4)})
Straight-line distance: ${distanceKm.toStringAsFixed(1)} km
Boat route likely: $hasBoatRoute

Transport modes (ids): ${_allIds.join(', ')}

Distance rules (must follow):
- Within 15 km: all modes allowed (including rickshaw and CNG).
- Under 80 km: all except rickshaw (rickshaw only within 15 km).
- 80 km and above: all except rickshaw and CNG.
- Boat: only where river/sea/launch routes exist; never for typical inland road-only trips.

Reply with ONLY valid JSON, no markdown:
{"available":["id1","id2"],"unavailable":[{"id":"boat","reason":"short reason in English"}]}
''';

        final response = await model.generateContent([Content.text(prompt)]);
        final text = response.text?.trim() ?? '';
        final parsed = _parseResponse(text);
        if (parsed != null) {
          return _enforceRules(
            distanceKm: distanceKm,
            hasBoatRoute: hasBoatRoute,
            geminiUnavailable: parsed.unavailableReasons,
          );
        }
      } catch (e) {
        log('GeminiTransportFilterService error: $e');
      }
    }

    return _ruleBasedFilter(
      distanceKm: distanceKm,
      hasBoatRoute: hasBoatRoute,
    );
  }

  TransportFilterResult? _parseResponse(String text) {
    try {
      var jsonStr = text;
      final fence = RegExp(r'```(?:json)?\s*([\s\S]*?)```');
      final match = fence.firstMatch(text);
      if (match != null) jsonStr = match.group(1)!.trim();

      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      final unavailable = <String, String>{};
      for (final item in map['unavailable'] as List? ?? []) {
        if (item is Map) {
          final id = item['id']?.toString();
          final reason = item['reason']?.toString();
          if (id != null && _allIds.contains(id)) {
            unavailable[id] = reason ?? 'Not suitable for this route';
          }
        }
      }
      return TransportFilterResult(availableIds: const [], unavailableReasons: unavailable);
    } catch (e) {
      log('Gemini parse error: $e — text: $text');
      return null;
    }
  }

  TransportFilterResult _enforceRules({
    required double distanceKm,
    required bool hasBoatRoute,
    Map<String, String>? geminiUnavailable,
  }) {
    return _ruleBasedFilter(
      distanceKm: distanceKm,
      hasBoatRoute: hasBoatRoute,
      geminiUnavailable: geminiUnavailable,
    );
  }

  TransportFilterResult _ruleBasedFilter({
    required double distanceKm,
    required bool hasBoatRoute,
    Map<String, String>? geminiUnavailable,
  }) {
    final available = <String>[];
    final unavailable = <String, String>{};

    for (final id in _allIds) {
      if (_isAvailableByRules(id, distanceKm, hasBoatRoute)) {
        available.add(id);
      } else {
        unavailable[id] = geminiUnavailable?[id] ??
            _unavailableReason(id, distanceKm, hasBoatRoute);
      }
    }

    return TransportFilterResult(
      availableIds: available,
      unavailableReasons: unavailable,
    );
  }

  bool _isAvailableByRules(
    String id,
    double distanceKm,
    bool hasBoatRoute,
  ) {
    switch (id) {
      case 'rickshaw':
        return distanceKm <= 15;
      case 'cng':
        return distanceKm < 80;
      case 'boat':
        return hasBoatRoute;
      default:
        return true;
    }
  }

  bool _hasBoatRoute({
    String? districtId,
    required String districtName,
    required bool destinationRequiresBoat,
  }) {
    if (destinationRequiresBoat) return true;
    if (districtId != null && _boatRouteDistrictIds.contains(districtId)) {
      return true;
    }
    final normalized = districtName.toLowerCase();
    if (normalized.contains('sundarbans')) return true;
    return false;
  }

  String _unavailableReason(
    String id,
    double distanceKm,
    bool hasBoatRoute,
  ) {
    switch (id) {
      case 'rickshaw':
        return 'Rickshaw only for trips within 15 km (${distanceKm.toStringAsFixed(0)} km)';
      case 'cng':
        return 'CNG only for trips under 80 km (${distanceKm.toStringAsFixed(0)} km)';
      case 'boat':
        return hasBoatRoute
            ? 'No practical boat route for this trip'
            : 'No boat route to this destination';
      default:
        return 'Not available';
    }
  }

  double _haversineKm(LatLng a, LatLng b) {
    const earthRadiusKm = 6371.0;
    final dLat = _toRad(b.latitude - a.latitude);
    final dLon = _toRad(b.longitude - a.longitude);
    final lat1 = _toRad(a.latitude);
    final lat2 = _toRad(b.latitude);
    final h = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    return earthRadiusKm * 2 * math.atan2(math.sqrt(h), math.sqrt(1 - h));
  }

  double _toRad(double deg) => deg * math.pi / 180.0;
}
