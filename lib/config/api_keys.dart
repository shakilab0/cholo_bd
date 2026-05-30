/// API keys via --dart-define (never commit real values).
///
/// flutter run \
///   --dart-define=GEMINI_API_KEY=your_key \
///   --dart-define=GOOGLE_MAPS_API_KEY=your_key
abstract class ApiKeys {

  static const gemini = String.fromEnvironment('AIzaSyBcvdqEe1wm3Vde7EGxo6yJBZoG32LgSbs');
  //static const gemini = String.fromEnvironment('GEMINI_API_KEY');
  static const googleMaps = String.fromEnvironment('GOOGLE_MAPS_API_KEY');

  static bool get hasGemini => gemini.isNotEmpty;
  static bool get hasGoogleMaps => googleMaps.isNotEmpty;
}
