# 📋 PROJECT CONTEXT — Sana (سَنا)

> **نسخ هذا الملف كاملاً في بداية أي محادثة مع Gemini/AI**
> يحتوي على كل ما يحتاجه الـ AI لفهم المشروع فوراً

---

## 1. معلومات المشروع الأساسية

| المعلومة | القيمة |
|---|---|
| **اسم المشروع** | سنا |
| **اسم الحزمة** | `sana` |
| **نوع التطبيق** | تطبيق إسلامي — Android + Web |
| **إصدار Flutter** | `3.41.0` (channel: stable) |
| **إصدار Dart** | `3.11.0` |
| **إصدار في pubspec** | `^3.8.1` (minimum) |
| **اللغة الرئيسية** | Arabic (ar) |
| **حالة النشر** | 🟢 Live — Android (Google Play) + Web (Vercel) |
| **iOS** | غير منشور — الـ Web يعمل كبديل لمستخدمي iPhone |
| **مستودع** | `d:\flutter\flutter_Projects\muslim_app` |

---

## 2. Architecture & State Management

- **Pattern**: Clean Architecture (Data / Domain / Presentation)
- **ملاحظة مهمة**: ليس كل feature لديها Domain layer — الـ features البسيطة قد تقفز مباشرة من Data إلى Presentation
- **State Management**: `flutter_bloc` — Cubit أو Bloc حسب الأنسب للـ use case
- **Dependency Injection**: `get_it` عبر `ServiceLocator` (`sl`)
- **Routing**: `go_router`
- **Lint Rules**: `very_good_analysis ^10.2.0`
- **Error Handling**: `dartz` (`Either<Failure, T>`) — يُستخدم في repositories التي تتعامل مع Network / Cache

### طريقة تنظيم كل Feature:
```
features/
  feature_name/
    data/
      datasources/   ← (remote / local)
      models/        ← (json serialization)
      repositories/  ← (implementation)
    domain/          ← (اختياري — للـ features المعقدة فقط)
      entities/
      repositories/  ← (abstract)
      usecases/
    presentation/
      controller/    ← (cubit أو bloc + states) — الاسم الموحد هو controller
      views/         ← (full pages)
      widgets/       ← (reusable widgets)
```

---

## 3. الـ Features الموجودة في المشروع

| Feature | مصدر البيانات | الوصف التفصيلي |
|---|---|---|
| `splash` | — | شاشة البداية فقط، لا توجد بيانات |
| `home` | — | الشاشة الرئيسية تجمع كل الميزات للوصول إليها |
| `prayer` | `adhan` package (محلي) | مواقيت الصلاة + السنن + مواعيدها + عداد تنازلي + إعدادات |
| `qibla` | `flutter_compass` (sensor) | اتجاه القبلة، يحتاج location اختياري |
| `azkar` | JSON (local assets) | الأذكار مصنّفة في categories |
| `asma_ul_husna` | JSON (local assets) | الأسماء الحسنى (99 اسم) + ميزة "اسم اليوم" + لوحات مشاركة فنية (Premium Posters) + نظام مفضلة مستقل |
| `salat_ala_Nabi` | محلي + WorkManager | تكرار الصلاة على النبي ﷺ صوتياً مع تذكيرات WorkManager |
| `quran` | `quran_library` package | القرآن الكريم كامل (تفسير + صوت) — لا تدخل من المشروع |
| `hadith_search` | API — موقع الدرر السنية | البحث في الأحاديث + المفضلة (تُحفظ locally) |
| `daily_content` | JSON (local assets) | محتوى يومي (حديث نبوي، سنة مهجورة) + "اسم اليوم" مدمج من موديول الأسماء + نظام مفضلة مبوب |
| `app_date` | محلي + Firebase Remote Config | التاريخ الهجري والميلادي + تعديل يدوي + تحقق تلقائي في شهور رمضان وذي القعدة وذي الحجة (لمراعاة رؤية الهلال) |
| `app_update` | Firebase Remote Config | التحكم في التحديثات: إيقاف التطبيق أو إظهار dialog للتحديث الإجباري/الاختياري |
| `location_manager` | `geolocator` + `geocoding` | إدارة صلاحية الموقع — إجباري عند أول تشغيل (لمواقيت الصلاة) — اختياري للقبلة |
| `teaching_prayer` | JSON (local assets) | تعليم الصلاة، عرض بيانات فقط |
| `report` | Firebase Firestore | إرسال اقتراحات المستخدمين أو الإبلاغ عن مشاكل |

---

## 4. الـ Routes (go_router)

```dart
// AppRoutes class
splash              → /splash
home                → /home
azkar               → /azkar/:categoryId
allAzkar            → /all-azkar
qibla               → /qibla
report              → /report
salatAlaNabi        → /salat-ala-nabi
asmaUlHusna         → /asma-ul-husna
prayerSettings      → /prayerSettings
quran               → /quran
teachingPrayer      → /teaching-prayer
dailyContentFavorites → /daily-content-favorites
hadithSearch        → /hadith-view
hadithFavorites     → /hadith-favorites
developerDashboard  → /developer-dashboard
```

---

## 5. الـ Global Cubits (AppProviders)

هؤلاء يعيشون طوال عمر التطبيق عبر `AppProviders`:

| Cubit | المسؤولية | آلية العمل |
|---|---|---|
| `LocationCubit` | صلاحية الموقع (granted / denied) | يراقب الصلاحية ويُشعر باقي الـ Cubits عند منحها |
| `AppDateCubit` | التاريخ الهجري والميلادي + تعديل يدوي | يتحقق أول كل شهر هجري حرج (رمضان / ذو القعدة / ذو الحجة) ويعرض dialog للمستخدم |
| `LocationNameCubit` | اسم المدينة والبلد | يُشتق من الإحداثيات عبر `geocoding` |
| `PrayerTimesCubit` | مواقيت الصلاة الحالية + عداد تنازلي | يستمع لـ `LocationCubit` و `AppDateCubit` — يُحدّث تلقائياً عند وقت كل صلاة عبر `Timer` — يستخدم `WidgetsBindingObserver` للتحديث عند عودة التطبيق للمقدمة |
| `DailyContentCubit` | المحتوى اليومي (حديث، سنة، اسم اليوم) | يعتمد على `AppDateCubit` لمراقبة تغير التاريخ — ينسق بين `DailyContentRepository` و `IAsmaUlHusnaRepository` — يدير الانتقال اليومي التلقائي (Daily Swap) لضمان التجدد |
| `AppUpdateCubit` | حالة تحديث التطبيق | يقرأ من Firebase Remote Config — الـ `UpdateOverlay` يُغطي كل الشاشات لضمان الإيقاف الكامل أو إجبار التحديث |

---

## 6. الـ Core Layer

### `core/constants/`
- `AppColors` — لوحة الألوان — **Dark Theme فقط (قرار نهائي)**:
  - `scaffoldBackground` = `#000000` (أسود)
  - `secondaryBackground` = `#1C1C1E`
  - `primary` / `gold` = `#D4AF37` (ذهبي)
  - `green` = `#2D6A4F` / `green2` = `#081C15`
- `AppStrings` — رسائل الخطأ الثابتة بالعربي
- `AppConstants` — locale: `ar`, country: `EG`
- `AppAssets` — مسارات الأصول (images, svgs, json, audio)
- `AppLinks` — روابط خارجية

### `core/theme/`
- **Dark Theme فقط** — لن يُضاف Light Theme أبداً
- Fonts: `Cairo` (weights: 200→900) للنصوص العربية + `UthmanTaha` للقرآن الكريم
- `AppTheme.darkTheme` هو الـ theme الوحيد في التطبيق

### `core/routing/`
- `AppRouter` — GoRouter config
- `AppRoutes` — Route paths كـ constants
- `AppTransitions` — Fade + SlideFromRight transitions

### `core/di/`
- `ServiceLocator` (`sl`) — GetIt instance
- ملف DI منفصل لكل feature — **لا تُضاف dependencies في `service_locator.dart` مباشرة**
- `app_providers.dart` — الوجت المسؤول عن تغليف التطبيق بـ `MultiBlocProvider` عالمياً
- الملفات: `core_di`, `azkar_di`, `prayer_di`, `hadith_di`, `location_di`, `qibla_di`, `other_features_di`, `developer_dashboard_di`

### `core/error/`
- `Failure` — abstract base (message + technicalMessage) — يرث من Equatable
- أنواع: `ServerFailure`, `NetworkFailure`, `CacheFailure`, `LocationFailure`, `SensorFailure`, `MissingDataFailure`, `UnknownFailure`

### `core/networking/`
- `DioFactory` — Singleton (timeout: 30s) + `PrettyDioLogger`
- `ApiService` — abstract + `ApiServiceImpl` (GET only) — `ResponseType.plain`
- `firebase/firebase_options.dart` — إعدادات Firebase لكل منصة (أندرويد، iOS، ويب)

### `core/sharing/` (Mini-Module)
- `logic/share_service.dart` — محرك مشاركة النصوص والصور عبر `share_plus`
- `logic/widget_to_image.dart` — تحويل الوجت إلى صورة (pixelRatio: 3)
- `presentation/share_card_container.dart` — حاوية موحدة لأبعاد الصور
- `presentation/app_info_share.dart` — لوجو وبراندنج التطبيق للمشاركة

### `core/services/`
- `sharedpref/shared_pref.dart` — wrapper لـ SharedPreferences
- `sharedpref/pref_keys.dart` — كل مفاتيح SharedPreferences في مكان واحد

### `core/utils/`
- `AppLogger` — wrapper لـ `logger` package — **استخدمه بدلاً من `print()` دائماً**
- `AppBlocObserver` — مراقب Bloc للـ debugging

### `core/common/widgets/`
| Widget | الغرض |
|---|---|
| `AppButtons` | الأزرار القياسية (Primary / Secondary / Icon) — **مصدر موحد لكل الأزرار المشتركة** |
| `AppErrorWidget` | عرض رسائل الخطأ بتنسيق موحد |
| `AppToast` | Toast messages عبر `toastification` |
| `CustomBottomSheet` | Bottom Sheet بتصميم موحد |
| `CustomConfirmationDialog` | Dialog للتأكيد مع تحسين المسافات (Title/Message) |
| `CombinedShareCopyButton` | زر ذكي يدعم وضعين: **مدمج** (Tap للنسخ، Long Press للمشاركة) أو **منفصل** بجانب بعض |
| `CommonSliverAppBar` | AppBar موحد لكل الـ pages |
| `CustomAppDivider` | فاصل بتصميم إسلامي (Islamic Divider) |
| `AnimatedSliverList` | قائمة Sliver بـ animation موحد للعناصر الأولى |
| `ShareCardContainer` | حاوية موحدة لضمان أبعاد متناسقة (core/sharing/presentation) |
| `AppInfoShare` | لوجو وبراندنج التطبيق للمشاركة (core/sharing/presentation) |
| `Artistic Posters` | مفهوم جديد لمشاركة المحتوى كلوحات فنية (Premium) بدلاً من الكروت العادية |
| `ResponsiveWrapper` | **Web فقط** — يقيّد عرض التطبيق بـ max 500px للمحافظة على شكل الموبايل |
| `CustomArrowBackButton` | زر الرجوع الموحد (SolarIconsBold.altArrowRight) |

---

## 7. الـ Dependencies الرئيسية

```yaml
# Firebase
firebase_core: ^4.4.0
firebase_remote_config: ^6.1.4
cloud_firestore: ^6.1.2

# State Management
flutter_bloc: ^9.1.1
equatable: ^2.0.7

# DI
get_it: ^9.1.0

# Routing
go_router: ^17.0.0

# UI
animate_do: ^4.2.0
lottie: ^3.3.1
skeletonizer: ^2.1.0+1
carousel_slider: ^5.1.1
flutter_svg: ^2.2.2

# Islamic
adhan: ^2.0.0+1       ← مواقيت الصلاة
hijri: ^3.0.0          ← التاريخ الهجري
quran_library: ^2.3.1  ← القرآن الكريم
flutter_compass: ^0.8.0 ← بوصلة القبلة
flutter_islamic_icons: ^1.0.2

# Storage
shared_preferences: ^2.2.2
path_provider: ^2.1.5

# Networking
dio: ^5.4.0
pretty_dio_logger: ^1.4.0

# Sharing
share_plus: ^12.0.1
screenshot: ^3.0.0

# Background
workmanager: ^0.9.0+3

# Location
geolocator: ^14.0.2
geocoding: ^4.0.0
permission_handler: ^12.0.1

# Utils
dartz: ^0.10.1         ← Either<Failure, T>
logger: ^2.6.2
intl: ^0.20.2
```

---

## 8. Startup Flow

```
main() async
  ├── WidgetsFlutterBinding.ensureInitialized()
  ├── initializeApp()
  │     ├── FlutterError.onError setup
  │     ├── SystemChrome.setPreferredOrientations([portrait])
  │     ├── initializeDateFormatting('ar')
  │     ├── Firebase.initializeApp()
  │     ├── setupLocator() → registers all GetIt dependencies
  │     ├── Bloc.observer = AppBlocObserver()
  │     └── HijriCalendar.setLocal('ar')
  ├── runApp(SanaApp())
  └── initializeAppPostFrame()  ← post-frame heavy services
        ├── QuranLibrary.init()
        └── WorkManagerService.initialize()

SanaApp
  └── AppProviders (MultiBlocProvider - global cubits)
        └── MaterialApp.router
              ├── theme: AppTheme.darkTheme
              ├── locale: Locale('ar', 'EG')
              └── builder: MediaQuery(noScaling) + ResponsiveWrapper
                    └── Stack[child, UpdateOverlay]
```

---

## 9. قواعد مهمة في هذا المشروع

### Lint — `analysis_options.yaml`
- يرث من `very_good_analysis` — صارم جداً، كل warning = error
- **القواعد المُعطَّلة** (تخصيص للمشروع):
  ```yaml
  public_member_api_docs: false        # لا يُشترط توثيق كل member
  lines_longer_than_80_chars: false    # سطور أطول من 80 مسموحة
  one_member_abstracts: false          # interface بعضو واحد مسموحة
  avoid_positional_boolean_parameters: false  # boolean positional مسموحة
  avoid_catches_without_on_clauses: false     # catch بدون on مسموح
  cascade_invocations: false           # Cascade مش إجباري
  ```
- **المستثنى من التحليل**: `*.g.dart` و `*.freezed.dart`

### Async
- استخدم `unawaited()` من `dart:async` للـ fire-and-forget
- لا تترك Future بدون `await` أو `unawaited()`
- تحقق دائماً من `context.mounted` بعد أي `await` وقبل أي عملية تنقل (Navigation)

### Navigation & UI Icons
- **إغلاق الواجهات**: استخدم `context.pop()` دائماً لإغلاق الـ Dialogs أو الـ BottomSheets (يتطلب `go_router`)
- **الأيقونات**: استخدم `SolarIcons` حصرياً. 
- **أيقونات الاتجاهات**: للتنقل (Next/Forward) في الوضع العربي، استخدم `SolarIconsBold.altArrowLeft` لضمان التوافق مع اتجاه القراءة (RTL).
- **الـ Dialogs**: استخدم `CustomConfirmationDialog` بدلاً من إنشاء Dialogs مخصصة كلما أمكن.

### Initialization (نظام التشغيل)
- **initializeApp**: يتم تشغيل الـ Core Services (Firebase, Locale) والـ setupLocator بشكل متوازٍ لتقليل وقت البدء.
- **Dependency Injection**: 
    - يتم جلب `SharedPreferences` أولاً ثم تمريرها لـ `SharedPref`.
    - أي ميزة ثقيلة (Heavy Services) مثل `QuranLibrary` يتم تهيئتها بعد ظهور أول إطار (Post-Frame) عبر `initializeAppPostFrame`.
    - يتم عمل "Warm-up" للـ `RemoteConfig` في الخلفية فور التشغيل لضمان جهوزية البيانات.

### State Management
- كل Cubit يرث من `Cubit<StateClass>`
- كل State ترث من `Equatable`
- استخدم `part` / `part of` للـ States

### Error Handling
- دائماً `Either<Failure, T>` في الـ Repository
- لا `try/catch` مباشرة في الـ Cubit — التعامل مع الـ Result فقط

### Naming Conventions
- Views → تنتهي بـ `View`
- Cubits → تنتهي بـ `Cubit`
- States → تنتهي بـ `State`
- Models → تنتهي بـ `Model`
- Repositories → تبدأ بـ `I` إن كانت abstract (مثل `IPrayerRepository` أو `IAsmaUlHusnaRepository`)
- **مجلد الـ Controller موحّد**: كل الـ Cubits/Blocs في `presentation/controller/`

### Theming
- لا تستخدم ألوان hardcoded — استخدم `AppColors` دائماً
- لا تستخدم خطوط غير `Cairo` (إلا `UthmanTaha` للقرآن)
- لا تستخدم `print()` — استخدم `AppLogger`

### DI
- كل feature لها ملف DI خاص بها
- لا تُضاف dependencies في `service_locator.dart` مباشرة

### اللغة
- التطبيق **عربي فقط** — قرار نهائي — لا localization مخطط له
- كل النصوص الثابتة في `AppStrings`

---

## 10. ملاحظات مهمة للـ Code Review

- المشروع يستهدف **Android أولاً** ثم Web (كبديل لـ iOS)
- الـ Web build على Vercel يعمل بشكل كامل لكن بعض الـ features مش متاحة (WorkManager وغيرها)
- يوجد `kIsWeb` checks في أماكن عدة — راعيها عند إضافة أي feature
- **SharedPreferences** للـ caching المحلي البسيط فقط
- **Firebase Remote Config**: يُستخدم في `app_update` و `app_date` فقط
- **Firebase Firestore**: يُستخدم في `report` فقط
- الخط الرئيسي: **Cairo** — لا تستخدم خطوط أخرى إلا لنص القرآن (UthmanTaha)
- **لا يوجد Testing** حالياً — مش أولوية
- **Git**: فرع واحد رئيسي حالياً

---

## 11. ملف هذا الـ Context

**الملف**: `PROJECT_CONTEXT.md` (في جذر المشروع)
**آخر تحديث**: 2026-02-25 (تطوير نظام "محتوى اليوم"، فصل منطق الأسماء الحسنى، وتحديث نظام المفضلة المبوب)

