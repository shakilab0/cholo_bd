# CHOLO BD (Smart Travel BD)
## A Comprehensive Mobile Application for Discovering and Planning Travel Across Bangladesh

---

**Project Type:** University Final Year / Semester Project  
**Platform:** Android & iOS (Cross-platform)  
**Technology Stack:** Flutter, Dart, Appwrite BaaS, Google APIs, Gemini AI  
**Version:** 1.0.0  
**Academic Year:** 2025–2026  

---

## Table of Contents

1. [Abstract](#1-abstract)
2. [Introduction](#2-introduction)
3. [Problem Statement](#3-problem-statement)
4. [Objectives](#4-objectives)
5. [Literature Review & Related Work](#5-literature-review--related-work)
6. [System Analysis](#6-system-analysis)
7. [System Design](#7-system-design)
8. [Technology Stack](#8-technology-stack)
9. [Implementation Details](#9-implementation-details)
10. [Features & Modules](#10-features--modules)
11. [Database Design](#11-database-design)
12. [API Integration](#12-api-integration)
13. [User Interface Design](#13-user-interface-design)
14. [Testing Strategy](#14-testing-strategy)
15. [Security Considerations](#15-security-considerations)
16. [Limitations & Future Work](#16-limitations--future-work)
17. [Conclusion](#17-conclusion)
18. [References](#18-references)
19. [Appendix](#19-appendix)

---

## 1. Abstract

**Cholo BD** (branded in-app as *Smart Travel BD*) is a Flutter-based mobile application designed to help users discover tourist destinations across all 64 districts of Bangladesh and plan personalized day trips with intelligent transport recommendations. The application combines a clean Material Design 3 interface with a Backend-as-a-Service (Appwrite) cloud backend, offline-first local caching (Hive), real-time GPS location, interactive maps (flutter_map), Google Routes API for accurate travel duration, and Google Gemini AI for context-aware filtering of Bangladesh-specific transport modes (rickshaw, CNG, bus, train, boat, private car).

The system addresses the gap between generic global travel apps—which lack localized transport logic—and manual trip planning using fragmented web searches. Cholo BD provides a unified, bilingual-ready (English/Bangla) experience from onboarding through trip creation, reminders, and itinerary management.

**Keywords:** Flutter, Bangladesh tourism, trip planning, Appwrite, Gemini AI, offline-first, mobile application.

---

## 2. Introduction

### 2.1 Background

Bangladesh is home to UNESCO World Heritage sites (Sundarbans, Bagerhat), hill tracts (Bandarban, Rangamati), beaches (Cox's Bazar), and hundreds of historical and natural attractions spread across 64 administrative districts. Domestic tourism is growing, yet many travelers—especially students and first-time visitors—struggle to find reliable information about places, entry fees, best visiting seasons, and realistic transport options between urban centers and remote destinations.

### 2.2 Project Motivation

Existing international apps (Google Travel, TripAdvisor) often lack granular data for Bangladeshi districts and do not model local transport realistically (e.g., suggesting boats for inland Dhaka routes). **Cholo BD** was developed as a university project to demonstrate:

- Modern cross-platform mobile development with **Flutter**
- **Clean Architecture** principles (presentation → domain → data)
- Integration of **cloud backend**, **AI**, and **mapping APIs**
- User-centered design for the Bangladesh travel context

### 2.3 Scope

The application covers:

- Destination discovery (districts, places, featured content)
- Multi-step trip planning wizard
- Transport feasibility with AI + routing APIs
- Trip storage (cloud + local cache)
- Local notifications for trip reminders
- Guest and Google OAuth authentication
- Interactive map of places

Out of scope for v1.0: payment/booking, real-time chat, social sharing, phone OTP login.

---

## 3. Problem Statement

Travelers in Bangladesh face several challenges:

| Challenge | Description |
|-----------|-------------|
| **Information fragmentation** | Place details scattered across blogs, Facebook groups, and unofficial sources |
| **Unrealistic transport advice** | Generic apps ignore rickshaw/CNG/boat feasibility by geography |
| **No unified itinerary tool** | Users manually combine maps, calendars, and notes |
| **Offline connectivity** | Rural travel areas have poor network; apps must cache data |
| **Language barrier** | Many locals prefer Bangla place names alongside English |

**Cholo BD** solves these by centralizing curated place data, applying Bangladesh-specific transport rules via Gemini AI, caching content locally, and supporting bilingual labels.

---

## 4. Objectives

### 4.1 Primary Objectives

1. Build a cross-platform mobile app for Android and iOS using Flutter.
2. Implement district- and place-based tourism discovery backed by Appwrite.
3. Provide a guided 5-step trip planning flow (district → places → date/time → transport → confirm).
4. Integrate GPS for current-location-based trip starts.
5. Use AI to filter feasible transport modes for each route.
6. Use Google Routes API for traffic-aware duration and distance estimates.
7. Persist trips with offline-first Hive cache and cloud sync.
8. Schedule local notifications (3 days before, 1 day before, day-of trip).

### 4.2 Secondary Objectives

1. Support guest mode for users who skip login.
2. Google OAuth via Appwrite for authenticated sessions.
3. Onboarding flow capturing user name and travel preferences.
4. Interactive map showing place markers.
5. Seed/fallback data when backend is unavailable.

### 4.3 Success Criteria

- App launches and navigates through splash → onboarding → auth → main tabs.
- User can create a trip with at least one place and selected transport.
- Trips appear in "My Trips" and open in trip details view.
- Transport step shows only feasible modes when APIs are configured.
- App remains usable without API keys (fallback rules).

---

## 5. Literature Review & Related Work

### 5.1 Existing Solutions

| Application | Strengths | Gaps for Bangladesh |
|-------------|-----------|---------------------|
| **Google Maps / Travel** | Routing, reviews | Weak local place curation; no trip wizard |
| **TripAdvisor** | Reviews, photos | Limited BD district coverage |
| **Pathao / Uber** | Urban ride-hailing | Not for inter-district tourism planning |
| **BD tourism websites** | Official info | Not mobile-native; no personalization |

### 5.2 Theoretical Foundation

- **Clean Architecture** (Uncle Bob): separation of UI, business rules, and data sources.
- **Repository Pattern**: abstracts Appwrite and Hive behind a single interface.
- **Either monad (dartz)**: functional error handling with `Left(Failure)` / `Right(data)`.
- **Offline-first**: local cache as source of truth, cloud as sync layer.

### 5.3 Innovation in This Project

1. **Gemini-powered transport filter** with Bangladesh-specific prompt engineering.
2. **Hybrid routing**: Haversine distance + Google Routes API + rule-based fallback.
3. **Sub-district start points** when GPS is unavailable (manual origin selection).
4. **Curated seed data** embedded for demo and offline resilience.

---

## 6. System Analysis

### 6.1 Stakeholders

- **End users:** Tourists, students, families planning domestic trips.
- **Administrator:** Content manager uploading districts/places via Appwrite console or `tools/upload_places` scripts.
- **Developer:** Maintains Flutter codebase and API keys.

### 6.2 Functional Requirements

| ID | Requirement |
|----|-------------|
| FR-01 | User shall view featured places and popular districts on home screen |
| FR-02 | User shall search and browse places by district |
| FR-03 | User shall view place details (images, videos, fees, hours, map coordinates) |
| FR-04 | User shall complete onboarding and set travel preferences |
| FR-05 | User shall sign in with Google or continue as guest |
| FR-06 | User shall create a trip via 5-step wizard |
| FR-07 | User shall select up to 5 places per trip day |
| FR-08 | System shall validate trip start time is in the future |
| FR-09 | System shall recommend feasible transport modes |
| FR-10 | System shall show route duration/distance when Maps API available |
| FR-11 | User shall view, filter, and delete trips |
| FR-12 | System shall schedule trip reminder notifications |
| FR-13 | User shall view places on an interactive map |
| FR-14 | User shall toggle English UI (Bangla strings prepared in models) |

### 6.3 Non-Functional Requirements

| ID | Requirement |
|----|-------------|
| NFR-01 | Portrait-only orientation for consistent UX |
| NFR-02 | Response time &lt; 3s for cached district/place lists |
| NFR-03 | Graceful degradation without API keys |
| NFR-04 | API keys not committed to version control |
| NFR-05 | Material Design 3 theming |

### 6.4 Use Case Diagram (Textual)

```
[User] --> (Browse Districts)
[User] --> (View Place Details)
[User] --> (Plan Trip)
[User] --> (Manage Trips)
[User] --> (View Map)
[User] --> (Authenticate)
[System] --> (Filter Transport via AI)
[System] --> (Compute Route via Google)
[System] --> (Sync Trips to Appwrite)
[System] --> (Cache Data in Hive)
[System] --> (Send Notifications)
```

---

## 7. System Design

### 7.1 Architecture Overview

The project follows **feature-based Clean Architecture**:

```
lib/
├── app/                    # MyApp, global theme
├── config/                 # Colors, API keys, constants
├── core/                   # Routes, DI, services, Hive, failures
├── dio_helper/             # Appwrite client provider
└── feature/
    ├── auth/
    ├── homepage/           # data / domain / presentation
    ├── trip_planning/
    ├── trips/
    ├── trip_details/
    ├── active_trip/
    ├── place_details/
    ├── district_places/
    ├── map/
    ├── profile/
    ├── onboarding/
    ├── splash_screen/
    └── tabbar/
```

**Layers per feature:**

| Layer | Responsibility | Example |
|-------|----------------|---------|
| **Presentation** | UI, GetX controllers, bindings | `TripPlanningController` |
| **Domain** | Use cases, repository interfaces | `CreateTripUseCase` |
| **Data** | Models, repository impl, remote/local sources | `TripRepositoryImpl` |

### 7.2 Navigation Flow

```
Splash (1.5s)
  ├─ Onboarding not done → Onboarding Steps 1–5
  ├─ Appwrite session exists → Tab Bar
  ├─ Guest mode flag → Tab Bar
  └─ Else → Auth (Google / Guest)

Tab Bar: [Home | My Trips | Map | Profile]
  ├─ Home → District Places → Place Details
  ├─ Home → Trip Planning (5 steps)
  ├─ Trips → Trip Details → Active Trip
  └─ Map → Place markers
```

### 7.3 Trip Planning State Machine

| Step | Index | User Action |
|------|-------|-------------|
| District | 0 | Select destination district |
| Places | 1 | Select 1–5 places |
| Date & Time | 2 | Pick date, start time, origin (GPS or sub-district) |
| Transport | 3 | View AI-filtered modes + route estimates |
| Confirm | 4 | Review and save trip |

### 7.4 Data Flow (Trip Creation)

```
UI (Step Confirm)
  → TripPlanningController.createTrip()
  → CreateTripUseCase
  → TripRepositoryImpl
      ├─ Save to Hive (immediate)
      └─ Create document in Appwrite trips collection
  → NotificationService.scheduleForTrip()
  → Navigate to Trips tab
```

---

## 8. Technology Stack

### 8.1 Frontend / Mobile

| Technology | Version | Purpose |
|------------|---------|---------|
| **Flutter** | SDK ≥3.3 | Cross-platform UI framework |
| **Dart** | 3.x | Programming language |
| **GetX** | ^4.6.6 | State management, DI, routing |

### 8.2 Backend & Storage

| Technology | Purpose |
|------------|---------|
| **Appwrite** | Authentication, NoSQL database, file storage |
| **Hive** | Local key-value cache (settings, districts, places, trips) |
| **Shared Preferences** | (available; Hive primary for settings) |

### 8.3 Networking & APIs

| Technology | Purpose |
|------------|---------|
| **Dio** | HTTP client for Google Routes API |
| **Appwrite SDK** | Database CRUD, OAuth |
| **Google Routes API** | Traffic-aware duration & distance |
| **Google Generative AI (Gemini)** | Transport feasibility JSON filter |

### 8.4 Maps & Location

| Package | Purpose |
|---------|---------|
| **flutter_map** + **latlong2** | OpenStreetMap-based place map |
| **geolocator** | Device GPS position |
| **geocoding** | Reverse geocoding for labels |

### 8.5 UI & Media

| Package | Purpose |
|---------|---------|
| **google_fonts** | Typography |
| **cached_network_image** | Image loading |
| **shimmer** | Loading skeletons |
| **carousel_slider** | Featured places banner |
| **video_player** | Place video playback |
| **flutter_local_notifications** | Trip reminders |

### 8.6 Utilities

| Package | Purpose |
|---------|---------|
| **dartz** | `Either<Failure, T>` for repositories |
| **intl** | Date/time formatting |
| **uuid** | Trip document IDs |

---

## 9. Implementation Details

### 9.1 Application Entry (`main.dart`)

On startup the app:

1. Locks orientation to portrait.
2. Sets transparent status bar styling.
3. Initializes Hive and opens five boxes (settings, districts, places, trips, searches).
4. Initializes `NotificationService`.
5. Registers permanent GetX services: `LocationService`, `GeminiTransportFilterService`, `GoogleRoutesService`.
6. Runs `MyApp` with GetMaterialApp routing.

### 9.2 Authentication

- **Guest mode:** Sets `is_guest_mode` in Hive, skips Appwrite user document.
- **Google OAuth:** `Account.createOAuth2Session(OAuthProvider.google)` via Appwrite; stores `user_id` and `display_name` in Hive.
- **Session restore:** Splash screen calls `account.get()` to restore logged-in users.
- **Android:** `CallbackActivity` with custom scheme `appwrite-callback-{projectId}`.

### 9.3 Homepage Module

**Controller:** `HomePageController`  
**Use cases:** `GetDistrictsUseCase`, `GetFeaturedPlacesUseCase`

Features:

- Location-aware greeting via `LocationService` (district label or "Bangladesh").
- Season banner, featured carousel, quick actions (plan trip, map, districts).
- Popular districts grid with shimmer loading.
- Repository returns cached districts first, then fetches from Appwrite; falls back to `seedDistricts` on error.

### 9.4 Trip Planning Module

**Core logic in `TripPlanningController` (~600 lines):**

- Loads districts from use case; places per district with seed fallback.
- **Start location:** GPS (`useCurrentLocationAsStart`) or sub-district picker from `sub_district_data.dart`.
- **Transport estimates:** Cache key based on origin/destination; calls Gemini filter then Google Routes per mode.
- **Validation:** Future start time, at least one place, transport selected before confirm.
- **Trip name:** Auto-generated ("Today in Cox's Bazar", etc.) or user override.

### 9.5 Gemini Transport Filter

`GeminiTransportFilterService`:

- Sends structured prompt with origin/destination coordinates, district name, and distance.
- Expects JSON: `{ "available": [...], "unavailable": [{ "id", "reason" }] }`.
- **Fallback** when no API key: distance-based rules (rickshaw/CNG &lt; 20 km, boat only &gt; 50 km coastal heuristic, etc.).

### 9.6 Google Routes Service

- Endpoint: `routes.googleapis.com/directions/v2:computeRoutes`
- Travel modes mapped per transport type (DRIVE, TRANSIT, etc.).
- Returns `RouteResult(durationMinutes, distanceKm)` for UI labels.

### 9.7 Trip Repository (Offline-First)

`TripRepositoryImpl`:

1. Reads trips from Hive cache immediately.
2. Attempts Appwrite sync (list/create/update/delete).
3. Merges remote documents into local cache on success.
4. Serializes places as JSON string in Appwrite document (`places_json` field).

### 9.8 Notifications

Scheduled notifications:

- **D-3:** "Trip in 3 days" (9:00 AM)
- **D-1:** "Pack & get ready" (8:00 PM)
- **Day-of:** Morning reminder at trip start time

### 9.9 Map Module

- Fetches up to 100 places via `GetMapPlacesUseCase`.
- Displays markers on `flutter_map` with OpenStreetMap tiles.
- Tap navigates to place details.

### 9.10 Data Seeding & Admin Tools

Directory `tools/upload_places/` contains Dart scripts:

- `districts_data.dart` — district seed definitions
- `curated_places.dart` — place content
- `place_generator.dart` — Appwrite upload utility

Embedded `seedDistricts` and `seedPlaces` in models ensure demo functionality without network.

---

## 10. Features & Modules

### 10.1 Module Summary

| Module | Screens | Key Files |
|--------|---------|-----------|
| Splash | SplashScreen | `splash_screen_controller.dart` |
| Onboarding | 5 steps | `onboarding_step1_page.dart` … step5 |
| Auth | AuthPage | `auth_controller.dart` |
| Home | HomePage | `home_page.dart`, widgets |
| District Places | DistrictPlacesPage | `district_places_controller.dart` |
| Place Details | PlaceDetailsPage | Media, video sheet |
| Trip Planning | 5 step widgets | `step_district.dart` … `step_confirm.dart` |
| Trips | TripsPage | List, filters, delete |
| Trip Details | TripDetailsPage | Full itinerary |
| Active Trip | ActiveTripPage | In-progress trip view |
| Map | MapPage | OSM markers |
| Profile | ProfilePage | Settings, logout, language |
| All Districts | AllDistrictsPage | Full district list |

### 10.2 Transport Modes Supported

| ID | Mode | Typical Use |
|----|------|-------------|
| rickshaw | Rickshaw | Short urban |
| cng | CNG Auto | City travel |
| bus | Bus | Inter-district |
| train | Train | Long distance |
| boat | Boat/Launch | River/coastal (Sundarbans, etc.) |
| private_car | Private Car | Flexible comfort |

### 10.3 Place Model Attributes

- Bilingual names (`name`, `name_bn`)
- Images, videos, tags
- Entry fee, opening hours, best season
- GPS coordinates, rating, review count
- District association

---

## 11. Database Design

### 11.1 Appwrite Database

**Project:** Cholo BD  
**Endpoint:** `https://sgp.cloud.appwrite.io/v1`  
**Database ID:** `69ec314b0038beeb4258`

### 11.2 Collections

#### districts
| Field | Type | Description |
|-------|------|-------------|
| name | string | District name (EN) |
| name_bn | string | Bangla name |
| image | string | Cover image URL |
| description | string | Short description |
| place_count | integer | Number of places |
| is_popular | boolean | Show on home grid |

#### places
| Field | Type | Description |
|-------|------|-------------|
| name, name_bn | string | Place names |
| district_id | string | Foreign key to district |
| description | string | Full description |
| images | string[] | Image URLs |
| videos | string[] | Video URLs |
| latitude, longitude | double | Coordinates |
| entry_fee, is_free_entry | number/bool | Pricing |
| rating, review_count | number | Social proof |
| tags | string[] | Categories |

#### trips
| Field | Type | Description |
|-------|------|-------------|
| name | string | Trip title |
| district_id, district_name | string | Destination |
| places_json | string | Serialized place array |
| transport | string | Transport mode ID |
| trip_date, created_at | integer | Unix ms timestamps |
| status | string | upcoming / active / completed |
| user_id | string | Owner (guest = empty) |
| start_lat, start_lng, start_label | optional | Origin |
| transport_route_display | string | e.g. "2h 15m" |
| transport_distance_km | double | Route distance |

#### users
| Field | Type | Description |
|-------|------|-------------|
| (managed by Appwrite Auth) | | Profile extensions as needed |

### 11.3 Local Hive Boxes

| Box Name | Keys | Purpose |
|----------|------|---------|
| settings_box | onboarding, guest, user_id, language, location | App state |
| districts_cache_box | districts_data | Offline districts |
| places_cache_box | places_{districtId} | Per-district places |
| trips_box | user_trips | Offline trips |
| recent_searches_box | searches | Search history (max 8) |

---

## 12. API Integration

### 12.1 API Keys Management

Keys are injected at build time (never stored in Git):

```bash
flutter run \
  --dart-define=GEMINI_API_KEY=YOUR_KEY \
  --dart-define=GOOGLE_MAPS_API_KEY=YOUR_KEY
```

`ApiKeys` class reads `String.fromEnvironment` and exposes `hasGemini`, `hasGoogleMaps` flags.

### 12.2 Gemini API

- **Model:** `gemini-2.0-flash`
- **Input:** Route context prompt
- **Output:** JSON list of feasible transport IDs
- **Cost:** Free tier suitable for academic/demo usage

### 12.3 Google Routes API

- Requires billing-enabled Google Cloud project
- Field mask: `routes.duration,routes.distanceMeters`
- Routing preference: `TRAFFIC_AWARE`

### 12.4 Appwrite API

- Document list/create/update/delete for all collections
- OAuth2 session management
- Singapore region endpoint for lower latency in Bangladesh

---

## 13. User Interface Design

### 13.1 Design System

- **Primary color:** Brand green (`AppColor.primary`)
- **Background:** Light off-white (`AppColor.bgDark`)
- **Cards:** Elevated white surfaces (`AppColor.bgCard`)
- **Typography:** Google Fonts via `app_text_style.dart`
- **Material 3** enabled globally

### 13.2 UX Patterns

- **Shimmer placeholders** during network loads
- **Pull-to-refresh** on home (hook prepared)
- **IndexedStack** on tab bar preserves scroll state
- **Step progress bar** in trip planning
- **Obx / GetView** for reactive UI updates

### 13.3 Accessibility & Localization

- English default; Bangla strings in models (`nameBn`, transport `nameBn`)
- `MyApp.isEnglish` reactive flag for future full i18n
- Large touch targets on district cards and transport tiles

---

## 14. Testing Strategy

### 14.1 Manual Test Cases

| # | Test Case | Expected Result |
|---|-----------|-----------------|
| T1 | Fresh install | Onboarding shown |
| T2 | Skip onboarding completion | Returns to onboarding on relaunch |
| T3 | Guest login | Tab bar accessible, no Appwrite user |
| T4 | Google login | Session restored on restart |
| T5 | Create trip without API keys | Fallback transport + static times |
| T6 | Create trip with API keys | Filtered modes + live durations |
| T7 | Select past start time | Next button disabled / validation error |
| T8 | Airplane mode after cache | Districts/places from Hive |
| T9 | Delete trip | Removed from list and cache |
| T10 | Trip 3 days ahead | Notification scheduled (device dependent) |

### 14.2 Automated Tests

- `test/widget_test.dart` — default Flutter widget test scaffold (expandable for CI).

### 14.3 Device Testing

- Tested on Android emulator/device via `flutter run`
- iOS supported via Xcode project in `ios/Runner`

---

## 15. Security Considerations

| Area | Measure |
|------|---------|
| API keys | `--dart-define` only; documented in `docs/API_KEYS.md` |
| OAuth | Appwrite-managed tokens; callback scheme per project |
| Guest data | Trips stored locally; `user_id` empty in cloud |
| Network | HTTPS for all remote calls |
| Permissions | Location requested at runtime when needed |
| `.gitignore` | Should exclude `api_keys.dart` if containing secrets |

**Recommendation for production:** Move sensitive keys to backend proxy; enable Appwrite collection-level permissions per user.

---

## 16. Limitations & Future Work

### 16.1 Current Limitations

1. Phone OTP login marked "Coming Soon."
2. Full Bangla UI translation incomplete (data layer ready).
3. Home pull-to-refresh handler empty.
4. No in-app ticket/hotel booking.
5. Weather API not integrated (notification text only).
6. Trip planning limited to single-day, single-district focus.
7. Review/rating not user-submittable in-app.

### 16.2 Future Enhancements

1. **Multiday itineraries** across districts.
2. **Community reviews** and photo uploads.
3. **Offline maps** (MBTiles) for remote areas.
4. **Share trip** via link / PDF export.
5. **Admin mobile app** for content moderation.
6. **Pathao/Uber deep links** for last-mile rides.
7. **Bangla voice search** and accessibility (TalkBack).
8. **Unit & integration tests** with mock Appwrite.

---

## 17. Conclusion

**Cholo BD (Smart Travel BD)** successfully demonstrates a production-style Flutter application tailored to Bangladesh domestic tourism. By combining Clean Architecture, Appwrite cloud services, Hive offline caching, GPS-aware trip origins, Gemini AI transport filtering, and Google Routes estimates, the project delivers a cohesive solution to real-world travel planning pain points.

The modular codebase (~94 Dart files in `lib/`) is maintainable and extensible for future semesters or commercial deployment. For academic evaluation, the project showcases competency in mobile development, API integration, AI prompt engineering, UX design, and software engineering best practices.

---

## 18. References

1. Flutter Documentation — https://docs.flutter.dev  
2. Appwrite Documentation — https://appwrite.io/docs  
3. Google Routes API — https://developers.google.com/maps/documentation/routes  
4. Google Gemini API — https://ai.google.dev  
5. GetX State Management — https://github.com/jonataslaw/getx  
6. Hive Database — https://docs.hivedb.dev  
7. flutter_map — https://docs.fleaflet.dev  
8. Clean Architecture (Robert C. Martin) — Prentice Hall, 2017  
9. Bangladesh Tourism Board — https://www.bangladesh.com  
10. UNESCO Bangladesh World Heritage — https://whc.unesco.org  

---

## 19. Appendix

### A. Project Directory Structure (Abbreviated)

```
cholo_bd/
├── android/                 # Android native config
├── ios/                     # iOS native config
├── assets/images/           # Static assets
├── docs/                    # API_KEYS.md, this report
├── lib/                     # Application source (94 .dart files)
├── test/                    # Widget tests
├── tools/upload_places/     # Data seeding scripts
└── pubspec.yaml             # Dependencies
```

### B. Run Instructions

```bash
# Install dependencies
flutter pub get

# Run with API keys
flutter run \
  --dart-define=GEMINI_API_KEY=xxx \
  --dart-define=GOOGLE_MAPS_API_KEY=xxx

# Build release APK
flutter build apk --release \
  --dart-define=GEMINI_API_KEY=xxx \
  --dart-define=GOOGLE_MAPS_API_KEY=xxx
```

### C. Screens Overview (For Demo / Viva)

1. **Splash** — Brand logo, session check  
2. **Onboarding** — App intro, name, preferences  
3. **Auth** — Google + Guest  
4. **Home** — Featured, districts, location header  
5. **Place Details** — Gallery, video, info  
6. **Trip Planning** — 5-step wizard with AI transport  
7. **My Trips** — Saved itineraries  
8. **Map** — Geographic discovery  
9. **Profile** — User settings, logout  

### D. Viva Questions & Sample Answers

**Q: Why Flutter?**  
A: Single codebase for Android/iOS, hot reload for fast university development, rich widget ecosystem.

**Q: Why Appwrite instead of Firebase?**  
A: Open-source BaaS, self-hostable, integrated auth/database/storage with straightforward Dart SDK.

**Q: Why use AI for transport?**  
A: Rule-only systems fail on edge cases (boat vs inland water); LLM encodes geographic common sense with structured JSON output.

**Q: How is offline handled?**  
A: Hive caches districts, places, and trips; repository reads cache first; seed data as last resort.

---

**Submitted by:** _________________________  
**Student ID:** _________________________  
**Department:** _________________________  
**University:** _________________________  
**Supervisor:** _________________________  
**Date:** May 2026  

---

*End of Report — Cholo BD (Smart Travel BD) v1.0.0*
