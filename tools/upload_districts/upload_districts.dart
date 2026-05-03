import 'package:dart_appwrite/dart_appwrite.dart';

// ── CONFIG ────────────────────────────────────────────────────────────────────
const _endpoint = 'https://sgp.cloud.appwrite.io/v1';
const _projectId = '69ec2d6c00274656ee64';
const _databaseId = '69ec314b0038beeb4258';
const _collectionId = 'districts';

// Paste your Appwrite API key here (needs databases.write permission)
const _apiKey =
    'standard_95427bc5f0c9b8d7fb86df043d63a037b990d0736c1c8d08d27376bda4e30ec584ee823670b550aeba8326700744ec6eb0de26c0e971ddf0efd89d3787c263442f2b9d88f08baeb75d750862ef0b0cccb01b323bb9204f4236cfdfec8cdeb10709cfe961447ef637c22ad3ccf3091a2e7b64c723e9652c850b7e787a5adbcfea';
// ─────────────────────────────────────────────────────────────────────────────

final _districts = [
  // Dhaka Division
  {
    'id': 'dhaka',
    'name': 'Dhaka',
    'name_bn': 'ঢাকা',
    'description':
        'The vibrant capital city known for its rich history and Mughal architecture.',
    'place_count': 42,
    'latitude': 23.8103,
    'longitude': 90.4125,
    'cover_image_url': ''
  },
  {
    'id': 'gazipur',
    'name': 'Gazipur',
    'name_bn': 'গাজীপুর',
    'description': 'Industrial hub and home to the Bhawal National Park.',
    'place_count': 12,
    'latitude': 24.0023,
    'longitude': 90.4264,
    'cover_image_url': ''
  },
  {
    'id': 'faridpur',
    'name': 'Faridpur',
    'name_bn': 'ফরিদপুর',
    'description':
        'Historic district known for jute production and Sufi shrines.',
    'place_count': 8,
    'latitude': 23.6071,
    'longitude': 89.8429,
    'cover_image_url': ''
  },
  {
    'id': 'gopalganj',
    'name': 'Gopalganj',
    'name_bn': 'গোপালগঞ্জ',
    'description':
        'The birthplace of the Father of the Nation, Bangabandhu Sheikh Mujibur Rahman.',
    'place_count': 15,
    'latitude': 23.005,
    'longitude': 89.8267,
    'cover_image_url': ''
  },
  {
    'id': 'kishoreganj',
    'name': 'Kishoreganj',
    'name_bn': 'কিশোরগঞ্জ',
    'description': 'Famous for the massive Eidgah Maidan and haor wetlands.',
    'place_count': 11,
    'latitude': 24.4331,
    'longitude': 90.7866,
    'cover_image_url': ''
  },
  {
    'id': 'madaripur',
    'name': 'Madaripur',
    'name_bn': 'মাদারীপুর',
    'description':
        'Located on the banks of the Padma, known for its date juice.',
    'place_count': 6,
    'latitude': 23.1641,
    'longitude': 90.1896,
    'cover_image_url': ''
  },
  {
    'id': 'manikganj',
    'name': 'Manikganj',
    'name_bn': 'মানিকগঞ্জ',
    'description': 'Known for the historic Baliati Palace and mustard fields.',
    'place_count': 9,
    'latitude': 23.8644,
    'longitude': 90.0047,
    'cover_image_url': ''
  },
  {
    'id': 'munshiganj',
    'name': 'Munshiganj',
    'name_bn': 'মুন্সীগঞ্জ',
    'description': 'Ancient Bikrampur, rich in archaeological heritage sites.',
    'place_count': 14,
    'latitude': 23.5422,
    'longitude': 90.5305,
    'cover_image_url': ''
  },
  {
    'id': 'narayanganj',
    'name': 'Narayanganj',
    'name_bn': 'নারায়ণগঞ্জ',
    'description': 'The "Dundee of the East," famous for ancient Sonargaon.',
    'place_count': 18,
    'latitude': 23.6238,
    'longitude': 90.5,
    'cover_image_url': ''
  },
  {
    'id': 'narsingdi',
    'name': 'Narsingdi',
    'name_bn': 'নরসিংদী',
    'description': 'Center of the textile industry and ancient Wari-Bateshwar.',
    'place_count': 7,
    'latitude': 23.9197,
    'longitude': 90.7177,
    'cover_image_url': ''
  },
  {
    'id': 'rajbari',
    'name': 'Rajbari',
    'name_bn': 'রাজবাড়ী',
    'description': 'Named after the historic palaces of local Kings.',
    'place_count': 5,
    'latitude': 23.7574,
    'longitude': 89.6444,
    'cover_image_url': ''
  },
  {
    'id': 'shariatpur',
    'name': 'Shariatpur',
    'name_bn': 'শরীয়তপুর',
    'description': 'A riverine district known for its resilient communities.',
    'place_count': 4,
    'latitude': 23.2423,
    'longitude': 90.3446,
    'cover_image_url': ''
  },
  {
    'id': 'tangail',
    'name': 'Tangail',
    'name_bn': 'টাঙ্গাইল',
    'description': 'World-famous for the hand-woven Tangail Saree.',
    'place_count': 13,
    'latitude': 24.2471,
    'longitude': 89.9214,
    'cover_image_url': ''
  },
  // Chittagong Division
  {
    'id': 'chittagong',
    'name': 'Chittagong',
    'name_bn': 'চট্টগ্রাম',
    'description':
        'The commercial capital and home to the largest seaport and hilly terrains.',
    'place_count': 35,
    'latitude': 22.3569,
    'longitude': 91.7832,
    'cover_image_url': ''
  },
  {
    'id': 'coxs-bazar',
    'name': "Cox's Bazar",
    'name_bn': 'কক্সবাজার',
    'description':
        "World's longest natural sea beach and top tourist destination.",
    'place_count': 14,
    'latitude': 21.4272,
    'longitude': 92.0058,
    'cover_image_url': ''
  },
  {
    'id': 'brahmanbaria',
    'name': 'Brahmanbaria',
    'name_bn': 'ব্রাহ্মণবাড়িয়া',
    'description':
        'The cultural capital of the region, famous for music and sweets.',
    'place_count': 9,
    'latitude': 23.9571,
    'longitude': 91.1119,
    'cover_image_url': ''
  },
  {
    'id': 'chandpur',
    'name': 'Chandpur',
    'name_bn': 'চাঁদপুর',
    'description':
        'The "Hilsa City" located at the confluence of the Padma and Meghna.',
    'place_count': 7,
    'latitude': 23.2321,
    'longitude': 90.6631,
    'cover_image_url': ''
  },
  {
    'id': 'cumilla',
    'name': 'Cumilla',
    'name_bn': 'কুমিল্লা',
    'description': 'Famous for the Shalban Vihara and Rasmalai.',
    'place_count': 21,
    'latitude': 23.4607,
    'longitude': 91.1809,
    'cover_image_url': ''
  },
  {
    'id': 'feni',
    'name': 'Feni',
    'name_bn': 'ফেনী',
    'description': 'A strategic gateway connecting Dhaka and Chattogram.',
    'place_count': 6,
    'latitude': 23.0159,
    'longitude': 91.3976,
    'cover_image_url': ''
  },
  {
    'id': 'khagrachari',
    'name': 'Khagrachari',
    'name_bn': 'খাগড়াছড়ি',
    'description':
        'A gateway to the hill tracts with mysterious caves and hills.',
    'place_count': 14,
    'latitude': 23.1193,
    'longitude': 91.9847,
    'cover_image_url': ''
  },
  {
    'id': 'lakshmipur',
    'name': 'Lakshmipur',
    'name_bn': 'লক্ষ্মীপুর',
    'description': 'A coastal district known for its soya beans and coconut.',
    'place_count': 5,
    'latitude': 22.9425,
    'longitude': 90.8412,
    'cover_image_url': ''
  },
  {
    'id': 'noakhali',
    'name': 'Noakhali',
    'name_bn': 'নোয়াখালী',
    'description':
        'Historically significant for the Gandhi Ashram and coastlines.',
    'place_count': 8,
    'latitude': 22.8696,
    'longitude': 91.0995,
    'cover_image_url': ''
  },
  {
    'id': 'rangamati',
    'name': 'Rangamati',
    'name_bn': 'রাঙ্গামাটি',
    'description':
        'Known for the beautiful Kaptai Lake and the unique culture of ethnic groups.',
    'place_count': 18,
    'latitude': 22.6574,
    'longitude': 92.1767,
    'cover_image_url': ''
  },
  {
    'id': 'bandarban',
    'name': 'Bandarban',
    'name_bn': 'বান্দরবান',
    'description':
        'Home to the highest peaks in Bangladesh and breathtaking waterfalls.',
    'place_count': 22,
    'latitude': 22.1953,
    'longitude': 92.2184,
    'cover_image_url': ''
  },
  // Khulna Division
  {
    'id': 'khulna',
    'name': 'Khulna',
    'name_bn': 'খুলনা',
    'description':
        "The gateway to the Sundarbans, the world's largest mangrove forest.",
    'place_count': 15,
    'latitude': 22.8456,
    'longitude': 89.5403,
    'cover_image_url': ''
  },
  {
    'id': 'bagerhat',
    'name': 'Bagerhat',
    'name_bn': 'বাগেরহাট',
    'description': 'Home to the UNESCO site Sixty Dome Mosque (Shat Gombuj).',
    'place_count': 16,
    'latitude': 22.6516,
    'longitude': 89.7859,
    'cover_image_url': ''
  },
  {
    'id': 'chuadanga',
    'name': 'Chuadanga',
    'name_bn': 'চুয়াডাঙ্গা',
    'description':
        'First capital of Bangladesh during the 1971 liberation war.',
    'place_count': 5,
    'latitude': 23.6401,
    'longitude': 88.8418,
    'cover_image_url': ''
  },
  {
    'id': 'jashore',
    'name': 'Jashore',
    'name_bn': 'যশোর',
    'description':
        'Famous for date palm jaggery and the flower capital Gadkhali.',
    'place_count': 12,
    'latitude': 23.1664,
    'longitude': 89.2081,
    'cover_image_url': ''
  },
  {
    'id': 'jhenaidah',
    'name': 'Jhenaidah',
    'name_bn': 'ঝিনাইদহ',
    'description': 'Known for ancient mosques and the poet Lalon Shah.',
    'place_count': 7,
    'latitude': 23.545,
    'longitude': 89.1726,
    'cover_image_url': ''
  },
  {
    'id': 'kushtia',
    'name': 'Kushtia',
    'name_bn': 'কুষ্টিয়া',
    'description': "The cultural hub of Baul music and Lalon Shah's shrine.",
    'place_count': 14,
    'latitude': 23.9013,
    'longitude': 89.1204,
    'cover_image_url': ''
  },
  {
    'id': 'magura',
    'name': 'Magura',
    'name_bn': 'মাগুরা',
    'description': 'Known for its ancient monuments and sports heritage.',
    'place_count': 4,
    'latitude': 23.4873,
    'longitude': 89.4136,
    'cover_image_url': ''
  },
  {
    'id': 'meherpur',
    'name': 'Meherpur',
    'name_bn': 'মেহেরপুর',
    'description':
        'Home to Mujibnagar, where the first government was sworn in.',
    'place_count': 10,
    'latitude': 23.7622,
    'longitude': 88.6318,
    'cover_image_url': ''
  },
  {
    'id': 'narail',
    'name': 'Narail',
    'name_bn': 'নড়াইল',
    'description': 'Known as the "District of Artists" and beautiful rivers.',
    'place_count': 6,
    'latitude': 23.1725,
    'longitude': 89.5122,
    'cover_image_url': ''
  },
  {
    'id': 'satkhira',
    'name': 'Satkhira',
    'name_bn': 'সাতক্ষীরা',
    'description': 'Borders the Sundarbans and is famous for honey and shrimp.',
    'place_count': 11,
    'latitude': 22.7185,
    'longitude': 89.0705,
    'cover_image_url': ''
  },
  // Rajshahi Division
  {
    'id': 'rajshahi',
    'name': 'Rajshahi',
    'name_bn': 'রাজশাহী',
    'description':
        'Often called the Silk City, famous for its mangoes and the Padma River.',
    'place_count': 12,
    'latitude': 24.3745,
    'longitude': 88.6042,
    'cover_image_url': ''
  },
  {
    'id': 'bogra',
    'name': 'Bogra',
    'name_bn': 'বগুড়া',
    'description': 'The ancient capital of Pundravardhana (Mahasthangarh).',
    'place_count': 19,
    'latitude': 24.8481,
    'longitude': 89.373,
    'cover_image_url': ''
  },
  {
    'id': 'joypurhat',
    'name': 'Joypurhat',
    'name_bn': 'জয়পুরহাট',
    'description': 'Known for sugar production and ancient temples.',
    'place_count': 5,
    'latitude': 25.0947,
    'longitude': 89.0209,
    'cover_image_url': ''
  },
  {
    'id': 'naogaon',
    'name': 'Naogaon',
    'name_bn': 'নওগাঁ',
    'description': 'Home to the Paharpur Buddhist Vihara and Paharpur.',
    'place_count': 15,
    'latitude': 24.7936,
    'longitude': 88.9318,
    'cover_image_url': ''
  },
  {
    'id': 'natore',
    'name': 'Natore',
    'name_bn': 'নাটোর',
    'description': 'Famous for the Uttara Gonobhaban and Kanchagolla sweet.',
    'place_count': 9,
    'latitude': 24.4102,
    'longitude': 88.982,
    'cover_image_url': ''
  },
  {
    'id': 'chapainawabganj',
    'name': 'Chapainawabganj',
    'name_bn': 'চাঁপাইনবাবগঞ্জ',
    'description': 'The Mango Capital of Bangladesh.',
    'place_count': 11,
    'latitude': 24.5965,
    'longitude': 88.2711,
    'cover_image_url': ''
  },
  {
    'id': 'pabna',
    'name': 'Pabna',
    'name_bn': 'পাবনা',
    'description': 'Known for the Mental Hospital, Hardinge Bridge, and Hilsa.',
    'place_count': 10,
    'latitude': 24.0158,
    'longitude': 89.2336,
    'cover_image_url': ''
  },
  {
    'id': 'sirajganj',
    'name': 'Sirajganj',
    'name_bn': 'সিরাজগঞ্জ',
    'description': 'Known for the Jamuna Bridge and handloom industry.',
    'place_count': 8,
    'latitude': 24.4577,
    'longitude': 89.7084,
    'cover_image_url': ''
  },
  // Rangpur Division
  {
    'id': 'rangpur',
    'name': 'Rangpur',
    'name_bn': 'রংপুর',
    'description': 'Known for the Tajhat Palace and Shataranji weaving.',
    'place_count': 14,
    'latitude': 25.7439,
    'longitude': 89.2752,
    'cover_image_url': ''
  },
  {
    'id': 'dinajpur',
    'name': 'Dinajpur',
    'name_bn': 'দিনাজপুর',
    'description': 'Home to the Kantajew Temple and Ramsagar lake.',
    'place_count': 16,
    'latitude': 25.6217,
    'longitude': 88.6354,
    'cover_image_url': ''
  },
  {
    'id': 'gaibandha',
    'name': 'Gaibandha',
    'name_bn': 'গাইবান্ধা',
    'description': 'A riverine district known for agriculture and chars.',
    'place_count': 6,
    'latitude': 25.3288,
    'longitude': 89.5426,
    'cover_image_url': ''
  },
  {
    'id': 'kurigram',
    'name': 'Kurigram',
    'name_bn': 'কুড়িগ্রাম',
    'description': 'Border district with numerous rivers and scenic beauty.',
    'place_count': 7,
    'latitude': 25.8054,
    'longitude': 89.6361,
    'cover_image_url': ''
  },
  {
    'id': 'lalmonirhat',
    'name': 'Lalmonirhat',
    'name_bn': 'লালমনিরহাট',
    'description': 'Known for the Burimari land port and Teesta barrage.',
    'place_count': 5,
    'latitude': 25.9165,
    'longitude': 89.4474,
    'cover_image_url': ''
  },
  {
    'id': 'nilphamari',
    'name': 'Nilphamari',
    'name_bn': 'নীলফামারী',
    'description': 'Home to the Uttara EPZ and blue-tinted history.',
    'place_count': 8,
    'latitude': 25.9319,
    'longitude': 88.856,
    'cover_image_url': ''
  },
  {
    'id': 'panchagarh',
    'name': 'Panchagarh',
    'name_bn': 'পঞ্চগড়',
    'description': 'The northernmost district with views of the Himalayas.',
    'place_count': 12,
    'latitude': 26.3411,
    'longitude': 88.5542,
    'cover_image_url': ''
  },
  {
    'id': 'thakurgaon',
    'name': 'Thakurgaon',
    'name_bn': 'ঠাকুরগাঁও',
    'description':
        'Famous for its diverse agriculture and Baliadangi Banyan tree.',
    'place_count': 6,
    'latitude': 26.0337,
    'longitude': 88.4617,
    'cover_image_url': ''
  },
  // Sylhet Division
  {
    'id': 'sylhet',
    'name': 'Sylhet',
    'name_bn': 'সিলেট',
    'description':
        'Famous for its rolling tea gardens, lush green hills, and holy shrines.',
    'place_count': 28,
    'latitude': 24.8949,
    'longitude': 91.8687,
    'cover_image_url': ''
  },
  {
    'id': 'habiganj',
    'name': 'Habiganj',
    'name_bn': 'হবিগঞ্জ',
    'description': 'Rich in natural gas and beautiful tea estates.',
    'place_count': 9,
    'latitude': 24.3749,
    'longitude': 91.4133,
    'cover_image_url': ''
  },
  {
    'id': 'moulvibazar',
    'name': 'Moulvibazar',
    'name_bn': 'মৌলভীবাজার',
    'description': 'Home to Lawachara Forest and Madhabkunda waterfall.',
    'place_count': 18,
    'latitude': 24.4829,
    'longitude': 91.7705,
    'cover_image_url': ''
  },
  {
    'id': 'sunamganj',
    'name': 'Sunamganj',
    'name_bn': 'সুনামগঞ্জ',
    'description': 'The land of Haors (wetlands) and Baul legends.',
    'place_count': 12,
    'latitude': 25.0662,
    'longitude': 91.3992,
    'cover_image_url': ''
  },
  // Barishal Division
  {
    'id': 'barishal',
    'name': 'Barishal',
    'name_bn': 'বরিশাল',
    'description':
        'The "Venice of the East," famous for its floating markets and interconnected rivers.',
    'place_count': 10,
    'latitude': 22.701,
    'longitude': 90.3535,
    'cover_image_url': ''
  },
  {
    'id': 'bhola',
    'name': 'Bhola',
    'name_bn': 'ভোলা',
    'description': 'The only island district of Bangladesh.',
    'place_count': 7,
    'latitude': 22.6859,
    'longitude': 90.644,
    'cover_image_url': ''
  },
  {
    'id': 'jhalokati',
    'name': 'Jhalokati',
    'name_bn': 'ঝালকাঠি',
    'description': 'Famous for the floating guava markets.',
    'place_count': 6,
    'latitude': 22.6406,
    'longitude': 90.1989,
    'cover_image_url': ''
  },
  {
    'id': 'patuakhali',
    'name': 'Patuakhali',
    'name_bn': 'পটুয়াখালী',
    'description': 'Known for Kuakata, the daughter of the sea.',
    'place_count': 11,
    'latitude': 22.3596,
    'longitude': 90.3297,
    'cover_image_url': ''
  },
  {
    'id': 'pirojpur',
    'name': 'Pirojpur',
    'name_bn': 'পিরোজপুর',
    'description': 'A riverine district known for its coconut and betel nut.',
    'place_count': 5,
    'latitude': 22.5815,
    'longitude': 89.9751,
    'cover_image_url': ''
  },
  {
    'id': 'barguna',
    'name': 'Barguna',
    'name_bn': 'বরগুনা',
    'description': 'Coastal beauty with proximity to the Sundarbans.',
    'place_count': 6,
    'latitude': 22.1558,
    'longitude': 90.1265,
    'cover_image_url': ''
  },
  // Mymensingh Division
  {
    'id': 'mymensingh',
    'name': 'Mymensingh',
    'name_bn': 'ময়মনসিংহ',
    'description': 'Known for the Brahmaputra river and educational heritage.',
    'place_count': 18,
    'latitude': 24.7471,
    'longitude': 90.4203,
    'cover_image_url': ''
  },
  {
    'id': 'jamalpur',
    'name': 'Jamalpur',
    'name_bn': 'জামালপুর',
    'description': 'Famous for Nakshi Kantha and handicraft products.',
    'place_count': 7,
    'latitude': 24.9197,
    'longitude': 89.9454,
    'cover_image_url': ''
  },
  {
    'id': 'netrokona',
    'name': 'Netrokona',
    'name_bn': 'নেত্রকোণা',
    'description': 'Known for Birishiri and the scenic Garo hills.',
    'place_count': 10,
    'latitude': 24.8707,
    'longitude': 90.7273,
    'cover_image_url': ''
  },
  {
    'id': 'sherpur',
    'name': 'Sherpur',
    'name_bn': 'শেরপুর',
    'description': 'Home to the Madhutila Eco Park and hilly borders.',
    'place_count': 6,
    'latitude': 25.0189,
    'longitude': 90.0175,
    'cover_image_url': ''
  },
];

// ── UPLOAD COMPLETE — All 64 districts uploaded successfully ─────────────────
// Uncomment this main() to re-run the upload if needed.

// Future<void> main() async {
//   if (_apiKey == 'YOUR_API_KEY_HERE') {
//     print('❌ Please set your Appwrite API key in the _apiKey constant.');
//     return;
//   }
//
//   final client =
//       Client().setEndpoint(_endpoint).setProject(_projectId).setKey(_apiKey);
//
//   final databases = Databases(client);
//
//   print('Uploading ${_districts.length} districts to Appwrite...\n');
//
//   int success = 0;
//   int failed = 0;
//
//   for (final d in _districts) {
//     final id = d['id'] as String;
//     try {
//       await databases.createDocument(
//         databaseId: _databaseId,
//         collectionId: _collectionId,
//         documentId: id,
//         data: {
//           'name': d['name'],
//           'name_bn': d['name_bn'],
//           'description': d['description'],
//           'cover_image_url': d['cover_image_url'],
//           'place_count': d['place_count'],
//           'latitude': d['latitude'],
//           'longitude': d['longitude'],
//         },
//       );
//       print('✅ $id');
//       success++;
//     } catch (e) {
//       // dart_appwrite 12.2.0 throws a List<dynamic>/List<String> type error
//       // when parsing the response, but the document was actually created.
//       if (e.toString().contains("List<dynamic>") &&
//           e.toString().contains("List<String>")) {
//         print('✅ $id');
//         success++;
//       } else {
//         print('❌ $id — $e');
//         failed++;
//       }
//     }
//   }
//
//   print('\n─────────────────────────────');
//   print('Done. ✅ $success uploaded   ❌ $failed failed');
// }

void main() => print('Districts already uploaded. Uncomment main() to re-run.');
