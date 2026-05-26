import 'curated_places.dart';

/// Builds exactly 4 place payloads for a district (curated + templates).
List<Map<String, dynamic>> placesForDistrict(Map<String, dynamic> district) {
  final id = district['id'] as String;
  final name = district['name'] as String;
  final lat = (district['latitude'] as num).toDouble();
  final lng = (district['longitude'] as num).toDouble();

  final curated = curatedPlacesByDistrict[id];
  if (curated != null && curated.length >= 4) {
    return curated.take(4).map((p) => Map<String, dynamic>.from(p)).toList();
  }

  final result = <Map<String, dynamic>>[];
  if (curated != null) {
    result.addAll(curated.map((p) => Map<String, dynamic>.from(p)));
  }

  final templates = _templates(name, lat, lng);
  var i = 0;
  while (result.length < 4 && i < templates.length) {
    result.add(Map<String, dynamic>.from(templates[i]));
    i++;
  }
  return result;
}

List<Map<String, dynamic>> _templates(
  String districtName,
  double lat,
  double lng,
) {
  return [
    {
      'name': '$districtName Central Park',
      'name_bn': '$districtName সেন্ট্রাল পার্ক',
      'description':
          'A green park in $districtName popular with families and evening walks.',
      'images': <String>[],
      'videos': <String>[],
      'entry_fee': 0.0,
      'is_free_entry': true,
      'visit_duration': '1-2 hours',
      'best_time': 'October - March',
      'opening_hours': '6 AM - 8 PM',
      'latitude': lat + 0.012,
      'longitude': lng + 0.008,
      'rating': 4.0,
      'review_count': 180,
      'tags': ['park', 'family', 'nature'],
    },
    {
      'name': '$districtName Heritage Mosque',
      'name_bn': '$districtName ঐতিহ্যবাহী মসজিদ',
      'description':
          'Historic mosque reflecting local architecture in $districtName.',
      'images': <String>[],
      'videos': <String>[],
      'entry_fee': 0.0,
      'is_free_entry': true,
      'visit_duration': '30-60 minutes',
      'best_time': 'Year round',
      'opening_hours': 'Open daily',
      'latitude': lat - 0.008,
      'longitude': lng + 0.015,
      'rating': 4.1,
      'review_count': 220,
      'tags': ['mosque', 'heritage', 'architecture'],
    },
    {
      'name': '$districtName River Viewpoint',
      'name_bn': '$districtName নদী দর্শন',
      'description':
          'Scenic riverside spot to enjoy sunsets and local boat traffic.',
      'images': <String>[],
      'videos': <String>[],
      'entry_fee': 0.0,
      'is_free_entry': true,
      'visit_duration': '1-2 hours',
      'best_time': 'November - February',
      'opening_hours': 'Open daily',
      'latitude': lat + 0.005,
      'longitude': lng - 0.018,
      'rating': 4.2,
      'review_count': 150,
      'tags': ['river', 'sunset', 'scenic'],
    },
    {
      'name': '$districtName Local Market',
      'name_bn': '$districtName ঐতিহ্যবাহী বাজার',
      'description':
          'Bustling market to experience local food, crafts and culture.',
      'images': <String>[],
      'videos': <String>[],
      'entry_fee': 0.0,
      'is_free_entry': true,
      'visit_duration': '2-3 hours',
      'best_time': 'Year round',
      'opening_hours': '8 AM - 9 PM',
      'latitude': lat - 0.015,
      'longitude': lng - 0.006,
      'rating': 3.9,
      'review_count': 120,
      'tags': ['market', 'food', 'local', 'culture'],
    },
  ];
}
