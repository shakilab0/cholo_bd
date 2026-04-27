import 'package:cholo_bd/feature/homepage/data/model/place_model.dart';
import 'package:cholo_bd/feature/trip_planning/data/model/transport_option_model.dart';

enum TripStatus { upcoming, active, completed }

class TripModel {
  final String id;
  final String name;
  final String districtId;
  final String districtName;
  final List<PlaceModel> places;
  final TransportOptionModel transport;
  final DateTime tripDate;
  final DateTime createdAt;
  final TripStatus status;
  final String? notes;

  const TripModel({
    required this.id,
    required this.name,
    required this.districtId,
    required this.districtName,
    required this.places,
    required this.transport,
    required this.tripDate,
    required this.createdAt,
    this.status = TripStatus.upcoming,
    this.notes,
  });

  String get autoName {
    final now = DateTime.now();
    final diff = tripDate.difference(now).inDays;
    if (diff == 0) return 'Today in $districtName';
    if (diff == 1) return 'Tomorrow in $districtName';
    final month = _monthName(tripDate.month);
    return '$month trip to $districtName';
  }

  String _monthName(int month) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month];
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'district_id': districtId,
        'district_name': districtName,
        'places': places.map((p) => p.toMap()).toList(),
        'transport': transport.toMap(),
        'trip_date': tripDate.millisecondsSinceEpoch,
        'created_at': createdAt.millisecondsSinceEpoch,
        'status': status.name,
        'notes': notes,
      };

  factory TripModel.fromMap(Map<String, dynamic> map) => TripModel(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        districtId: map['district_id'] ?? '',
        districtName: map['district_name'] ?? '',
        places: (map['places'] as List? ?? [])
            .map((p) => PlaceModel.fromMap(Map<String, dynamic>.from(p)))
            .toList(),
        transport: TransportOptionModel.fromMap(
            Map<String, dynamic>.from(map['transport'] ?? {})),
        tripDate: DateTime.fromMillisecondsSinceEpoch(map['trip_date'] ?? 0),
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] ?? 0),
        status: TripStatus.values.firstWhere(
          (s) => s.name == (map['status'] ?? 'upcoming'),
          orElse: () => TripStatus.upcoming,
        ),
        notes: map['notes'],
      );
}
