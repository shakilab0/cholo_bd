import 'package:flutter/material.dart';

class TransportOptionModel {
  final String id;
  final String name;
  final String nameBn;
  final IconData icon;
  final String estimatedTime;
  final String estimatedCost;
  final String description;

  const TransportOptionModel({
    required this.id,
    required this.name,
    required this.nameBn,
    required this.icon,
    required this.estimatedTime,
    required this.estimatedCost,
    required this.description,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'name_bn': nameBn,
        'estimated_time': estimatedTime,
        'estimated_cost': estimatedCost,
      };

  factory TransportOptionModel.fromMap(Map<String, dynamic> map) {
    final id = map['id'] ?? 'bus';
    return bangladeshTransports.firstWhere(
      (t) => t.id == id,
      orElse: () => bangladeshTransports.first,
    );
  }
}

final List<TransportOptionModel> bangladeshTransports = const [
  TransportOptionModel(
    id: 'rickshaw',
    name: 'Rickshaw',
    nameBn: 'রিকশা',
    icon: Icons.pedal_bike_rounded,
    estimatedTime: '15–30 min (local)',
    estimatedCost: '৳20–80',
    description: 'Best for short local distances',
  ),
  TransportOptionModel(
    id: 'cng',
    name: 'CNG Auto',
    nameBn: 'সিএনজি অটো',
    icon: Icons.electric_rickshaw_rounded,
    estimatedTime: '20–60 min',
    estimatedCost: '৳80–250',
    description: 'Fastest for city travel',
  ),
  TransportOptionModel(
    id: 'bus',
    name: 'Bus',
    nameBn: 'বাস',
    icon: Icons.directions_bus_rounded,
    estimatedTime: '2–5 hrs',
    estimatedCost: '৳200–600',
    description: 'Affordable for inter-district travel',
  ),
  TransportOptionModel(
    id: 'train',
    name: 'Train',
    nameBn: 'ট্রেন',
    icon: Icons.train_rounded,
    estimatedTime: '3–8 hrs',
    estimatedCost: '৳150–500',
    description: 'Comfortable long-distance travel',
  ),
  TransportOptionModel(
    id: 'boat',
    name: 'Boat',
    nameBn: 'নৌকা / লঞ্চ',
    icon: Icons.directions_boat_rounded,
    estimatedTime: '4–12 hrs',
    estimatedCost: '৳200–800',
    description: 'Essential for Sundarbans & river districts',
  ),
  TransportOptionModel(
    id: 'private_car',
    name: 'Private Car',
    nameBn: 'ব্যক্তিগত গাড়ি',
    icon: Icons.directions_car_rounded,
    estimatedTime: '2–6 hrs',
    estimatedCost: '৳1500–4000',
    description: 'Most comfortable, flexible timing',
  ),
];
