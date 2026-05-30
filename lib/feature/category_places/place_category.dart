import 'package:flutter/material.dart';

class PlaceCategory {
  final String id;
  final String title;
  final IconData icon;
  final List<String> matchTags;

  const PlaceCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.matchTags,
  });

  static const beaches = PlaceCategory(
    id: 'beaches',
    title: 'Beaches',
    icon: Icons.beach_access_rounded,
    matchTags: ['beach'],
  );

  static const nature = PlaceCategory(
    id: 'nature',
    title: 'Nature',
    icon: Icons.forest_rounded,
    matchTags: [
      'nature',
      'forest',
      'waterfall',
      'garden',
      'tea',
      'mangrove',
      'lake',
      'hill',
      'river',
      'island',
    ],
  );

  static const heritage = PlaceCategory(
    id: 'heritage',
    title: 'Heritage',
    icon: Icons.museum_rounded,
    matchTags: [
      'heritage',
      'museum',
      'fort',
      'temple',
      'archaeology',
      'history',
      'architecture',
      'mughal',
    ],
  );

  static const adventure = PlaceCategory(
    id: 'adventure',
    title: 'Adventure',
    icon: Icons.hiking_rounded,
    matchTags: [
      'adventure',
      'trekking',
      'hiking',
      'diving',
      'wildlife',
      'tiger',
      'boat',
    ],
  );

  static const List<PlaceCategory> all = [
    beaches,
    nature,
    heritage,
    adventure,
  ];

  static PlaceCategory? fromId(String id) {
    for (final c in all) {
      if (c.id == id) return c;
    }
    return null;
  }
}
