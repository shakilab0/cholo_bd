# API keys for CholoBd

Keys are **not** stored in the repo. Pass them at build/run time with `--dart-define`.

## 1. Gemini (transport feasibility filter)

1. Open [Google AI Studio](https://aistudio.google.com/apikey).
2. Create an API key (free tier: Gemini Flash models).
3. Use model `gemini-2.0-flash` or `gemini-1.5-flash`.

## 2. Google Maps (route duration & distance)

1. Open [Google Cloud Console](https://console.cloud.google.com/).
2. Enable **Routes API** (or Distance Matrix API).
3. Create an API key and restrict it (Android app + iOS bundle ID recommended).
4. Billing must be enabled; Google provides monthly free credit.

## Run the app

```bash
flutter run \
  --dart-define=GEMINI_API_KEY=YOUR_GEMINI_KEY \
  --dart-define=GOOGLE_MAPS_API_KEY=YOUR_MAPS_KEY
```

Without keys, the app still runs: homepage shows "Bangladesh" if location is denied; transport step uses fallback feasibility rules and static time labels.

## VS Code / Android Studio

Add the same `--dart-define` flags to your launch configuration.
