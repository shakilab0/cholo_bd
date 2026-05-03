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
  // Dhaka Division
  const DistrictModel(id: 'dhaka', name: 'Dhaka', nameBn: 'ঢাকা', description: 'The vibrant capital city known for its rich history and Mughal architecture.', coverImageUrl: '', placeCount: 42, latitude: 23.8103, longitude: 90.4125),
  const DistrictModel(id: 'gazipur', name: 'Gazipur', nameBn: 'গাজীপুর', description: 'Industrial hub and home to the Bhawal National Park.', coverImageUrl: '', placeCount: 12, latitude: 24.0023, longitude: 90.4264),
  const DistrictModel(id: 'faridpur', name: 'Faridpur', nameBn: 'ফরিদপুর', description: 'Historic district known for jute production and Sufi shrines.', coverImageUrl: '', placeCount: 8, latitude: 23.6071, longitude: 89.8429),
  const DistrictModel(id: 'gopalganj', name: 'Gopalganj', nameBn: 'গোপালগঞ্জ', description: 'The birthplace of the Father of the Nation, Bangabandhu Sheikh Mujibur Rahman.', coverImageUrl: '', placeCount: 15, latitude: 23.005, longitude: 89.8267),
  const DistrictModel(id: 'kishoreganj', name: 'Kishoreganj', nameBn: 'কিশোরগঞ্জ', description: 'Famous for the massive Eidgah Maidan and haor wetlands.', coverImageUrl: '', placeCount: 11, latitude: 24.4331, longitude: 90.7866),
  const DistrictModel(id: 'madaripur', name: 'Madaripur', nameBn: 'মাদারীপুর', description: 'Located on the banks of the Padma, known for its date juice.', coverImageUrl: '', placeCount: 6, latitude: 23.1641, longitude: 90.1896),
  const DistrictModel(id: 'manikganj', name: 'Manikganj', nameBn: 'মানিকগঞ্জ', description: 'Known for the historic Baliati Palace and mustard fields.', coverImageUrl: '', placeCount: 9, latitude: 23.8644, longitude: 90.0047),
  const DistrictModel(id: 'munshiganj', name: 'Munshiganj', nameBn: 'মুন্সীগঞ্জ', description: 'Ancient Bikrampur, rich in archaeological heritage sites.', coverImageUrl: '', placeCount: 14, latitude: 23.5422, longitude: 90.5305),
  const DistrictModel(id: 'narayanganj', name: 'Narayanganj', nameBn: 'নারায়ণগঞ্জ', description: 'The "Dundee of the East," famous for ancient Sonargaon.', coverImageUrl: '', placeCount: 18, latitude: 23.6238, longitude: 90.5),
  const DistrictModel(id: 'narsingdi', name: 'Narsingdi', nameBn: 'নরসিংদী', description: 'Center of the textile industry and ancient Wari-Bateshwar.', coverImageUrl: '', placeCount: 7, latitude: 23.9197, longitude: 90.7177),
  const DistrictModel(id: 'rajbari', name: 'Rajbari', nameBn: 'রাজবাড়ী', description: 'Named after the historic palaces of local Kings.', coverImageUrl: '', placeCount: 5, latitude: 23.7574, longitude: 89.6444),
  const DistrictModel(id: 'shariatpur', name: 'Shariatpur', nameBn: 'শরীয়তপুর', description: 'A riverine district known for its resilient communities.', coverImageUrl: '', placeCount: 4, latitude: 23.2423, longitude: 90.3446),
  const DistrictModel(id: 'tangail', name: 'Tangail', nameBn: 'টাঙ্গাইল', description: 'World-famous for the hand-woven Tangail Saree.', coverImageUrl: '', placeCount: 13, latitude: 24.2471, longitude: 89.9214),
  // Chittagong Division
  const DistrictModel(id: 'chittagong', name: 'Chittagong', nameBn: 'চট্টগ্রাম', description: 'The commercial capital and home to the largest seaport and hilly terrains.', coverImageUrl: '', placeCount: 35, latitude: 22.3569, longitude: 91.7832),
  const DistrictModel(id: 'coxs-bazar', name: "Cox's Bazar", nameBn: 'কক্সবাজার', description: "World's longest natural sea beach and top tourist destination.", coverImageUrl: '', placeCount: 14, latitude: 21.4272, longitude: 92.0058),
  const DistrictModel(id: 'brahmanbaria', name: 'Brahmanbaria', nameBn: 'ব্রাহ্মণবাড়িয়া', description: 'The cultural capital of the region, famous for music and sweets.', coverImageUrl: '', placeCount: 9, latitude: 23.9571, longitude: 91.1119),
  const DistrictModel(id: 'chandpur', name: 'Chandpur', nameBn: 'চাঁদপুর', description: 'The "Hilsa City" located at the confluence of the Padma and Meghna.', coverImageUrl: '', placeCount: 7, latitude: 23.2321, longitude: 90.6631),
  const DistrictModel(id: 'cumilla', name: 'Cumilla', nameBn: 'কুমিল্লা', description: 'Famous for the Shalban Vihara and Rasmalai.', coverImageUrl: '', placeCount: 21, latitude: 23.4607, longitude: 91.1809),
  const DistrictModel(id: 'feni', name: 'Feni', nameBn: 'ফেনী', description: 'A strategic gateway connecting Dhaka and Chattogram.', coverImageUrl: '', placeCount: 6, latitude: 23.0159, longitude: 91.3976),
  const DistrictModel(id: 'khagrachari', name: 'Khagrachari', nameBn: 'খাগড়াছড়ি', description: 'A gateway to the hill tracts with mysterious caves and hills.', coverImageUrl: '', placeCount: 14, latitude: 23.1193, longitude: 91.9847),
  const DistrictModel(id: 'lakshmipur', name: 'Lakshmipur', nameBn: 'লক্ষ্মীপুর', description: 'A coastal district known for its soya beans and coconut.', coverImageUrl: '', placeCount: 5, latitude: 22.9425, longitude: 90.8412),
  const DistrictModel(id: 'noakhali', name: 'Noakhali', nameBn: 'নোয়াখালী', description: 'Historically significant for the Gandhi Ashram and coastlines.', coverImageUrl: '', placeCount: 8, latitude: 22.8696, longitude: 91.0995),
  const DistrictModel(id: 'rangamati', name: 'Rangamati', nameBn: 'রাঙ্গামাটি', description: 'Known for the beautiful Kaptai Lake and the unique culture of ethnic groups.', coverImageUrl: '', placeCount: 18, latitude: 22.6574, longitude: 92.1767),
  const DistrictModel(id: 'bandarban', name: 'Bandarban', nameBn: 'বান্দরবান', description: 'Home to the highest peaks in Bangladesh and breathtaking waterfalls.', coverImageUrl: '', placeCount: 22, latitude: 22.1953, longitude: 92.2184),
  // Khulna Division
  const DistrictModel(id: 'khulna', name: 'Khulna', nameBn: 'খুলনা', description: 'The gateway to the Sundarbans, the world\'s largest mangrove forest.', coverImageUrl: '', placeCount: 15, latitude: 22.8456, longitude: 89.5403),
  const DistrictModel(id: 'bagerhat', name: 'Bagerhat', nameBn: 'বাগেরহাট', description: 'Home to the UNESCO site Sixty Dome Mosque (Shat Gombuj).', coverImageUrl: '', placeCount: 16, latitude: 22.6516, longitude: 89.7859),
  const DistrictModel(id: 'chuadanga', name: 'Chuadanga', nameBn: 'চুয়াডাঙ্গা', description: 'First capital of Bangladesh during the 1971 liberation war.', coverImageUrl: '', placeCount: 5, latitude: 23.6401, longitude: 88.8418),
  const DistrictModel(id: 'jashore', name: 'Jashore', nameBn: 'যশোর', description: 'Famous for date palm jaggery and the flower capital Gadkhali.', coverImageUrl: '', placeCount: 12, latitude: 23.1664, longitude: 89.2081),
  const DistrictModel(id: 'jhenaidah', name: 'Jhenaidah', nameBn: 'ঝিনাইদহ', description: 'Known for ancient mosques and the poet Lalon Shah.', coverImageUrl: '', placeCount: 7, latitude: 23.545, longitude: 89.1726),
  const DistrictModel(id: 'kushtia', name: 'Kushtia', nameBn: 'কুষ্টিয়া', description: 'The cultural hub of Baul music and Lalon Shah\'s shrine.', coverImageUrl: '', placeCount: 14, latitude: 23.9013, longitude: 89.1204),
  const DistrictModel(id: 'magura', name: 'Magura', nameBn: 'মাগুরা', description: 'Known for its ancient monuments and sports heritage.', coverImageUrl: '', placeCount: 4, latitude: 23.4873, longitude: 89.4136),
  const DistrictModel(id: 'meherpur', name: 'Meherpur', nameBn: 'মেহেরপুর', description: 'Home to Mujibnagar, where the first government was sworn in.', coverImageUrl: '', placeCount: 10, latitude: 23.7622, longitude: 88.6318),
  const DistrictModel(id: 'narail', name: 'Narail', nameBn: 'নড়াইল', description: 'Known as the "District of Artists" and beautiful rivers.', coverImageUrl: '', placeCount: 6, latitude: 23.1725, longitude: 89.5122),
  const DistrictModel(id: 'satkhira', name: 'Satkhira', nameBn: 'সাতক্ষীরা', description: 'Borders the Sundarbans and is famous for honey and shrimp.', coverImageUrl: '', placeCount: 11, latitude: 22.7185, longitude: 89.0705),
  // Rajshahi Division
  const DistrictModel(id: 'rajshahi', name: 'Rajshahi', nameBn: 'রাজশাহী', description: 'Often called the Silk City, famous for its mangoes and the Padma River.', coverImageUrl: '', placeCount: 12, latitude: 24.3745, longitude: 88.6042),
  const DistrictModel(id: 'bogra', name: 'Bogra', nameBn: 'বগুড়া', description: 'The ancient capital of Pundravardhana (Mahasthangarh).', coverImageUrl: '', placeCount: 19, latitude: 24.8481, longitude: 89.373),
  const DistrictModel(id: 'joypurhat', name: 'Joypurhat', nameBn: 'জয়পুরহাট', description: 'Known for sugar production and ancient temples.', coverImageUrl: '', placeCount: 5, latitude: 25.0947, longitude: 89.0209),
  const DistrictModel(id: 'naogaon', name: 'Naogaon', nameBn: 'নওগাঁ', description: 'Home to the Paharpur Buddhist Vihara and Paharpur.', coverImageUrl: '', placeCount: 15, latitude: 24.7936, longitude: 88.9318),
  const DistrictModel(id: 'natore', name: 'Natore', nameBn: 'নাটোর', description: 'Famous for the Uttara Gonobhaban and Kanchagolla sweet.', coverImageUrl: '', placeCount: 9, latitude: 24.4102, longitude: 88.982),
  const DistrictModel(id: 'chapainawabganj', name: 'Chapainawabganj', nameBn: 'চাঁপাইনবাবগঞ্জ', description: 'The Mango Capital of Bangladesh.', coverImageUrl: '', placeCount: 11, latitude: 24.5965, longitude: 88.2711),
  const DistrictModel(id: 'pabna', name: 'Pabna', nameBn: 'পাবনা', description: 'Known for the Mental Hospital, Hardinge Bridge, and Hilsa.', coverImageUrl: '', placeCount: 10, latitude: 24.0158, longitude: 89.2336),
  const DistrictModel(id: 'sirajganj', name: 'Sirajganj', nameBn: 'সিরাজগঞ্জ', description: 'Known for the Jamuna Bridge and handloom industry.', coverImageUrl: '', placeCount: 8, latitude: 24.4577, longitude: 89.7084),
  // Rangpur Division
  const DistrictModel(id: 'rangpur', name: 'Rangpur', nameBn: 'রংপুর', description: 'Known for the Tajhat Palace and Shataranji weaving.', coverImageUrl: '', placeCount: 14, latitude: 25.7439, longitude: 89.2752),
  const DistrictModel(id: 'dinajpur', name: 'Dinajpur', nameBn: 'দিনাজপুর', description: 'Home to the Kantajew Temple and Ramsagar lake.', coverImageUrl: '', placeCount: 16, latitude: 25.6217, longitude: 88.6354),
  const DistrictModel(id: 'gaibandha', name: 'Gaibandha', nameBn: 'গাইবান্ধা', description: 'A riverine district known for agriculture and chars.', coverImageUrl: '', placeCount: 6, latitude: 25.3288, longitude: 89.5426),
  const DistrictModel(id: 'kurigram', name: 'Kurigram', nameBn: 'কুড়িগ্রাম', description: 'Border district with numerous rivers and scenic beauty.', coverImageUrl: '', placeCount: 7, latitude: 25.8054, longitude: 89.6361),
  const DistrictModel(id: 'lalmonirhat', name: 'Lalmonirhat', nameBn: 'লালমনিরহাট', description: 'Known for the Burimari land port and Teesta barrage.', coverImageUrl: '', placeCount: 5, latitude: 25.9165, longitude: 89.4474),
  const DistrictModel(id: 'nilphamari', name: 'Nilphamari', nameBn: 'নীলফামারী', description: 'Home to the Uttara EPZ and blue-tinted history.', coverImageUrl: '', placeCount: 8, latitude: 25.9319, longitude: 88.856),
  const DistrictModel(id: 'panchagarh', name: 'Panchagarh', nameBn: 'পঞ্চগড়', description: 'The northernmost district with views of the Himalayas.', coverImageUrl: '', placeCount: 12, latitude: 26.3411, longitude: 88.5542),
  const DistrictModel(id: 'thakurgaon', name: 'Thakurgaon', nameBn: 'ঠাকুরগাঁও', description: 'Famous for its diverse agriculture and Baliadangi Banyan tree.', coverImageUrl: '', placeCount: 6, latitude: 26.0337, longitude: 88.4617),
  // Sylhet Division
  const DistrictModel(id: 'sylhet', name: 'Sylhet', nameBn: 'সিলেট', description: 'Famous for its rolling tea gardens, lush green hills, and holy shrines.', coverImageUrl: '', placeCount: 28, latitude: 24.8949, longitude: 91.8687),
  const DistrictModel(id: 'habiganj', name: 'Habiganj', nameBn: 'হবিগঞ্জ', description: 'Rich in natural gas and beautiful tea estates.', coverImageUrl: '', placeCount: 9, latitude: 24.3749, longitude: 91.4133),
  const DistrictModel(id: 'moulvibazar', name: 'Moulvibazar', nameBn: 'মৌলভীবাজার', description: 'Home to Lawachara Forest and Madhabkunda waterfall.', coverImageUrl: '', placeCount: 18, latitude: 24.4829, longitude: 91.7705),
  const DistrictModel(id: 'sunamganj', name: 'Sunamganj', nameBn: 'সুনামগঞ্জ', description: 'The land of Haors (wetlands) and Baul legends.', coverImageUrl: '', placeCount: 12, latitude: 25.0662, longitude: 91.3992),
  // Barishal Division
  const DistrictModel(id: 'barishal', name: 'Barishal', nameBn: 'বরিশাল', description: 'The "Venice of the East," famous for its floating markets and interconnected rivers.', coverImageUrl: '', placeCount: 10, latitude: 22.701, longitude: 90.3535),
  const DistrictModel(id: 'bhola', name: 'Bhola', nameBn: 'ভোলা', description: 'The only island district of Bangladesh.', coverImageUrl: '', placeCount: 7, latitude: 22.6859, longitude: 90.644),
  const DistrictModel(id: 'jhalokati', name: 'Jhalokati', nameBn: 'ঝালকাঠি', description: 'Famous for the floating guava markets.', coverImageUrl: '', placeCount: 6, latitude: 22.6406, longitude: 90.1989),
  const DistrictModel(id: 'patuakhali', name: 'Patuakhali', nameBn: 'পটুয়াখালী', description: 'Known for Kuakata, the daughter of the sea.', coverImageUrl: '', placeCount: 11, latitude: 22.3596, longitude: 90.3297),
  const DistrictModel(id: 'pirojpur', name: 'Pirojpur', nameBn: 'পিরোজপুর', description: 'A riverine district known for its coconut and betel nut.', coverImageUrl: '', placeCount: 5, latitude: 22.5815, longitude: 89.9751),
  const DistrictModel(id: 'barguna', name: 'Barguna', nameBn: 'বরগুনা', description: 'Coastal beauty with proximity to the Sundarbans.', coverImageUrl: '', placeCount: 6, latitude: 22.1558, longitude: 90.1265),
  // Mymensingh Division
  const DistrictModel(id: 'mymensingh', name: 'Mymensingh', nameBn: 'ময়মনসিংহ', description: 'Known for the Brahmaputra river and educational heritage.', coverImageUrl: '', placeCount: 18, latitude: 24.7471, longitude: 90.4203),
  const DistrictModel(id: 'jamalpur', name: 'Jamalpur', nameBn: 'জামালপুর', description: 'Famous for Nakshi Kantha and handicraft products.', coverImageUrl: '', placeCount: 7, latitude: 24.9197, longitude: 89.9454),
  const DistrictModel(id: 'netrokona', name: 'Netrokona', nameBn: 'নেত্রকোণা', description: 'Known for Birishiri and the scenic Garo hills.', coverImageUrl: '', placeCount: 10, latitude: 24.8707, longitude: 90.7273),
  const DistrictModel(id: 'sherpur', name: 'Sherpur', nameBn: 'শেরপুর', description: 'Home to the Madhutila Eco Park and hilly borders.', coverImageUrl: '', placeCount: 6, latitude: 25.0189, longitude: 90.0175),
];
