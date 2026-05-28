import 'dart:developer';
import 'package:hive/hive.dart';

// Box names
const String _settingsBox = 'settings_box';
const String _districtsBox = 'districts_cache_box';
const String _placesBox = 'places_cache_box';
const String _tripsBox = 'trips_box';
const String _recentSearchesBox = 'recent_searches_box';

Future<Box> _openBox(String name) async {
  if (Hive.isBoxOpen(name)) return Hive.box(name);
  return await Hive.openBox(name);
}

// ── App Settings ─────────────────────────────────────────────────────────────

Future<void> saveIsFirstLaunch(bool value) async {
  final box = await _openBox(_settingsBox);
  await box.put('is_first_launch', value);
}

bool getIsFirstLaunch() {
  if (!Hive.isBoxOpen(_settingsBox)) return true;
  return Hive.box(_settingsBox).get('is_first_launch', defaultValue: true);
}

Future<void> saveOnboardingCompleted(bool value) async {
  final box = await _openBox(_settingsBox);
  await box.put('onboarding_completed', value);
}

bool getOnboardingCompleted() {
  if (!Hive.isBoxOpen(_settingsBox)) return false;
  return Hive.box(_settingsBox)
      .get('onboarding_completed', defaultValue: false);
}

Future<void> saveLanguageIsEnglish(bool value) async {
  final box = await _openBox(_settingsBox);
  await box.put('lang_is_english', value);
}

bool getLanguageIsEnglish() {
  if (!Hive.isBoxOpen(_settingsBox)) return true;
  return Hive.box(_settingsBox).get('lang_is_english', defaultValue: true);
}

Future<void> saveIsGuestMode(bool value) async {
  final box = await _openBox(_settingsBox);
  await box.put('is_guest_mode', value);
}

bool getIsGuestMode() {
  if (!Hive.isBoxOpen(_settingsBox)) return true;
  return Hive.box(_settingsBox).get('is_guest_mode', defaultValue: false);
}

Future<void> saveDisplayName(String name) async {
  final box = await _openBox(_settingsBox);
  await box.put('display_name', name);
}

String? getDisplayName() {
  if (!Hive.isBoxOpen(_settingsBox)) return null;
  final name = Hive.box(_settingsBox).get('display_name');
  if (name == null || (name is String && name.trim().isEmpty)) return null;
  return name as String;
}

Future<void> savePreferredLocationTypes(List<String> types) async {
  final box = await _openBox(_settingsBox);
  final cleaned = types
      .whereType<String>()
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toSet()
      .toList()
    ..sort();
  await box.put('preferred_location_types', cleaned);
}

List<String> getPreferredLocationTypes() {
  if (!Hive.isBoxOpen(_settingsBox)) return [];
  final data = Hive.box(_settingsBox).get('preferred_location_types');
  if (data == null) return [];
  return List<String>.from(data).where((e) => e.trim().isNotEmpty).toList();
}

// ── Districts Cache ───────────────────────────────────────────────────────────

Future<void> saveDistrictsToCache(List<Map<String, dynamic>> districts) async {
  log('Caching ${districts.length} districts...');
  final box = await _openBox(_districtsBox);
  await box.put('districts_data', districts);
}

List<Map<String, dynamic>> getDistrictsFromCache() {
  if (!Hive.isBoxOpen(_districtsBox)) return [];
  final data = Hive.box(_districtsBox).get('districts_data');
  if (data == null) return [];
  return List<Map<String, dynamic>>.from(
    (data as List).map((e) => Map<String, dynamic>.from(e)),
  );
}

// ── Places Cache ─────────────────────────────────────────────────────────────

Future<void> savePlacesToCache(
    String districtId, List<Map<String, dynamic>> places) async {
  log('Caching ${places.length} places for district $districtId...');
  final box = await _openBox(_placesBox);
  await box.put('places_$districtId', places);
}

List<Map<String, dynamic>> getPlacesFromCache(String districtId) {
  if (!Hive.isBoxOpen(_placesBox)) return [];
  final data = Hive.box(_placesBox).get('places_$districtId');
  if (data == null) return [];
  return List<Map<String, dynamic>>.from(
    (data as List).map((e) => Map<String, dynamic>.from(e)),
  );
}

// ── Auth User ────────────────────────────────────────────────────────────────

Future<void> saveUserId(String userId) async {
  final box = await _openBox(_settingsBox);
  await box.put('user_id', userId);
}

String? getUserId() {
  if (!Hive.isBoxOpen(_settingsBox)) return null;
  final v = Hive.box(_settingsBox).get('user_id');
  return (v is String && v.isNotEmpty) ? v : null;
}

Future<void> clearUserSession() async {
  final box = await _openBox(_settingsBox);
  await box.delete('user_id');
  await box.delete('display_name');
  await box.put('is_guest_mode', true);
}

// ── Trips ─────────────────────────────────────────────────────────────────────

Future<void> saveTripsToCache(List<Map<String, dynamic>> trips) async {
  final box = await _openBox(_tripsBox);
  await box.put('user_trips', trips);
}

List<Map<String, dynamic>> getTripsFromCache() {
  if (!Hive.isBoxOpen(_tripsBox)) return [];
  final data = Hive.box(_tripsBox).get('user_trips');
  if (data == null) return [];
  return List<Map<String, dynamic>>.from(
    (data as List).map((e) => Map<String, dynamic>.from(e)),
  );
}

// ── Recent Searches ───────────────────────────────────────────────────────────

Future<void> addRecentSearch(String query) async {
  final box = await _openBox(_recentSearchesBox);
  final List<String> current = getRecentSearches();
  current.remove(query);
  current.insert(0, query);
  await box.put('searches', current.take(8).toList());
}

List<String> getRecentSearches() {
  if (!Hive.isBoxOpen(_recentSearchesBox)) return [];
  final data = Hive.box(_recentSearchesBox).get('searches');
  if (data == null) return [];
  return List<String>.from(data);
}

Future<void> clearRecentSearches() async {
  final box = await _openBox(_recentSearchesBox);
  await box.delete('searches');
}

// ── Open all boxes on startup ─────────────────────────────────────────────────

Future<void> openHiveBoxes() async {
  await Future.wait([
    Hive.openBox(_settingsBox),
    Hive.openBox(_districtsBox),
    Hive.openBox(_placesBox),
    Hive.openBox(_tripsBox),
    Hive.openBox(_recentSearchesBox),
  ]);
  log('Hive boxes opened.');
}
