class PlaceModel {
  final String id;
  final String name;
  final String nameBn;
  final String description;
  final String districtId;
  final String districtName;
  final List<String> images;
  final double entryFee;
  final bool isFreeEntry;
  final String visitDuration;
  final String bestTime;
  final String openingHours;
  final double latitude;
  final double longitude;
  final double rating;
  final int reviewCount;
  final List<String> tags;

  const PlaceModel({
    required this.id,
    required this.name,
    required this.nameBn,
    required this.description,
    required this.districtId,
    required this.districtName,
    required this.images,
    required this.entryFee,
    required this.isFreeEntry,
    required this.visitDuration,
    required this.bestTime,
    required this.openingHours,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.reviewCount,
    required this.tags,
  });

  factory PlaceModel.fromMap(Map<String, dynamic> map) => PlaceModel(
        id: map['\$id'] ?? map['id'] ?? '',
        name: map['name'] ?? '',
        nameBn: map['name_bn'] ?? '',
        description: map['description'] ?? '',
        districtId: map['district_id'] ?? '',
        districtName: map['district_name'] ?? '',
        images: List<String>.from(map['images'] ?? []),
        entryFee: (map['entry_fee'] ?? 0.0).toDouble(),
        isFreeEntry: map['is_free_entry'] ?? true,
        visitDuration: map['visit_duration'] ?? '1-2 hours',
        bestTime: map['best_time'] ?? 'October - March',
        openingHours: map['opening_hours'] ?? 'Open daily',
        latitude: (map['latitude'] ?? 0.0).toDouble(),
        longitude: (map['longitude'] ?? 0.0).toDouble(),
        rating: (map['rating'] ?? 4.0).toDouble(),
        reviewCount: map['review_count'] ?? 0,
        tags: List<String>.from(map['tags'] ?? []),
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'name_bn': nameBn,
        'description': description,
        'district_id': districtId,
        'district_name': districtName,
        'images': images,
        'entry_fee': entryFee,
        'is_free_entry': isFreeEntry,
        'visit_duration': visitDuration,
        'best_time': bestTime,
        'opening_hours': openingHours,
        'latitude': latitude,
        'longitude': longitude,
        'rating': rating,
        'review_count': reviewCount,
        'tags': tags,
      };
}

final List<PlaceModel> seedPlaces = const [
  // Cox's Bazar
  PlaceModel(id: 'p_cox_1', name: "Laboni Beach", nameBn: "লাবণী বিচ", description: "The most accessible and popular beach in Cox's Bazar, lined with stalls and hotels.", districtId: 'coxs-bazar', districtName: "Cox's Bazar", images: ['https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/Laboni_beach_01.JPG/1280px-Laboni_beach_01.JPG'], entryFee: 0, isFreeEntry: true, visitDuration: '2-3 hours', bestTime: 'October - March', openingHours: 'Open daily', latitude: 21.4272, longitude: 92.0058, rating: 4.5, reviewCount: 1200, tags: ['beach', 'sunset', 'popular']),
  PlaceModel(id: 'p_cox_2', name: "Himchari", nameBn: "হিমছড়ি", description: "Scenic hilltop viewpoint with a waterfall and stunning sea views.", districtId: 'coxs-bazar', districtName: "Cox's Bazar", images: ['https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/Himchari_Waterfall.jpg/1280px-Himchari_Waterfall.jpg'], entryFee: 50, isFreeEntry: false, visitDuration: '3-4 hours', bestTime: 'July - September', openingHours: '8 AM - 5 PM', latitude: 21.3500, longitude: 91.9833, rating: 4.3, reviewCount: 850, tags: ['waterfall', 'nature', 'hiking']),
  PlaceModel(id: 'p_cox_3', name: "Inani Beach", nameBn: "ইনানী বিচ", description: "Pristine beach with unique coral rocks and crystal-clear water.", districtId: 'coxs-bazar', districtName: "Cox's Bazar", images: ['https://upload.wikimedia.org/wikipedia/commons/thumb/8/8e/Inani_beach.jpg/1280px-Inani_beach.jpg'], entryFee: 0, isFreeEntry: true, visitDuration: '2-3 hours', bestTime: 'November - February', openingHours: 'Open daily', latitude: 21.3000, longitude: 91.9667, rating: 4.7, reviewCount: 980, tags: ['beach', 'coral', 'scenic']),
  PlaceModel(id: 'p_cox_4', name: "Saint Martin Island", nameBn: "সেন্ট মার্টিন দ্বীপ", description: "Bangladesh's only coral island — crystal blue water and coral reefs.", districtId: 'coxs-bazar', districtName: "Cox's Bazar", images: ['https://upload.wikimedia.org/wikipedia/commons/thumb/5/52/Saint_Martin%27s_Island_1.jpg/1280px-Saint_Martin%27s_Island_1.jpg'], entryFee: 0, isFreeEntry: true, visitDuration: 'Full day', bestTime: 'November - February', openingHours: 'Open daily', latitude: 20.6271, longitude: 92.3209, rating: 4.9, reviewCount: 2100, tags: ['island', 'coral', 'diving', 'scenic']),
  // Sylhet
  PlaceModel(id: 'p_syl_1', name: "Ratargul Swamp Forest", nameBn: "রাতারগুল সোয়াম্প ফরেস্ট", description: "Bangladesh's only freshwater swamp forest, accessible by boat.", districtId: 'sylhet', districtName: "Sylhet", images: ['https://upload.wikimedia.org/wikipedia/commons/thumb/a/a1/Ratargul_Swamp_Forest.jpg/1280px-Ratargul_Swamp_Forest.jpg'], entryFee: 100, isFreeEntry: false, visitDuration: '3-5 hours', bestTime: 'June - October', openingHours: '7 AM - 5 PM', latitude: 25.0000, longitude: 91.9167, rating: 4.8, reviewCount: 1500, tags: ['forest', 'boat', 'nature', 'unique']),
  PlaceModel(id: 'p_syl_2', name: "Jaflong", nameBn: "জাফলং", description: "Stone collection point at the Piyain River with border views.", districtId: 'sylhet', districtName: "Sylhet", images: ['https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/Jaflong_-_Sylhet.jpg/1280px-Jaflong_-_Sylhet.jpg'], entryFee: 20, isFreeEntry: false, visitDuration: '2-3 hours', bestTime: 'October - March', openingHours: 'Open daily', latitude: 25.1500, longitude: 91.8833, rating: 4.4, reviewCount: 1100, tags: ['river', 'scenic', 'stones']),
  PlaceModel(id: 'p_syl_3', name: "Sreemangal Tea Gardens", nameBn: "শ্রীমঙ্গল চা বাগান", description: "Rolling hills of tea plantations with a peaceful, misty atmosphere.", districtId: 'sylhet', districtName: "Sylhet", images: ['https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/Srimangal_Tea_Garden.jpg/1280px-Srimangal_Tea_Garden.jpg'], entryFee: 0, isFreeEntry: true, visitDuration: '2-4 hours', bestTime: 'Year round', openingHours: 'Open daily', latitude: 24.3061, longitude: 91.7316, rating: 4.6, reviewCount: 1300, tags: ['tea', 'nature', 'scenic', 'photography']),
  // Bandarban
  PlaceModel(id: 'p_ban_1', name: "Nilgiri", nameBn: "নীলগিরি", description: "Highest accessible peak in Bangladesh with breathtaking cloud views.", districtId: 'bandarban', districtName: "Bandarban", images: ['https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Nilgiri_Bandarban.jpg/1280px-Nilgiri_Bandarban.jpg'], entryFee: 50, isFreeEntry: false, visitDuration: 'Half day', bestTime: 'October - April', openingHours: '6 AM - 5 PM', latitude: 21.9000, longitude: 92.2333, rating: 4.9, reviewCount: 1800, tags: ['hill', 'clouds', 'sunrise', 'scenic']),
  PlaceModel(id: 'p_ban_2', name: "Boga Lake", nameBn: "বগা লেক", description: "Mysterious crater lake nestled deep in the Bandarban hills.", districtId: 'bandarban', districtName: "Bandarban", images: ['https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/Boga_lake.jpg/1280px-Boga_lake.jpg'], entryFee: 0, isFreeEntry: true, visitDuration: 'Full day (trek)', bestTime: 'October - March', openingHours: 'Open daily', latitude: 22.0000, longitude: 92.3000, rating: 4.7, reviewCount: 900, tags: ['lake', 'trekking', 'adventure', 'nature']),
  PlaceModel(id: 'p_ban_3', name: "Chimbuk Hill", nameBn: "চিম্বুক পাহাড়", description: "Third highest peak in Bangladesh, known as the Queen of Hills.", districtId: 'bandarban', districtName: "Bandarban", images: ['https://upload.wikimedia.org/wikipedia/commons/6/6b/Bandarban_district.jpg'], entryFee: 0, isFreeEntry: true, visitDuration: 'Half day', bestTime: 'October - April', openingHours: 'Open daily', latitude: 21.9500, longitude: 92.2500, rating: 4.5, reviewCount: 760, tags: ['hill', 'nature', 'photography']),
  // Sundarbans
  PlaceModel(id: 'p_sun_1', name: "Karamjal", nameBn: "করমজল", description: "Eco-tourism center with crocodile nursery and forest trails.", districtId: 'sundarbans', districtName: "Sundarbans", images: ['https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/A_view_of_the_Sundarbans.jpg/1280px-A_view_of_the_Sundarbans.jpg'], entryFee: 200, isFreeEntry: false, visitDuration: '3-4 hours', bestTime: 'November - February', openingHours: '8 AM - 5 PM', latitude: 22.3000, longitude: 89.8000, rating: 4.5, reviewCount: 620, tags: ['mangrove', 'wildlife', 'tiger', 'boat']),
  PlaceModel(id: 'p_sun_2', name: "Kotka Beach", nameBn: "কটকা বিচ", description: "Remote beach inside Sundarbans where deer roam freely.", districtId: 'sundarbans', districtName: "Sundarbans", images: ['https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/A_view_of_the_Sundarbans.jpg/1280px-A_view_of_the_Sundarbans.jpg'], entryFee: 300, isFreeEntry: false, visitDuration: 'Full day', bestTime: 'November - February', openingHours: 'Guided tours only', latitude: 21.8833, longitude: 89.6500, rating: 4.8, reviewCount: 430, tags: ['beach', 'wildlife', 'remote', 'deer']),
  // Dhaka
  PlaceModel(id: 'p_dha_1', name: "Ahsan Manzil", nameBn: "আহসান মঞ্জিল", description: "The Pink Palace — former residence of the Nawabs of Dhaka, now a museum.", districtId: 'dhaka', districtName: "Dhaka", images: ['https://upload.wikimedia.org/wikipedia/commons/thumb/9/95/Ahsan_Manzil.jpg/1280px-Ahsan_Manzil.jpg'], entryFee: 100, isFreeEntry: false, visitDuration: '2-3 hours', bestTime: 'Year round', openingHours: '10 AM - 5 PM (Closed Fri)', latitude: 23.7095, longitude: 90.3972, rating: 4.4, reviewCount: 2200, tags: ['museum', 'heritage', 'history', 'architecture']),
  PlaceModel(id: 'p_dha_2', name: "Lalbagh Fort", nameBn: "লালবাগ কেল্লা", description: "17th-century Mughal fort complex with a tomb, mosque and museum.", districtId: 'dhaka', districtName: "Dhaka", images: ['https://upload.wikimedia.org/wikipedia/commons/thumb/3/3d/Lalbagh_fort_by_ragib.jpg/1280px-Lalbagh_fort_by_ragib.jpg'], entryFee: 200, isFreeEntry: false, visitDuration: '2-3 hours', bestTime: 'Year round', openingHours: '9 AM - 5 PM', latitude: 23.7197, longitude: 90.3888, rating: 4.3, reviewCount: 1800, tags: ['fort', 'mughal', 'heritage', 'history']),
  PlaceModel(id: 'p_dha_3', name: "National Botanical Garden", nameBn: "জাতীয় উদ্ভিদ উদ্যান", description: "208-acre garden with thousands of plant species, lakes and walking trails.", districtId: 'dhaka', districtName: "Dhaka", images: ['https://upload.wikimedia.org/wikipedia/commons/9/95/Ahsan_Manzil.jpg'], entryFee: 30, isFreeEntry: false, visitDuration: '2-4 hours', bestTime: 'October - March', openingHours: '8 AM - 6 PM', latitude: 23.7761, longitude: 90.3526, rating: 4.2, reviewCount: 950, tags: ['garden', 'nature', 'family', 'walking']),
  // Chittagong
  PlaceModel(id: 'p_chi_1', name: "Patenga Beach", nameBn: "পতেঙ্গা সমুদ্র সৈকত", description: "Popular sea beach near Chittagong port with fishing boats and sunsets.", districtId: 'chittagong', districtName: "Chittagong", images: ['https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Patenga_Sea_Beach.jpg/1280px-Patenga_Sea_Beach.jpg'], entryFee: 0, isFreeEntry: true, visitDuration: '2-3 hours', bestTime: 'October - March', openingHours: 'Open daily', latitude: 22.2456, longitude: 91.7861, rating: 4.2, reviewCount: 1100, tags: ['beach', 'sunset', 'fishing', 'local']),
  PlaceModel(id: 'p_chi_2', name: "Foy's Lake", nameBn: "ফয়'স লেক", description: "An artificial lake surrounded by hills with an amusement park.", districtId: 'chittagong', districtName: "Chittagong", images: ['https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Patenga_Sea_Beach.jpg/1280px-Patenga_Sea_Beach.jpg'], entryFee: 150, isFreeEntry: false, visitDuration: '3-5 hours', bestTime: 'Year round', openingHours: '9 AM - 7 PM', latitude: 22.3494, longitude: 91.8053, rating: 4.0, reviewCount: 870, tags: ['lake', 'amusement', 'family', 'hills']),
  // Rangamati
  PlaceModel(id: 'p_ran_1', name: "Kaptai Lake", nameBn: "কাপ্তাই লেক", description: "The largest man-made lake in Bangladesh, ringed by hills and tribal villages.", districtId: 'rangamati', districtName: "Rangamati", images: ['https://upload.wikimedia.org/wikipedia/commons/thumb/b/bf/Kaptai_Lake.jpg/1280px-Kaptai_Lake.jpg'], entryFee: 0, isFreeEntry: true, visitDuration: 'Half day', bestTime: 'October - March', openingHours: 'Open daily', latitude: 22.5000, longitude: 92.2167, rating: 4.7, reviewCount: 1200, tags: ['lake', 'boat', 'scenic', 'hills']),
  PlaceModel(id: 'p_ran_2', name: "Shuvolong Waterfall", nameBn: "শুভলং ঝর্ণা", description: "A cascading waterfall accessible only by boat on Kaptai Lake.", districtId: 'rangamati', districtName: "Rangamati", images: ['https://upload.wikimedia.org/wikipedia/commons/thumb/b/bf/Kaptai_Lake.jpg/1280px-Kaptai_Lake.jpg'], entryFee: 50, isFreeEntry: false, visitDuration: '2-3 hours', bestTime: 'June - November', openingHours: 'Open daily', latitude: 22.6000, longitude: 92.1500, rating: 4.5, reviewCount: 680, tags: ['waterfall', 'boat', 'nature', 'scenic']),
  // Rajshahi
  PlaceModel(id: 'p_raj_1', name: "Varendra Research Museum", nameBn: "বরেন্দ্র গবেষণা জাদুঘর", description: "Oldest museum in Bangladesh with rare archaeological artifacts.", districtId: 'rajshahi', districtName: "Rajshahi", images: ['https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Varendra_Research_Museum.jpg/1280px-Varendra_Research_Museum.jpg'], entryFee: 50, isFreeEntry: false, visitDuration: '1-2 hours', bestTime: 'Year round', openingHours: '10 AM - 5 PM (Closed Mon)', latitude: 24.3745, longitude: 88.6042, rating: 4.3, reviewCount: 540, tags: ['museum', 'archaeology', 'heritage', 'history']),
  PlaceModel(id: 'p_raj_2', name: "Puthia Temple Complex", nameBn: "পুঠিয়া রাজবাড়ি", description: "Remarkable cluster of 19th-century Hindu temples, largest in Bangladesh.", districtId: 'rajshahi', districtName: "Rajshahi", images: ['https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Varendra_Research_Museum.jpg/1280px-Varendra_Research_Museum.jpg'], entryFee: 30, isFreeEntry: false, visitDuration: '2-3 hours', bestTime: 'October - March', openingHours: '8 AM - 5 PM', latitude: 24.3500, longitude: 88.8333, rating: 4.5, reviewCount: 720, tags: ['temple', 'heritage', 'architecture', 'history']),
];
