# Cholo BD (Smart Travel BD) — টিম পেজ গাইড

**প্রজেক্ট:** বাংলাদেশ ভ্রমণ অ্যাপ (Flutter)  
**দল:** ১৫ জন সদস্য | **UI অংশ:** ১৬টি  
**ভাষা:** সহজ বাংলা (নন-ডেভেলপারদের জন্য)

---

## সদস্য বরাদ্দ তালিকা (১৫ জন → ১৬ অংশ)

| সদস্য | অংশ | পেজ / স্ক্রিন |
|--------|-----|----------------|
| Member 1 | Part 1 | MyApp + Splash |
| Member 2 | Part 2 + Step 3 | Onboarding ১, ২, ৩ |
| Member 3 | Part 3 | নাম পেজ |
| Member 4 | Part 4 | পছন্দের জায়গা |
| Member 5 | Part 5 | Login |
| Member 6 | Part 6 | Homepage |
| Member 7 | Part 7 | Profile |
| Member 8 | Part 8 | All Districts |
| Member 9 | Part 9 | District Places |
| Member 10 | Part 10 | Place Details |
| Member 11 | Part 11 | My Trips |
| Member 12 | Part 12 | Plan Trip — District |
| Member 13 | Part 13 | Plan Trip — Places |
| Member 14 | Part 14 | Date, Time, Start Location |
| Member 15 | Part 15 + 16 | Transport + Confirm |

**স্বাক্ষর তালিকা (আপনি পূরণ করুন):**

| সদস্যের নাম | Student ID | অংশ | স্বাক্ষর |
|-------------|------------|-----|----------|
| | | | |
| | | | |

---

## অ্যাপ সম্পর্কে সংক্ষেপে (সবাই পড়ুন)

**Cholo BD** হলো বাংলাদেশের জেলা ও দর্শনীয় স্থান খুঁজে ট্রিপ প্ল্যান করার মোবাইল অ্যাপ।

- **Flutter** = এক কোড দিয়ে Android ও iOS অ্যাপ।
- **Widget** = স্ক্রিনের প্রতিটি অংশ (বাটন, টেক্সট, ছবি)।
- **Controller** = বাটন চাপলে কী হবে, ডেটা লোড — সেটা নিয়ন্ত্রণ করে।
- **GetX** = স্ক্রিন বদলানো (`Get.toNamed`) ও রিঅ্যাক্টিভ UI (`Obx`)।
- **Route** = প্রতিটি পেজের ঠিকানা (যেমন `/auth`, `/tabbar`)।

**Parts 12–16** একই পেজের ভিতর: `TripPlanningPage` — উপরে প্রগ্রেস বার, নিচে ধাপ অনুযায়ী UI।

---

## Part 1 — MyApp ও Splash Screen

**দায়িত্ব:** Member 1  
**ফাইল:** `lib/main.dart`, `lib/app/my_app.dart`, `lib/feature/splash_screen/splash_screen.dart`, `splash_screen_controller.dart`

### দায়িত্ব সংক্ষেপে

অ্যাপ চালু হলে প্রথমে **Splash** দেখায় (লোগো + নাম)। ১.৫ সেকেন্ড পর পরবর্তী স্ক্রিনে যায়। `MyApp` পুরো অ্যাপের থিম ও রাউট সেট করে।

### ইউজার কী দেখে

- সাদা/হালকা ব্যাকগ্রাউন্ড
- মাঝখানে অ্যাপ আইকন (বাউন্স অ্যানিমেশন)
- অ্যাপের নাম ও ট্যাগলাইন (বাংলা)

### ইউজার ফ্লো

1. ইউজার অ্যাপ ওপেন করে → Splash (`/`)
2. Controller চেক করে:
   - Onboarding শেষ না → Onboarding Step 1
   - Google লগইন আছে → Tab Bar (Home)
   - আগে Guest ছিল → Tab Bar
   - নাহলে → Login পেজ

### প্রজেক্টে কোন ফাইল

| ফাইল | কাজ |
|------|-----|
| `main.dart` | Hive, নোটিফিকেশন, সার্ভিস শুরু; `runApp(MyApp())` |
| `my_app.dart` | `GetMaterialApp`, থিম রঙ, সব route লিস্ট |
| `splash_screen.dart` | UI (লোগো, টেক্সট) |
| `splash_screen_controller.dart` | ১.৫ সেক পর কোথায় যাবে সিদ্ধান্ত |

### মূল কোড ধারণা

- `StatelessWidget` = UI যা নিজে state রাখে না
- `Get.put(Controller())` = Controller চালু করা
- `Get.offAllNamed(route)` = পুরনো স্ক্রিন মুছে নতুন স্ক্রিন

### ডেমো

1. অ্যাপ ইনস্টল করে ওপেন করুন  
2. Splash দেখুন  
3. প্রথমবার হলে Onboarding আসবে  

### ভাইভা Q&A

**প্র: Splash কেন লাগে?**  
উ: ব্র্যান্ডিং + সময় নিয়ে পেছনে session/onboarding চেক।

**প্র: MyApp কী করে?**  
উ: পুরো অ্যাপের রুট ও রঙ এক জায়গায়।

**প্র: `main.dart` ও `my_app.dart` পার্থক্য?**  
উ: `main` = শুরু; `MyApp` = UI ট্রি।

### সতর্কতা

একা পুরো অ্যাপ চালানোর দরকার নেই — শুধু এই স্ক্রিন বুঝলেই হবে।

---

## Part 2 — Onboarding পেজ ১ ও ২ (+ পেজ ৩)

**দায়িত্ব:** Member 2  
**ফাইল:** `onboarding_step1_page.dart`, `onboarding_step2_page.dart`, `onboarding_step3_page.dart`, `onboarding_controller.dart`

### দায়িত্ব সংক্ষেপে

নতুন ইউজারকে অ্যাপের ৩টি পরিচিতি স্লাইড দেখানো — Explore, Map, Offline।

### ইউজার কী দেখে

- উপরে ডানে **Skip**
- মাঝে বড় আইকন (গোল বৃত্তে)
- ইংরেজি + বাংলা শিরোনাম ও বর্ণনা
- নিচে ডট ইন্ডিকেটর (কোন স্লাইডে আছেন)
- নিচে সবুজ **Next** বাটন

### ইউজার ফ্লো

Step 1 → Next → Step 2 → Next → Step 3 → Next → **Name পেজ**  
Skip যেকোনো সময় → সরাসরি Login

**Route:** `/onboarding/1`, `/onboarding/2`, `/onboarding/3`

### প্রজেক্টে কোন ফাইল

- `OnboardingStep1Page` — explore আইকন  
- `OnboardingStep2Page` — map আইকন  
- `OnboardingStep3Page` — offline আইকন  
- `OnboardingController` — `goToStep2`, `goToStep3`, `goToName`, `skip`

### মূল কোড ধারণা

- `GetView<OnboardingController>` = Controller থেকে ফাংশন কল
- `ElevatedButton(onPressed: controller.goToStep2)` = Next চাপ

### ভাইভা Q&A

**প্র: Skip করলে কোথায় যায়?**  
উ: Login (`auth`) — onboarding completed সেভ হয়।

**প্র: কতটি onboarding স্লাইড?**  
উ: ৩টি (আপনার দলে Part 2-তে ১+২, Step 3 ও একই সদস্য)।

---

## Part 3 — নাম পেজ (Name Page)

**দায়িত্ব:** Member 3  
**ফাইল:** `onboarding_step4_name_page.dart`

### দায়িত্ব সংক্ষেপে

ইউজারের নাম নেওয়া — Guest প্রোফাইলে দেখাবে।

### ইউজার কী দেখে

- “What should we call you?” / “আপনার নাম লিখুন”
- TextField (নাম লিখতে)
- Next বাটন

### ইউজার ফ্লো

Onboarding 3 → Name (`/onboarding/name`) → Preference  
নাম খালি থাকলে snackbar: “Name required”

### মূল কোড ধারণা

- `TextEditingController` = ইনপুট বক্সের টেক্সট
- `saveDisplayName(name)` = Hive-এ নাম সেভ

### ভাইভা Q&A

**প্র: নাম কোথায় সেভ হয়?**  
উ: ফোনের local storage (Hive) — `settings_box`।

---

## Part 4 — পছন্দের জায়গা (Favourite Place Select)

**দায়িত্ব:** Member 4  
**ফাইল:** `onboarding_step5_preference_page.dart`

### দায়িত্ব সংক্ষেপে

ইউজার কোন ধরনের জায়গা পছন্দ করে (পাহাড়, নদী, সমুদ্র, পার্ক ইত্যাদি) — একাধিক বেছে নিতে পারে।

### ইউজার কী দেখে

- “What places do you like?”
- **FilterChip** — চিপ ট্যাপ করলে সিলেক্ট/আনসিলেক্ট
- অপশন: Hill, River, Sea, Park, Historical, Forest, Waterfall, Lake, Museum
- **Done** বাটন

### ইউজার ফ্লো

Name → Preference (`/onboarding/preference`) → Done → Login  
`savePreferredLocationTypes` → Hive

### ভাইভা Q&A

**প্র: FilterChip কী?**  
উ: ছোট ট্যাগ বাটন — ট্যাপ করলে সিলেক্ট হয়।

**প্র: পছন্দ কেন নেওয়া হয়?**  
উ: ভবিষ্যতে হোম/রেকমেন্ডেশন পার্সোনালাইজ করার জন্য (লোকালি সেভ)।

---

## Part 5 — Login Page

**দায়িত্ব:** Member 5  
**ফাইল:** `auth_page.dart`, `auth_controller.dart`

### দায়িত্ব সংক্ষেপে

লগইন বা Guest হিসেবে ঢোকা।

### ইউজার কী দেখে

- অ্যাপ লোগো ও নাম
- **Continue as Guest** (বড় সবুজ বাটন) — মূল অপশন
- Google Sign-In (Outlined) — কোডে এখন কমেন্ট করা থাকতে পারে
- Phone login — “Coming Soon”

### ইউজার ফ্লো

Onboarding শেষ → `/auth`  
Guest → `saveIsGuestMode(true)` → `/tabbar`  
Google → Appwrite OAuth → Tab Bar

### ভাইভা Q&A

**প্র: Guest মোড কী?**  
উ: লগইন ছাড়াই অ্যাপ ব্যবহার; ট্রিপ লোকালি সেভ হতে পারে।

**প্র: Appwrite কী?**  
উ: ক্লাউডে লগইন ও ডেটাবেস — টিম লিড সেটআপ করে।

---

## Part 6 — Homepage

**দায়িত্ব:** Member 6  
**ফাইল:** `home_page.dart`, `home_page_controller.dart`, widgets: `season_banner`, `featured_slider`, `quick_actions_row`, `district_card`

### দায়িত্ব সংক্ষেপে

অ্যাপের মূল স্ক্রিন — featured places, quick actions, জনপ্রিয় জেলা।

### ইউজার কী দেখে

- উপরে লোকেশন/অভিবাদন
- Season ব্যানার
- Featured Places স্লাইডার (বাম-ডান সোয়াইপ)
- Quick Actions (Plan Trip, Map, Search Districts)
- Explore Districts — ২ কলাম গ্রিড

### ইউজার ফ্লো

Tab Bar → Home (ইনডেক্স ০)  
জেলা কার্ড ট্যাপ → District Places  
See All → All Districts  
Featured ট্যাপ → Place Details

### ভাইভা Q&A

**প্র: Shimmer কী?**  
উ: লোডিংয়ের সময় ধূসর অ্যানিমেশন প্লেসহোল্ডার।

**প্র: Obx কেন?**  
উ: ডেটা বদলালে UI অটো আপডেট।

---

## Part 7 — Profile Page

**দায়িত্ব:** Member 7  
**ফাইল:** `profile_page.dart`, `profile_controller.dart`

### দায়িত্ব সংক্ষেপে

ইউজার প্রোফাইল, ভাষা, সেটিংস, লগআউট।

### ইউজার কী দেখে

- প্রোফাইল হেডার (নাম, Guest/User)
- Stats: Trips, Places, Districts
- Language toggle (English/Bangla)
- Settings, Guest banner, Logout

### ইউজার ফ্লো

Tab Bar → Profile (ইনডেক্স ৩)

### ভাইভা Q&A

**প্র: Profile-এ ট্রিপ সংখ্যা কোথা থেকে?**  
উ: Controller ট্রিপ লিস্ট কাউন্ট করে।

---

## Part 8 — All Districts Page

**দায়িত্ব:** Member 8  
**ফাইল:** `all_districts_page.dart`

### দায়িত্ব সংক্ষেপে

বাংলাদেশের সব জেলা তালিকা + সার্চ।

### ইউজার কী দেখে

- AppBar: “Bangladesh”, Back
- Search bar — ইংরেজি/বাংলা নামে খোঁজা
- ২ কলাম জেলা গ্রিড

### ইউজার ফ্লো

Home → See All Districts → `/all-districts`  
কার্ড ট্যাপ → District Places

### ভাইভা Q&A

**প্র: সার্চ কীভাবে কাজ করে?**  
উ: `_query` দিয়ে নাম filter — রিয়েল টাইম।

---

## Part 9 — District All Places Page

**দায়িত্ব:** Member 9  
**ফাইল:** `district_places_page.dart`, `district_places_controller.dart`

### দায়িত্ব সংক্ষেপে

একটি জেলার সব দর্শনীয় স্থান তালিকা + ফিল্টার।

### ইউজার কী দেখে

- উপরে জেলার বড় cover ছবি (SliverAppBar)
- ফিল্টার: All, Free, Popular ইত্যাদি
- স্থানের লিস্ট (ছবি, নাম, রেটিং)
- নিচে **Plan Trip** বার

### ইউজার ফ্লো

জেলা বেছে নিন → `/district-places` (argument: district)  
স্থান ট্যাপ → Place Details  
Plan Trip → Trip Planning

### ভাইভা Q&A

**প্র: Hero animation কী?**  
উ: জেলা কার্ড থেকে বিস্তারিত পেজে ছবি মসৃণ ট্রানজিশন।

---

## Part 10 — Selected Place / Place Details

**দায়িত্ব:** Member 10  
**ফাইল:** `place_details_page.dart`, `place_details_controller.dart`

### দায়িত্ব সংক্ষেপে

একটি স্থানের বিস্তারিত — ছবি, ভিডিও, ফি, সময়, বুকমার্ক।

### ইউজার কী দেখে

- বড় image carousel
- বুকমার্ক বাটন
- নাম, রেটিং, entry fee, opening hours, best time
- ভিডিও সেকশন (থাকলে)
- Map / directions (থাকলে)

### ইউজার ফ্লো

যেকোনো তালিকা থেকে স্থান ট্যাপ → `/place-details` (argument: place)

### ভাইভা Q&A

**প্র: PlaceModel কী?**  
উ: একটি স্থানের ডেটা ক্লাস — নাম, lat/lng, ছবি ইত্যাদি।

---

## Part 11 — My Trips Page

**দায়িত্ব:** Member 11  
**ফাইল:** `trips_page.dart`, `trips_controller.dart`

### দায়িত্ব সংক্ষেপে

সেভ করা সব ট্রিপ দেখা, ফিল্টার, নতুন ট্রিপ শুরু।

### ইউজার কী দেখে

- AppBar “My Trips”, + বাটন
- ফিল্টার: Upcoming, All, Completed
- ট্রিপ কার্ড (জেলা, তারিখ, transport)
- খালি থাকলে empty state

### ইউজার ফ্লো

Tab Bar → Trips (ইনডেক্স ১)  
+ → Trip Planning  
কার্ড ট্যাপ → Trip Details

### ভাইভা Q&A

**প্র: ট্রিপ কোথায় সেভ?**  
উ: Hive + Appwrite (অফলাইন-ফার্স্ট)।

---

## Part 12 — Plan Trip: District Select

**দায়িত্ব:** Member 12  
**ফাইল:** `step_district.dart` (+ shared: `trip_planning_page.dart`)

### দায়িত্ব সংক্ষেপে

ট্রিপ প্ল্যানের **ধাপ ১** — কোন জেলায় যাবেন বেছে নিন।

### ইউজার কী দেখে

- “Where do you want to go?”
- জেলার গ্রিড; সিলেক্ট করলে হাইলাইট
- উপরে প্রগ্রেস বার (১/৫)

### ইউজার ফ্লো

Home/ Trips → Plan Trip → `/trip-planning`  
`currentStep = 0` → District  
Next → Places step

### ভাইভা Q&A

**প্র: TripPlanningController কী?**  
উ: ৫ ধাপের সব স্টেট (জেলা, স্থান, তারিখ…) এক জায়গায়।

---

## Part 13 — Plan Trip: Select Places

**দায়িত্ব:** Member 13  
**ফাইল:** `step_places.dart`

### দায়িত্ব সংক্ষেপে

**ধাপ ২** — সর্বোচ্চ ৫টি স্থান বেছে নিন।

### ইউজার কী দেখে

- “Select places to visit”
- “2/5 selected · ~4 hrs”
- লিস্টে টিক চিহ্ন সহ স্থান

### ইউজার ফ্লো

District সিলেক্ট 후 → Places (`currentStep = 1`)

### ভাইভা Q&A

**প্র: কেন সর্বোচ্চ ৫?**  
উ: এক দিনে যাওয়া যায় এমন সীমা — `maxPlacesPerDay = 5`।

---

## Part 14 — Date, Time, Start Location

**দায়িত্ব:** Member 14  
**ফাইল:** `step_datetime.dart`

### দায়িত্ব সংক্ষেপে

**ধাপ ৩** — কখন যাবেন, কয়টায় শুরু, কোথা থেকে শুরু (GPS বা ম্যানুয়াল উপজেলা)।

### ইউজার কী দেখে

- Quick chips: Today, Tomorrow, Weekend
- তারিখ পিকার
- সময় preset + Time Picker
- Current location / Select manually + District/Sub-district dropdown

### ইউজার ফ্লো

Places → DateTime (`currentStep = 2`)  
অতীত সময় দিলে লাল warning

### ভাইভা Q&A

**প্র: Location permission কেন?**  
উ: “বর্তমান লোকেশন” থেকে রুট প্ল্যান করতে।

---

## Part 15 — Transport Select

**দায়িত্ব:** Member 15 (অংশ ১)  
**ফাইল:** `step_transport.dart`, `transport_option_model.dart`

### দায়িত্ব সংক্ষেপে

**ধাপ ৪** — রিকশা, CNG, বাস, ট্রেন, নৌকা, প্রাইভেট কার — যা সম্ভব সেটা দেখায়।

### ইউজার কী দেখে

- “How will you travel?”
- লোডিং: “Calculating routes…”
- প্রতিটি transport কার্ড — সময়, km; unavailable গ্রে

### ভাইভা Q&A

**প্র: AI/Gemini কে হ্যান্ডল করে?**  
উ: টিম লিড — transport ফিল্টার; UI শুধু ফলাফল দেখায়।

---

## Part 16 — Plan Trip Confirm

**দায়িত্ব:** Member 15 (অংশ ২)  
**ফাইল:** `step_confirm.dart`

### দায়িত্ব সংক্ষেপে

**ধাপ ৫** — সব তথ্য রিভিউ করে ট্রিপ সেভ।

### ইউজার কী দেখে

- Trip name TextField
- Summary card: District, Start, Places, Date, Time, Transport
- Itinerary লিস্ট
- নিচে **Create Trip** (parent page-এ)

### ইউজার ফ্লো

Transport → Confirm (`currentStep = 4`) → Create → My Trips + notification

### ভাইভা Q&A

**প্র: Confirm-এ কী যাচাই হয়?**  
উ: ইউজার চোখে সব ঠিক আছে কিনা; তারপর সেভ।

---

## শেষ নোট (টিম লিডের জন্য)

- প্রতিটি সদস্য শুধু **নিজের অংশ** ভাইভায় বলবে — অন্য ফাইলের গভীর কোড জানতে হবে না।
- স্ক্রিনশট যোগ করলে রিপোর্ট ভালো লাগে — প্রতি Part-এ ১টি।
- Google login / API key — শুধু লিড জানলেই চলে।

**প্রজেক্ট:** Cholo BD v1.0 | **Smart Travel BD**
