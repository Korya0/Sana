# 🔄 مزية تحديث التطبيق (app_update)

## نظرة عامة

مزية `app_update` هي المسؤولة عن **إدارة تحديثات التطبيق** بشكل ذكي. تتصل بـ Firebase Remote Config لجلب معلومات الإصدار الأحدث، وتقارنه بالإصدار المثبت على جهاز المستخدم، ثم تعرض إشعار التحديث بأحد شكلين:
- **إجباري**: يمنع المستخدم من استخدام التطبيق حتى يحدّث.
- **اختياري**: يعرض بانر في أسفل الشاشة يمكن تجاهله.

---

## 📁 هيكل الملفات

```
app_update/
├── data/
│   ├── models/
│   │   └── update_config_model.dart        ← نموذج إعدادات التحديث
│   ├── repositories/
│   │   └── app_update_repository.dart      ← الريبوزيتوري (abstract + impl)
│   └── services/
│       └── app_update_service.dart         ← الخدمة (Firebase + Cache)
└── presentation/
    ├── controller/
    │   ├── app_update_cubit.dart            ← المتحكم
    │   └── app_update_state.dart            ← الحالة + منطق المقارنة
    └── widgets/
        ├── update_overlay.dart              ← الويدجت الموجّه (Router)
        ├── force_update_overlay.dart        ← واجهة التحديث الإجباري
        ├── optional_update_banner.dart      ← بانر التحديث الاختياري
        └── update_icon.dart                 ← أيقونة التحديث
```

---

## 📦 طبقة البيانات (Data Layer)

### `update_config_model.dart` — نموذج إعدادات التحديث

يحمل كل المعلومات التي يُرسلها Firebase Remote Config عن التحديث.

| الخاصية | النوع | الوصف |
|---------|------|-------|
| `latestVersion` | `String` | الإصدار الأحدث (مثال: `"2.0.0"`) |
| `isForceUpdate` | `bool` | هل التحديث إجباري؟ |
| `updateUrl` | `String` | رابط التحديث (Google Play أو غيره) |
| `updateMessage` | `String?` | رسالة مخصصة تُعرض للمستخدم (اختيارية) |

يدعم `fromJson` لقراءة البيانات من Remote Config، و`toJson` للحفظ في SharedPreferences.

---

### `app_update_service.dart` — الخدمة

تحتوي على منطق التفاعل المباشر مع Firebase Remote Config و SharedPreferences.

#### `AppUpdateServiceImpl`:

| الدالة | الوصف |
|--------|-------|
| `getCachedConfig()` | يقرأ الإعدادات المحفوظة محلياً من SharedPreferences |
| `fetchRemoteConfig()` | يجلب الإعدادات من Firebase Remote Config ويحدها |
| `cacheConfig(config)` | يحفظ الإعدادات المُجلبة محلياً |
| `getUpdateUrl()` | يجلب رابط التحديث من Remote Config |

**إعدادات الجلب:**
- في **debug mode**: `minimumFetchInterval = 0` ← يجلب كل مرة فوراً.
- في **release mode**: `minimumFetchInterval = 1 ساعة` ← لا يُثقل Firebase.

---

### `app_update_repository.dart` — الريبوزيتوري

يضيف طبقة أمان (`try/catch`) فوق الخدمة ويُعيد النتائج كـ `Either<Failure, T>`.

| الدالة | الإرجاع | الوصف |
|--------|---------|-------|
| `getCachedConfig()` | `Either<CacheFailure, UpdateConfigModel?>` | قراءة الكاش |
| `fetchRemoteConfig()` | `Either<ServerFailure, UpdateConfigModel>` | جلب من Firebase |
| `cacheConfig(config)` | `Either<CacheFailure, void>` | حفظ في الكاش |

---

## 🧠 طبقة العرض (Presentation Layer)

### `app_update_state.dart` — الحالة ومنطق المقارنة

| الخاصية | النوع | الوصف |
|---------|------|-------|
| `currentVersion` | `String` | إصدار التطبيق المثبت (افتراضي: `"0.0.0"`) |
| `config` | `UpdateConfigModel?` | إعدادات التحديث من Remote Config |

#### الدالة المحورية `isUpdateRequired`:
```
هل isUpdateRequired = true؟ تحقق من 3 شروط:
1. المنصة ليست Web (الويب لا يحتاج تحديث إجباري)
2. الإعدادات محملة وإصدار التطبيق معروف
3. الإصدار الحالي < الإصدار الأحدث من Remote Config
```

#### آلية مقارنة الإصدارات `_isVersionLessThan`:
- تُنظّف الإصدارات من البادئات مثل `+1` أو `-alpha`.
- تُقارن رقماً رقماً: `major.minor.patch`.
- مثال: `1.2.0 < 1.3.0` → `true` → يحتاج تحديث.

---

### `app_update_cubit.dart` — المتحكم

يتهيأ تلقائياً عند إنشائه (`initialize()`) ويمر بـ3 خطوات:

```
الخطوة 1: جلب إصدار التطبيق الحالي من PackageInfo
      ↓
الخطوة 2: تحميل آخر إعدادات محفوظة من الكاش (سريع، فوري)
      ↓
الخطوة 3: جلب الإعدادات الجديدة من Firebase (أبطأ، قد يستغرق ثوانٍ)
           + حفظها في الكاش للمرة القادمة
```

**لماذا خطوتان للتحميل؟**
الكاش يُتيح عرض حالة التحديث فوراً دون انتظار الشبكة، ثم يُحدّث حين تصل البيانات الجديدة.

#### `launchUpdateUrl()`:
- يفتح رابط التحديث في المتصفح الخارجي.
- إذا لم يوجد رابط في الإعدادات، يفتح Google Play Store الافتراضي.

---

### `update_overlay.dart` — الموجّه الرئيسي

هذا الويدجت هو **حكم** يقرر أي واجهة تُعرض:

```dart
if (!state.isUpdateRequired || state.config == null)
  → SizedBox.shrink() // لا شيء يُعرض

if (config.isForceUpdate)
  → ForceUpdateOverlay() // تحديث إجباري

else
  → OptionalUpdateBanner() // بانر اختياري
```

---

### `force_update_overlay.dart` — واجهة التحديث الإجباري

تُعرض فوق الشاشة الكاملة وتمنع التفاعل مع التطبيق. تستخدم:
- **`PopScope(canPop: false)`**: يمنع الرجوع للخلف.
- **`BackdropFilter`**: يُضبّب الخلفية بـ `sigmaX/Y = 10`.
- **أيقونة التحديث** + رسالة مخصصة + **زر "حدّث الآن"**.

---

### `optional_update_banner.dart` — البانر الاختياري

بانر يظهر في أسفل الشاشة بأنيميشن سلسة:
- **Animation**: يصعد من الأسفل مع fade-in (600ms، `easeOutBack`).
- **زر ×**: يُغلق البانر للجلسة الحالية فقط (`_dismissed = true`).
- **زر "حدّث الآن"**: يفتح رابط التحديث.

---

### `update_icon.dart` — أيقونة التحديث

أيقونة دائرية بسيطة بخلفية ذهبية شفافة تحتوي على `Icons.system_update_rounded`.

---

## 🔄 تدفق البيانات الكامل

```
تشغيل التطبيق
      ↓
AppUpdateCubit.initialize():
  1. جلب إصدار التطبيق (PackageInfo)
  2. قراءة الكاش → emit(state.copyWith(config: cachedConfig))
  3. جلب Firebase → emit(state.copyWith(config: remoteConfig))
      ↓
UpdateOverlay يُراقب الحالة:
  - isUpdateRequired = false → لا شيء
  - isUpdateRequired = true + isForceUpdate = true → ForceUpdateOverlay
  - isUpdateRequired = true + isForceUpdate = false → OptionalUpdateBanner
      ↓
المستخدم ينقر "حدّث الآن":
  - launchUpdateUrl() → يفتح المتجر
```

---

## 💾 البيانات المحفوظة (SharedPreferences)

| المفتاح | النوع | الوصف |
|---------|------|-------|
| `cachedUpdateConfig` | `String` (JSON) | آخر إعدادات تحديث مُجلبة من Firebase |

---

## ☁️ Firebase Remote Config Keys

| المفتاح | النوع | الوصف |
|---------|------|-------|
| `latest_version` | String | الإصدار الأحدث للتطبيق |
| `is_force_update` | bool | هل هو إجباري؟ |
| `update_url` | String | رابط التحديث |
| `update_message` | String | رسالة مخصصة للمستخدم |

---

## 📦 المكتبات المستخدمة

| المكتبة | الغرض |
|---------|-------|
| `firebase_remote_config` | جلب إعدادات التحديث من السحابة |
| `package_info_plus` | قراءة إصدار التطبيق الحالي |
| `url_launcher` | فتح رابط المتجر في المتصفح |
| `shared_preferences` | كاش الإعدادات محلياً |
| `flutter_bloc` | إدارة الحالة |

---

## ⚠️ ملاحظات مهمة

- **الويب**: لا يظهر التحديث الإجباري على منصة الويب (`kIsWeb` → `isUpdateRequired = false` دائماً).
- **استراتيجية الكاش أولاً**: يُعرض الكاش فوراً، ثم يُحدَّث بالبيانات الجديدة من Firebase — هذا يمنع التأخير في الإظهار.
