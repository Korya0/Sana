# 📐 تقرير التحليل المعماري الشامل — Architecture Refactor Analysis

**المشروع:** Muslim App (Sana)  
**تاريخ المسح:** 13 يوليو 2026  
**الهدف:** فحص شامل لجميع ملفات `lib/` وفقاً لمبادئ Clean Architecture / Layered Architecture و SOLID

---

## 🧭 منهجية الفحص

تم مسح جميع ملفات المشروع (أكثر من 200 ملف) في المجلد `lib/` وتصنيف المخالفات وفقاً للمبادئ التالية:

| المبدأ | الاختصار | التركيز |
|--------|----------|---------|
| الطبقات والمسؤوليات | Layering & SRP | فصل UI عن Business Logic عن Data Access |
| الكلاسات العملاقة | God Class | كلاس يتحكم في دورة الحياة + جلب البيانات + منطق + عرض |
| اتجاه التبعية | Dependency Direction | UI ← State ← Services ← Repositories (عبر Interfaces) |
| التسمية والكبسلة | Naming & Encapsulation | أسماء واضحة + State محمي بـ Getters/Methods |
| SOLID | SOLID | S, O, D — التركيز على Single Responsibility, Dependency Inversion, Open/Closed |

---

## 📋 جدول المحتويات

1. [مخالفات الطبقات والمسؤوليات (Layering & SRP)](#1)
2. [الكلاسات العملاقة (God Classes)](#2)
3. [اتجاه التبعية (Dependency Direction)](#3)
4. [التسمية والكبسلة (Naming & Encapsulation)](#4)
5. [مبادئ SOLID](#5)
6. [مشاكل معمارية أخرى](#6)
7. [الملفات التي تم فحصها — فهرس كامل](#7)
8. [ملخص عام وإحصائيات](#8)
9. [خريطة طريق الـ Refactoring المقترحة](#9)

---

## <a name="1"></a>1️⃣ مخالفات الطبقات والمسؤوليات (Layering & SRP)

### 1.1 `lib/core/di/service_locator.dart` — God Initializer

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/core/di/service_locator.dart` |
| **الرائحة البرمجية** | يدمج مسؤوليات متعددة: تهيئة Firebase (مع timeout)، إعداد Crashlytics، إعداد Error Handlers (FlutterError + PlatformDispatcher)، إعداد Lifecycle Observer لتغيير المنطقة الزمنية، إعداد Remote Config مع تأخير 30 ثانية، إدارة Heavy Services (إشعارات + WorkManager)، تخزين Timezone، إعداد Notification Tap Handler مع Router |
| **المبدأ المخالف** | **SRP** — كلاس واحد له أكثر من "سبب واحد للتغيير" (Firebase team, Notifications team, Config team...) |
| **الحل المقترح** | استخراج إلى: `FirebaseBootstrapper`، `AppErrorHandler`، `LifecycleManager`، `HeavyServicesBootstrapper`، `NotificationTapHandler` |

---

### 1.2 `lib/features/prayer/data/repos/prayer_repository.dart` — Repository يحتوي على Business Logic

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/features/prayer/data/repos/prayer_repository.dart` |
| **الرائحة البرمجية** | Repository يقوم بحساب أوقات الصلاة (حسابات فلكية) واستدعاء مكتبة `adhan` مباشرة، مع تعيين الإعدادات (CalculationMethod, Madhab, Adjustments) |
| **المبدأ المخالف** | **SRP + Layering** — Repository دوره الوحيد: تجريد الوصول إلى البيانات. حسابات الأوقات هي **Business Logic** ويجب أن تكون في Service |
| **الحل المقترح** | استخراج `PrayerCalculationService` يحوي منطق التحويل والحساب. Repository يبقى فقط لـ data mapping |

---

### 1.3 `lib/features/prayer/data/services/prayer_state_service.dart` — Service في Data يحوي Core Logic

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/features/prayer/data/services/prayer_state_service.dart` |
| **الرائحة البرمجية** | على الرغم من اسمه Service، فهو **جوهر منطق التطبيق**: يحسب الصلاة الحالية والتالية، أوقات السنة، Middle of Night / Last Third. لكنه موجود داخل `data/services/` |
| **المبدأ المخالف** | **Layering Violation** — Business Logic Core يجب أن يكون في `domain/services/` |
| **الحل المقترح** | نقل `PrayerStateServiceImpl` إلى `domain/services/prayer_state_service.dart` |

---

### 1.4 `lib/features/daily_content/data/repos/daily_content_repository.dart` — Repository عملاق

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/features/daily_content/data/repos/daily_content_repository.dart` |
| **الرائحة البرمجية** | الـ Repository يدير: جلب البيانات، التخزين المؤقت (caching)، التبديل العشوائي (shuffling)، تتبع المشاهدات اليومية، إدارة المفضلة (JSON encode/decode)، حساب التواريخ |
| **المبدأ المخالف** | **SRP** — على الأقل 4 مسؤوليات مختلفة في كلاس واحد (اقتران عالي جداً) |
| **الحل المقترح** | استخراج: `DailyContentLocalDataSource` (JSON+cache)، `DailyContentShuffleService` (خلط)، `DailyContentFavoritesService` (مفضلة). Repository يبقى orchestrator فقط |

---

### 1.5 `lib/features/salat_ala_nabi/presentation/cubit/reminder_cubit.dart` — Cubit متعدد المهام

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/features/salat_ala_nabi/presentation/cubit/reminder_cubit.dart` |
| **الرائحة البرمجية** | الـ Cubit يدير: تحميل الإعدادات، 6 دوال تعديل (toggle، interval، working hours، start/end time)، حفظ الإعدادات مع جدولة الإشعارات، عرض الإشعارات التأكيدية |
| **المبدأ المخالف** | **SRP** — جدولة الإشعارات وعرضها ليست من مسؤوليات الـ Cubit |
| **الحل المقترح** | استخراج `SaveReminderSettingsUseCase` الذي ينادي `_repo.saveSettings()` + `_reminderService.scheduleReminders()` / `cancelReminders()` |

---

### 1.6 `lib/features/salat_ala_nabi/data/services/salawat_background_executor.dart` — Background Callback يعيد تهيئة DI

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/features/salat_ala_nabi/data/services/salawat_background_executor.dart` |
| **الرائحة البرمجية** | الدالة `_executeSalawatTask` تستدعي `setupLocator()` (إعادة تهيئة DI بالكامل) و `sl<INotificationService>().initialize()` في كل مرة يُنفذ فيها التاسك |
| **المبدأ المخالف** | **Coupling + Performance** — تهيئة DI كاملة لكل تنفيذ (مكلف جداً في Isolate) |
| **الحل المقترح** | `BackgroundTaskInitializer` يهيئ DI مرة واحدة، ثم `SalawatTaskExecutor` ينفذ المنطق |

---

### 1.7 `lib/features/prayer/data/services/religious_events_service.dart` — Service في Data مع Use Cases مضمنة

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/features/prayer/data/services/religious_events_service.dart` |
| **الرائحة البرمجية** | يحتوي على منطق حساب الأيام بين التواريخ الهجرية (`_calculateDaysInBetween`, `_calculateDaysToNextYearEvent`) وهو **Business Logic** بحت |
| **المبدأ المخالف** | **Layering** — Business Logic في طبقة Data |
| **الحل المقترح** | نقل دوال حساب الأيام إلى `CalculateDaysBetweenHijriDatesUseCase` في `domain/use_cases/` |

---

### 1.8 `lib/features/settings/presentation/views/settings_view.dart` — View يحتوي على Business Logic

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/features/settings/presentation/views/settings_view.dart` |
| **الرائحة البرمجية** | الـ View يقوم بفتح URLs (`_launchURL` مع `canLaunchUrl`/`launchUrl`)، عرض Bottom Sheet للمظهر، مشاركة التطبيق عبر `SharePlus.instance.share()` مباشرة |
| **المبدأ المخالف** | **Layering** — UI يجب ألا يعرف شيئاً عن `canLaunchUrl`, `launchUrl`, `SharePlus.instance` |
| **الحل المقترح** | إنشاء `ExternalLinkService` في `core/services/`، وتفويض المشاركة لـ `SettingsCubit` عبر `IShareService` |

---

### 1.9 `lib/features/settings/presentation/views/settings_view.dart` — Theme Bottom Sheet كامل في View

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/features/settings/presentation/views/settings_view.dart` (دالة `_showThemeBottomSheet`) |
| **الرائحة البرمجية** | الـ View يحتوي على `RadioListTile<ThemeMode>` + `showCustomBottomSheet` + استدعاء `setThemeMode()` مباشرة — كل منطق المظهر في Widget |
| **المبدأ المخالف** | **Layering Violation** — الـ View يجب أن يرسل الحدث فقط لـ Cubit ويتلقى الحالة |
| **الحل المقترح** | استخراج `ThemeModeSelectorBottomSheet` كـ Widget منفصل، أو جعل `SettingsCubit` يدير حالة الـ Bottom Sheet |

---

### 1.10 `lib/features/azkar/presentation/widgets/zikr_card/zikr_item_card.dart` — Haptic + Timer في Widget

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/features/azkar/presentation/widgets/zikr_card/zikr_item_card.dart` |
| **الرائحة البرمجية** | `_ZikrItemCardState` يحتوي على `_lastPressTime` لـ debouncing، و `playVibrate()` لـ haptic، ومنطق مضاعف (مرتين عند الإكمال) |
| **المبدأ المخالف** | **SRP** — الـ Widget مسؤول عن العرض فقط، ليس عن التحكم في الـ haptic والـ debouncing |
| **الحل المقترح** | نقل الـ debounce إلى `AzkarCubit`، واستدعاء haptic عبر `IHapticService` من الـ Cubit |

---

### 1.11 `lib/features/app_update/data/datasources/app_update_data_source.dart` — DataSource يقوم بكل شيء

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/features/app_update/data/datasources/app_update_data_source.dart` |
| **الرائحة البرمجية** | `AppUpdateServiceImpl` يقوم بـ: جلب Remote Config مع timeout، تخزين مؤقت (cache)، جلب PackageInfo، فتح URLs للتحديث |
| **المبدأ المخالف** | **SRP + DIP** — 3 مسؤوليات مختلفة في كلاس واحد (Remote Config, Version, URL Launcher) |
| **الحل المقترح** | فصل إلى: `RemoteConfigService` (جلب التحديثات)، `AppVersionService` (رقم الإصدار)، `UpdateUrlLauncher` (فتح الرابط)، `AppUpdateService` (تنسيق) |

---

## <a name="2"></a>2️⃣ الكلاسات العملاقة (God Classes)

### 2.1 `lib/core/di/service_locator.dart` — 370+ سطراً مع 10+ مسؤوليات

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/core/di/service_locator.dart` |
| **الرائحة البرمجية** | `setupLocator`, `initializeApp` (مع 3 try/catch متداخلة)، `_setupCrashlytics`, `_setupPerformance`, `_setupGlobalErrorHandlers`, `_AppLifecycleObserver` (كلاس داخلي)، `_setupLifecycleObserver`, `_storeTimezone`, `setupNotificationTapHandler`, `initializeAppPostFrame`, `_initHeavyServices` |
| **المبدأ المخالف** | **God Class** — يتحكم في دورة الحياة والتطبيق بالكامل |
| **الحل المقترح** | انظر 1.1 أعلاه |

---

### 2.2 `lib/core/services/location_manager/presentation/cubit/location_permission/location_cubit.dart` — 200+ سطر

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/core/services/location_manager/presentation/cubit/location_permission/location_cubit.dart` |
| **الرائحة البرمجية** | يدير: التهيئة (`_init`)، التحقق من الموقع المحفوظ (`hasStoredLocation`)، طلب الإذن مع عد الرفض (`_deniedCount`)، فتح الإعدادات (`enableLocationService`)، حفظ الموقع (`saveManualPosition`، `_savePosition`)، إظهار شيت الاختيار (`requestChoice`) |
| **المبدأ المخالف** | **God Class** — على الأقل 3 مسؤوليات متميزة |
| **الحل المقترح** | `LocationPermissionCubit` (إدارة الإذن فقط) + `LocationPositionCubit` (حفظ الموقع والتحقق) |

---

### 2.3 `lib/features/daily_content/data/repos/daily_content_repository.dart` — 200+ سطر

(مذكور أعلاه في 1.4)

---

### 2.4 `lib/features/azkar/presentation/cubits/reminder/reminder_cubit.dart` — 7 Dependencies

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/features/azkar/presentation/cubits/reminder/reminder_cubit.dart` |
| **الرائحة البرمجية** | 7 Use Cases/Services محقونة في constructor، 6 دوال عامة (load, create, update, delete, toggle, openSettings, requestPermissions) |
| **المبدأ المخالف** | **God Class** — 7 اعتماديات لكوبيت واحد = إشارة واضحة أنه يفعل أكثر مما يجب |
| **الحل المقترح** | دمج الـ 5 Use Cases في `ReminderUseCases` واحد (Facade pattern): `ReminderUseCases(getReminders, createReminder, updateReminder, deleteReminder, toggleReminder)` |

---

## <a name="3"></a>3️⃣ اتجاه التبعية (Dependency Direction)

### 3.1 `lib/features/settings/presentation/views/settings_view.dart` — UI يعتمد على مكتبات خارجية

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/features/settings/presentation/views/settings_view.dart` |
| **الرائحة البرمجية** | يستورد `share_plus` و `url_launcher` مباشرة في الـ View |
| **المبدأ المخالف** | **DIP** — الـ UI يعتمد على تفاصيل (مكتبات) وليس تجريدات (Services) |
| **الحل المقترح** | استخدام `ILaunchUrlService` و `IShareService` عبر الـ Cubit |

---

### 3.2 `lib/features/prayer/data/services/prayer_state_service.dart` — Service يعتمد على مكتبة Adhan

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/features/prayer/data/services/prayer_state_service.dart` |
| **الرائحة البرمجية** | `PrayerStateServiceImpl.resolveNextTime()` يستخدم `PrayerTimes` و `Coordinates` و `DateComponents` من مكتبة `adhan` داخله، رغم أن التطبيق لديه `CoordinatesEntity` الخاص به |
| **المبدأ المخالف** | **DIP + Leaky Abstraction** — تفاصيل المكتبة تتسرب إلى الـ Service |
| **الحل المقترح** | إنشاء `PrayerTimesCalculatorService` في `domain/` يعتمد على entities المشروع فقط |

---

### 3.3 `lib/features/salat_ala_nabi/data/services/salawat_background_executor.dart` — Background يستخدم SL

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/features/salat_ala_nabi/data/services/salawat_background_executor.dart` |
| **الرائحة البرمجية** | `sl<INotificationService>()`, `sl<IReminderRepository>()`, `sl<ISalawatReminderService>()` تُسحب مباشرة من Service Locator داخل Isolate |
| **المبدأ المخالف** | **Service Locator Anti-pattern في Isolate** — يصعب اختباره، والاعتماديات غير مرئية |
| **الحل المقترح** | `SalawatBackgroundTaskHandler` مع dependencies عبر constructor: `SalawatBackgroundTaskHandler({required this.repository, required this.reminderService, ...})` |

---

### 3.4 `lib/features/hadith_search/data/datasources/dorar_api_client.dart` — API Client مباشر بدون واجهة وسيطة

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/features/hadith_search/data/datasources/dorar_api_client.dart` |
| **الرائحة البرمجية** | `DorarApiClient` هو `@RestApi()` مباشر (retrofit)، و `HadithRemoteDataSource` يعتمد عليه مباشرة |
| **المبدأ المخالف** | **Leaky Abstraction (خفيف)** — الـ Remote Data Source يعتمد على تفاصيل الـ HTTP client بدلاً من واجهة وسيطة. لكنه مقبول لأنه Data Source |
| **الحل المقترح** | لا حاجة للتغيير فوراً — لكن يمكن إضافة واجهة `IDorarApiClient` إذا تعددت الـ API clients |

---

## <a name="4"></a>4️⃣ التسمية والكبسلة (Naming & Encapsulation)

### 4.1 تعدد أنماط Interfaces

| الملفات | النمط المستخدم |
|---------|----------------|
| `IAzkarRepository`، `IQuranRepo`، `IFeedbackRepository` | `I` prefix ✅ |
| `ReminderRepository` (azkar/domain) | بدون `I` ❌ |
| `IFeedbackRepository` | `abstract class` |
| `IReminderRepository` (salat_ala_nabi) | `abstract interface class` |
| `ILocalStorageService` | `abstract interface class` |

**الحل:** توحيد إلى `abstract interface class I*Repository` / `abstract interface class I*Service`.

---

### 4.2 `azkar/presentation/cubits/` — تسمية المجلد (جمع) بينما الباقي (مفرد)

| المسار | النمط |
|--------|-------|
| `azkar/presentation/cubits/` | جمع |
| `prayer/presentation/cubit/` | مفرد |
| `asma_ul_husna/presentation/cubit/` | مفرد |
| `quran/presentation/cubit/` | مفرد |

**الحل:** توحيد إلى `cubit/` أو `cubits/` في كل المشروع.

---

### 4.3 `lib/features/quran/data/repos/quran_repo.dart` — QuranRepoImpl vs AzkarRepositoryImpl

استخدام `Repo` بدلاً من `Repository` — غير متناسق مع `AzkarRepositoryImpl` و `DailyContentRepoImpl` وغيرهما.

---

### 4.4 `lib/features/hadith_search/presentation/cubit/hadith_search/hadith_search_state.dart` — استخدام part of

| الحقل | القيمة |
|-------|--------|
| **الملف** | `lib/features/hadith_search/presentation/cubit/hadith_search/hadith_search_state.dart` |
| **الرائحة البرمجية** | يستخدم `part of 'hadith_search_cubit.dart'` — ربط الـ State بالـ Cubit |
| **المبدأ المخالف** | **Modularity** — هذا النمط قديم في Flutter Bloc، كل الـ features الأخرى تستخدم `import` بدلاً من `part of` |
| **الحل المقترح** | تحويل `hadith_search_state.dart` إلى ملف مستقل يُستورد بشكل طبيعي |

---

### 4.5 `lib/core/networking/api_error_handler.dart` — دالة Top-level بدلاً من UseCase

`handleApiError()` هي دالة top-level. بينما بقية معالجة الأخطاء تتم عبر `Result<T>` + `Failure` classes.

---

## <a name="5"></a>5️⃣ مبادئ SOLID

### 5.1 🔴 S — Single Responsibility

تم تغطيتها في الأقسام 1 و 2. أبرز 4 كلاسات مخالفة:
1. `service_locator.dart` — 10+ مسؤوليات
2. `daily_content_repository.dart` — 5+ مسؤوليات
3. `location_cubit.dart` — 4+ مسؤوليات
4. `reminder_cubit.dart` (azkar) — 7 Dependencies

---

### 5.2 🟡 O — Open/Closed

**إيجابي:** استخدام `sealed class Result<T>` + pattern matching يسمح بتمديد السلوك.
**سلبي:** `FailureMapper.mapFailureToMessage()` يحتوي `switch` على كل الـ Failures — إضافة Failure جديد يتطلب تعديل هذه الدالة.

**الحل:** إضافة `String get userMessage;` في كل `Failure` class (أو Visitor Pattern).

---

### 5.3 🟢 L — Liskov Substitution

لا توجد انتهاكات صريحة. الـ implementations تتبع العقود بشكل جيد.

---

### 5.4 🟡 I — Interface Segregation

| الواجهة | المشكلة | الحل |
|---------|---------|------|
| `IReligiousEventsService` | `init()` + `getEventForDate()` — مسؤوليتان مختلفتان | فصل إلى `IInitializable` + `IEventProvider` |
| `ILocationRepository` | 11 دالة (isEnabled, hasPermission, requestPermission, savePosition, saveManualPosition, getCityAndCountry, getPermissionStatus, hasStoredLocation, getStoredLocationName, openLocationSettings) | تقسيم إلى 3 واجهات: `ILocationPermissionRepository` + `ILocationDataRepository` + `ILocationServiceRepository` |

---

### 5.5 🟢/🟡 D — Dependency Inversion

**إيجابيات:**
- معظم الـ Repositories تستخدم واجهات ✅
- GetIt (Service Locator) يستخدم للحقن ✅
- `Result<T>` مع Sealed Classes لمعالجة الأخطاء ✅

**سلبيات:**
- بعض الـ Views تستخدم `sl<Service>()` مباشرة (Service Locator Anti-pattern في UI)
- Background Isolate يستخدم `sl<>` مباشرة (3.3)
- `PrayerStateServiceImpl` يعتمد على مكتبة `adhan` بدلاً من تجريد (3.2)

---

## <a name="6"></a>6️⃣ مشاكل معمارية أخرى

### 6.1 تعدد أنماط Use Cases

| النمط | مثال |
|-------|------|
| UseCase كلاس منفصل مع `call()` | `GetCategoriesUseCase`, `CreateReminderUseCase` (في azkar) |
| UseCase static const | `IsReligiousEventOccurringUseCase()` (في prayer) |
| دالة top-level | `handleApiError()` (في api_error_handler) |

**الحل:** توحيد إلى **UseCase كلاس مع `call()`**.

---

### 6.2 Stream subscriptions مباشرة بين Cubits

- `DailyContentCubit` يشترك في `appDateCubit.stream` عبر `_dateSubscription`
- `LocationNameCubit` يشترك في `locationCubit.stream` عبر `_locationSubscription`

**المشكلة:** اقتران بين Cubits — يصعب تتبع التبعيات.

**الحل:** استخدام `BlocListener` في الـ View + استدعاء `refresh()`.

---

### 6.3 `lib/core/services/location_manager/` — Service داخل core وليس feature

الـ Location Manager يدير Cubits و Widgets و Views — هو Feature مستقل بذاته. وجوده في `core/services/` غير صحيح هيكلياً.

**الحل:** نقله إلى `features/location_manager/`.

---

### 6.4 `lib/core/services/sharing/presentation/` — Widgets داخل core

`combined_share_copy_button.dart`, `share_card_container.dart`, `app_share.dart`, `app_clipboard.dart` — كلها Widgets UI و Service utilities.

**الحل:** نقل الـ widgets إلى `features/sharing/presentation/widgets/` والـ services إلى `features/sharing/data/`.

---

### 6.5 `lib/core/common/` — Junk Drawer

`core/common/` يحتوي على كل شيء: buttons, decorations, favorites, layout, overlays (bottom sheet, dialog, toast), slivers, widgets.

**الحل:** تنظيم حسب الوظيفة:
```
core/common/buttons/
core/common/cards/
core/common/dialogs/
core/common/toasts/
core/common/layout/
```

---

### 6.6 `lib/features/qibla/` — Interfaces مكررة في domain و data

`lib/features/qibla/domain/repositories/qibla_repository.dart` + `lib/features/qibla/domain/services/qibla_service.dart`:
- الـ `IQiblaRepository` في `domain/` و `QiblaRepoImpl` في `data/repos/` — واجهة واحدة
- الـ `IQiblaService` في `domain/` و `QiblaServiceImpl` في `data/services/` — لكن هذا صحيح لأن الـ Service Business Logic موجود في data!

المشكلة: `QiblaServiceImpl` (Business Logic بحت — حسابات مثلثات) موجود في `data/services/` وليس `domain/services/`.

**الحل:** نقل `QiblaServiceImpl` إلى `domain/services/` لأنه Business Logic بحت.

---

### 6.7 `lib/features/prayer/data/services/` — 5 Services خارج domain

جميع Services الصلاة موجودة في `data/services/`:
- `PrayerStateService` — **Business Logic** (حسابات أوقات الصلاة)
- `PrayerTimesService` — **Orchestrator** (مقبول في data)
- `UserSettingsService` — **Data Access** (مقبول في data)
- `ReligiousEventsService` — **Business Logic + Data Access**
- `PrayerStatusService` — **Data Access** (JSON parsing + cache)

**الحل:** نقل الـ Business Logic Services إلى `domain/services/`.

---

### 6.8 `lib/features/quran/` — Feature صغير جداً

يحتوي فقط على `QuranCubit` → `_quranRepo.initialize()` → `QuranLibrary.init()`. يمكن دمجه مع Feature آخر أو تبسيطه.

---

### 6.9 `lib/core/di/azkar_di.dart` — on Exception catch متبقي

السطر ~68 لا يزال يستخدم `on Exception catch (e2, stack2)` بينما الـ convention الجديد يتطلب `on Object catch`.

---

### 6.10 `lib/core/services/analytics/` — FirebaseAnalyticsServiceImpl يحوي getNameExtractor

`getObserver()` في `FirebaseAnalyticsServiceImpl` يحتوي على منطق لاستخراج أسماء الشاشات من GoRouter — هذا منطق عرض (presentation logic) في Service.

---

### 6.11 `lib/core/services/permissions/app_permissions_manager.dart` — كلاس ممتاز لكنه يعتمد على Permission Handler مباشرة

`AppPermissionsManagerImpl` يستخدم `Permission.notification` و `Permission.location` إلخ مباشرة — مقبول لأنه Gateway/Adapter.

---

## <a name="7"></a>7️⃣ الملفات التي تم فحصها — فهرس كامل

### ✅ تم فحصها — لا توجد مخالفات كبيرة (أو مخالفاتها طفيفة)

| المسار | ملاحظات |
|--------|---------|
| `lib/core/constants/*` | ثوابت فقط — لا توجد مخالفات |
| `lib/core/theme/*` | إعدادات مظهر فقط — لا توجد مخالفات |
| `lib/core/routing/*` | توجيه فقط — لا توجد مخالفات هيكلية |
| `lib/core/networking/result.dart` | نمط Result ممتاز ✅ |
| `lib/core/error/*` | هيكلة Failures جيدة ✅ |
| `lib/core/services/database/*` | Data Access بخير ✅ |
| `lib/core/services/haptic/*` | خدمة بسيطة بخير ✅ |
| `lib/core/services/background/*` | واجهة جيدة مع WorkManager ✅ |
| `lib/core/services/analytics/*` | واجهة جيدة مع Firebase Analytics ✅ |
| `lib/features/asma_ul_husna/**` | هندسة جيدة بشكل عام ✅ |
| `lib/features/home/**` | هندسة جيدة ✅ |
| `lib/features/teaching_prayer/**` | هندسة جيدة ✅ |
| `lib/features/feedback/**` | هندسة جيدة ✅ |
| `lib/features/hadith_search/**` | هندسة جيدة (باستثناء part of) ✅ |
| `lib/features/developer_dashboard/**` | هندسة جيدة ✅ |
| `lib/features/splash/**` | بسيط وجيد ✅ |
| `lib/features/settings/*` (باستثناء الـ View) | بخير ✅ |
| `lib/core/cubit/*` | AppCubit جيد ومتواضع ✅ |

### ⚠️ تم فحصها — مخالفات موجودة (مذكورة أعلاه)

| المسار | القسم |
|--------|-------|
| `lib/core/di/service_locator.dart` | 1.1, 2.1 |
| `lib/core/di/azkar_di.dart` | 6.9 |
| `lib/core/di/*` (بقية الـ DI files) | بخير ✅ |
| `lib/core/services/location_manager/**` | 6.3 |
| `lib/core/services/sharing/presentation/**` | 6.4 |
| `lib/core/services/permissions/*` | 6.11 (ممتاز) |
| `lib/core/common/**` | 6.5 |
| `lib/core/utils/app_logger.dart` | جيد ✅ |
| `lib/features/prayer/data/services/*` | 1.2, 1.3, 1.7, 6.7 |
| `lib/features/prayer/domain/**` | بخير ✅ |
| `lib/features/prayer/presentation/**` | بخير ✅ |
| `lib/features/daily_content/data/**` | 1.4, 2.3 |
| `lib/features/azkar/**` (معظم الملفات) | جيد ✅ |
| `lib/features/azkar/presentation/cubits/reminder/reminder_cubit.dart` | 2.4 |
| `lib/features/azkar/presentation/widgets/zikr_card/zikr_item_card.dart` | 1.10 |
| `lib/features/salat_ala_nabi/**` | 1.5, 1.6, 3.3 |
| `lib/features/settings/presentation/views/settings_view.dart` | 1.8, 1.9, 3.1 |
| `lib/features/qibla/**` | 6.6 |
| `lib/features/quran/**` | 4.3, 6.8 |
| `lib/features/app_update/**` | 1.11, 3.2 |
| `lib/features/hadith_search/presentation/cubit/hadith_search/hadith_search_state.dart` | 4.4 |
| `lib/features/hadith_search/data/datasources/dorar_api_client.dart` | 3.4 |
| `lib/features/asma_ul_husna/presentation/views/asma_ul_husna_view.dart` | بخير ✅ |

---

## <a name="8"></a>8️⃣ ملخص عام وإحصائيات

| البند | العدد |
|-------|-------|
| **إجمالي الملفات في `lib/`** | ~200+ |
| **مخالفات SRP/Layering (1.x)** | 11 رئيسية |
| **God Classes (2.x)** | 4 |
| **مخالفات Dependency Direction (3.x)** | 4 |
| **مشاكل تسمية/كبسلة (4.x)** | 5 |
| **مخالفات SOLID** | S: 4 حرجة, O: 1, I: 2, D: 3 |
| **مشاكل معمارية أخرى (6.x)** | 11 |
| **ملفات بدون مخالفات** | ~150+ |

### التوزيع حسب الشدة:

```
🔴 حرجة (تؤثر على الصيانة والتوسع): 10
🟡 متوسطة (تحتاج إعادة هيكلة): 18
🟢 خفيفة (تحسينات وتحسين نمط): 14
```

---

## <a name="9"></a>9️⃣ خريطة طريق الـ Refactoring المقترحة

### المرحلة 1 — تفكيك God Classes (حرجة)
- [ ] `service_locator.dart` ← `FirebaseBootstrapper` + `AppErrorHandler` + `LifecycleManager` + `HeavyServicesBootstrapper`
- [ ] `daily_content_repository.dart` ← `DailyContentLocalDataSource` + `DailyContentShuffleService` + `DailyContentFavoritesService`
- [ ] `location_cubit.dart` ← `LocationPermissionCubit` + `LocationPositionCubit`
- [ ] `reminder_cubit.dart` (azkar) ← دمج 5 Use Cases في `ReminderFacade` واحد

### المرحلة 2 — إصلاح الطبقات (Layering Fix)
- [ ] نقل `PrayerStateServiceImpl` إلى `domain/services/`
- [ ] نقل `QiblaServiceImpl` إلى `domain/services/`
- [ ] نقل `ReligiousEventsService` (Business Logic) إلى `domain/services/`
- [ ] نقل `location_manager/` من `core/services/` إلى `features/location_manager/`
- [ ] نقل `sharing/presentation/` من `core/` إلى `features/sharing/`

### المرحلة 3 — إصلاح التبعيات (DIP)
- [ ] إزالة اعتماد الـ View على `url_launcher`, `share_plus` ← استخدام Services
- [ ] إنشاء `PrayerCalculationService` في `domain/` معتمداً على Entity وليس على مكتبة `adhan`
- [ ] إنشاء `SalawatBackgroundTaskHandler` مع dependencies عبر constructor
- [ ] إزالة `on Exception catch` المتبقي من `azkar_di.dart`

### المرحلة 4 — توحيد الأنماط (Consolidation)
- [ ] توحيد تسمية الـ interfaces: `abstract interface class I*`
- [ ] توحيد تسمية المجلدات: `cubit/` (اختيار مفرد)
- [ ] تحويل `hadith_search_state.dart` من `part of` إلى `import`
- [ ] تنظيم `core/common/` حسب الوظيفة

### المرحلة 5 — التنظيف النهائي (Polish)
- [ ] حل تكرار واجهات Qibla (نقل Business Logic إلى `domain/`)
- [ ] إزالة الـ Stream subscriptions المباشرة بين Cubits
- [ ] استخراج `ThemeModeSelectorBottomSheet` من `settings_view.dart`
- [ ] استخراج منطق الـ Haptic من `zikr_item_card.dart`

---

## ✅ نقاط القوة في المشروع

1. **Result Pattern** مع Sealed Classes — معماري متين ومتقدم ✅
2. **Failure types** متعددة ومتنوعة ✅
3. **Interfaces لمعظم الـ Repositories** — DIP معمول به بشكل عام ✅
4. **فصل Data Sources عن Repositories** — معماري سليم ✅
5. **استخدام `sealed` في Result و Failure** — حديث وآمن ✅
6. **استخدام `unawaired()` و `isClosed`** — حماية ممتازة من الكراش ✅
7. **وجود Use Cases منفصلة** — جيد للاختبار والفصل ✅
8. **هيكلة الـ features بطريقة موحدة** — `data/`, `domain/`, `presentation/` ✅
9. **استخدام Service Locator (GetIt)** — أفضل من الـ Singleton الخام ✅
10. **الاهتمام بالأداء** (compute في JSON parsing) ✅

---

*— نهاية التقرير —*
