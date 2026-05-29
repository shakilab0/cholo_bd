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
    'boat',
    'private_car',
  ];

  Future<TransportFilterResult> filterFeasibleTransports({
    required LatLng origin,
    required LatLng destination,
    required String startLabel,
    required String destinationName,
    required String districtName,
  }) async {
    final distanceKm = _haversineKm(origin, destination);

    if (!ApiKeys.hasGemini) {
      return _fallbackFilter(distanceKm);
    }

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

Transport modes (ids): ${_allIds.join(', ')}

Rules:
- Rickshaw/CNG: only for short urban trips (typically under 15-20 km).
- Boat: only where river/sea routes exist (e.g. Sundarbans, river districts); NOT for inland Dhaka suburbs like Savar to Mirpur.
- Train/Bus: inter-city or longer routes.
- private_car: usually available if roads exist.

Reply with ONLY valid JSON, no markdown:
{"available":["id1","id2"],"unavailable":[{"id":"boat","reason":"short reason in English"}]}
''';

      final response = await model.generateContent([Content.text(prompt)]);
      final text = response.text?.trim() ?? '';
      return _parseResponse(text, distanceKm);
    } catch (e) {
      log('GeminiTransportFilterService error: $e');
      return _fallbackFilter(distanceKm);
    }
  }

  TransportFilterResult _parseResponse(String text, double distanceKm) {
    try {
      var jsonStr = text;
      final fence = RegExp(r'```(?:json)?\s*([\s\S]*?)```');
      final match = fence.firstMatch(text);
      if (match != null) jsonStr = match.group(1)!.trim();

      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      final available = List<String>.from(map['available'] ?? [])
          .where((id) => _allIds.contains(id))
          .toList();
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
      if (available.isEmpty) {
        return _fallbackFilter(distanceKm);
      }
      for (final id in unavailable.keys) {
        available.remove(id);
      }
      return TransportFilterResult(
        availableIds: available,
        unavailableReasons: unavailable,
      );
    } catch (e) {
      log('Gemini parse error: $e — text: $text');
      return _fallbackFilter(distanceKm);
    }
  }

  TransportFilterResult _fallbackFilter(double distanceKm) {
    final available = <String>[];
    final unavailable = <String, String>{};

    for (final id in _allIds) {
      final ok = _fallbackIsAvailable(id, distanceKm);
      if (ok) {
        available.add(id);
      } else {
        unavailable[id] = _fallbackReason(id, distanceKm);
      }
    }

    return TransportFilterResult(
      availableIds: available,
      unavailableReasons: unavailable,
    );
  }

  bool _fallbackIsAvailable(String id, double distanceKm) {
    switch (id) {
      case 'rickshaw':
        return distanceKm <= 25;
      case 'boat':
      case 'cng':
        return distanceKm > 80;
      case 'bus':
      case 'train':
      case 'private_car':
        return true;
      default:
        return true;
    }
  }

  String _fallbackReason(String id, double distanceKm) {
    switch (id) {
      case 'rickshaw':
      case 'cng':
        return 'Too far for $id (${distanceKm.toStringAsFixed(0)} km)';
      case 'boat':
        return 'No practical boat route for this trip';
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
