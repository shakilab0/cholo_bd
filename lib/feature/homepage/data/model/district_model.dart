class DistrictModel {
  final String id;
  final String name;
  final String nameBn;
  final String description;
  final String coverImageUrl;
  final int placeCount;
  final double latitude;
  final double longitude;

  const DistrictModel({
    required this.id,
    required this.name,
    required this.nameBn,
    required this.description,
    required this.coverImageUrl,
    required this.placeCount,
    required this.latitude,
    required this.longitude,
  });

  factory DistrictModel.fromMap(Map<String, dynamic> map) => DistrictModel(
        id: map['\$id'] ?? map['id'] ?? '',
        name: map['name'] ?? '',
        nameBn: map['name_bn'] ?? '',
        description: map['description'] ?? '',
        coverImageUrl: map['cover_image_url'] ?? '',
        placeCount: map['place_count'] ?? 0,
        latitude: (map['latitude'] ?? 0.0).toDouble(),
        longitude: (map['longitude'] ?? 0.0).toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'name_bn': nameBn,
        'description': description,
        'cover_image_url': coverImageUrl,
        'place_count': placeCount,
        'latitude': latitude,
        'longitude': longitude,
      };
}

// Seed data used as offline fallback when Appwrite isn't configured
final List<DistrictModel> seedDistricts = [
  const DistrictModel(
    id: 'coxs-bazar',
    name: "Cox's Bazar",
    nameBn: 'কক্সবাজার',
    description: "World's longest natural sea beach",
    coverImageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/Laboni_Beach%2C_Cox%27s_Bazar.jpg/1280px-Laboni_Beach%2C_Cox%27s_Bazar.jpg',
    placeCount: 14,
    latitude: 21.4272,
    longitude: 92.0058,
  ),
  const DistrictModel(
    id: 'sylhet',
    name: 'Sylhet',
    nameBn: 'সিলেট',
    description: 'Tea gardens & spiritual sites',
    coverImageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/Srimangal_Tea_Garden.jpg/1280px-Srimangal_Tea_Garden.jpg',
    placeCount: 18,
    latitude: 24.8949,
    longitude: 91.8687,
  ),
  const DistrictModel(
    id: 'bandarban',
    name: 'Bandarban',
    nameBn: 'বান্দরবান',
    description: 'Hill tracts & tribal culture',
    coverImageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/Bandarban_district.jpg/1280px-Bandarban_district.jpg',
    placeCount: 11,
    latitude: 22.1953,
    longitude: 92.2184,
  ),
  const DistrictModel(
    id: 'sundarbans',
    name: 'Sundarbans',
    nameBn: 'সুন্দরবন',
    description: "World's largest mangrove forest",
    coverImageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/A_view_of_the_Sundarbans.jpg/1280px-A_view_of_the_Sundarbans.jpg',
    placeCount: 9,
    latitude: 21.9497,
    longitude: 89.1833,
  ),
  const DistrictModel(
    id: 'dhaka',
    name: 'Dhaka',
    nameBn: 'ঢাকা',
    description: 'Capital city & historical monuments',
    coverImageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/95/Ahsan_Manzil.jpg/1280px-Ahsan_Manzil.jpg',
    placeCount: 22,
    latitude: 23.8103,
    longitude: 90.4125,
  ),
  const DistrictModel(
    id: 'chittagong',
    name: 'Chittagong',
    nameBn: 'চট্টগ্রাম',
    description: 'Port city with scenic hills',
    coverImageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Patenga_Sea_Beach.jpg/1280px-Patenga_Sea_Beach.jpg',
    placeCount: 16,
    latitude: 22.3569,
    longitude: 91.7832,
  ),
  const DistrictModel(
    id: 'rangamati',
    name: 'Rangamati',
    nameBn: 'রাঙামাটি',
    description: 'Lake city & indigenous culture',
    coverImageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bf/Kaptai_Lake.jpg/1280px-Kaptai_Lake.jpg',
    placeCount: 8,
    latitude: 22.6500,
    longitude: 92.1809,
  ),
  const DistrictModel(
    id: 'rajshahi',
    name: 'Rajshahi',
    nameBn: 'রাজশাহী',
    description: 'Silk city & historical sites',
    coverImageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Varendra_Research_Museum.jpg/1280px-Varendra_Research_Museum.jpg',
    placeCount: 12,
    latitude: 24.3745,
    longitude: 88.6042,
  ),
];
