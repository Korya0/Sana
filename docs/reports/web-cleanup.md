# تقرير تنظيف الويب + مراجعة kIsWeb

> **الحالة:** ✅ تم تنفيذ الحذف (مع تأجيل تعديل المستندات بناءً على طلبك).
> **الفرع الحالي:** `refactor/folder-structure` — لم يتم عمل commit.
> **الهدف:** حذف أي نشر للويب (Vercel وغيره) نهائيًا، مع الإبقاء على فولدر `web/` + `device_preview` لتشغيل المعاينة بدل الإميلاتور.

---

## 0) اللي اتنفّذ فعليًا

| # | الإجراء | المسار | النوع |
|---|---|---|---|
| 1 | **حذف** | `vercel.json` (root) | إعداد Vercel |
| 2 | **حذف** | `web/vercel.json` | إعداد Vercel |
| 3 | **حذف** | `.github/workflows/web_deploy.yml` | GitHub Actions (Web Deploy) |
| 4 | **تعديل** | `.gitignore` | إزالة سطر `.vercel` |
| 5 | **تعديل** | `lib/core/constants/app_links.dart` | حذف `webApp` + `storeLink` يرجّع `playStore` دائمًا |
| 6 | **تعديل** | `lib/features/settings/presentation/cubits/settings_cubit.dart` | نص المشاركة بقى يستخدم `shareAppText` دائمًا |

> `git status` بعد التعديل:
> ```
>  D .github/workflows/web_deploy.yml
>  M .gitignore
>  M lib/core/constants/app_links.dart
>  M lib/features/settings/presentation/cubits/settings_cubit.dart
>  D vercel.json
>  D web/vercel.json
> ?? WEB_CLEANUP_REPORT.md
> ```

---

## 1) ملخّص سريع

| البند | النتيجة |
|---|---|
| نشر الويب (Vercel) في الكود/الإعدادات | ✅ **اتشال بالكامل** (فاضل مراجع في المستندات فقط) |
| فولدر `web/` | ✅ **مُبقى** (`index.html`, `manifest.json`, `icons/`, `favicon.*`) |
| `device_preview` | ✅ **مُبقى** (مفعّل على الويب في وضع التصحيح فقط) |
| فحص `kIsWeb` | 31 موضعًا في 21 ملفًا (تفاصيل تحت) |
| Firebase Hosting | غير مستخدم أصلًا |
| Shorebird (OTA) | للموبايل فقط — مُبقى |

---

## 2) ملفات نشر الويب

| # | المسار | الوظيفة السابقة | الحالة |
|---|---|---|---|
| 1 | `vercel.json` (root) | rewrites لكل المسارات إلى `index.html` | ✅ **محذوف** |
| 2 | `web/vercel.json` | نفس الإعداد داخل `web/` | ✅ **محذوف** |
| 3 | `.github/workflows/web_deploy.yml` | بناء الويب + رفعه على Vercel (`VERCEL_TOKEN`, `VERCEL_ORG_ID`, `VERCEL_PROJECT_ID`) | ✅ **محذوف** |
| 4 | `.gitignore` → `.vercel` | تجاهل مجلد Vercel CLI المحلي | ✅ **اتشال** |

### مراجع نشر في الكود/المستندات

| # | المسار | التفصيل | الحالة |
|---|---|---|---|
| 5 | `lib/core/constants/app_links.dart` | كان فيه `webApp = 'https://sana0.vercel.app/'` و `storeLink` يرجّعه على الويب | ✅ **اتصلح** — `webApp` اتحذف و `storeLink` بقى `=> playStore` |
| 6 | `lib/features/settings/presentation/cubits/settings_cubit.dart` | كان يستخدم `shareWebAppText(AppLinks.webApp)` على الويب | ✅ **اتصلح** — بقى `shareAppText(AppLinks.storeLink)` |
| 7 | `README.md` (أسطر 33–35) | شارة "Website" تشير إلى `sana0.vercel.app` | ⏸️ **مؤجّل** (بناءً على طلبك) |
| 8 | `PROJECT_STRUCTURE.md` (أسطر 958، 1212) | يذكر "Web … with Vercel deployment config" | ⏸️ **مؤجّل** |
| 9 | `.agents/PROJECT_CONTEXT.md` (أسطر 17، 146) | يذكر Web كمنصة + "Web build configurations" | ⏸️ **مؤجّل** |

---

## 3) ما يجب الإبقاء عليه (لا يُحذف)

| العنصر | السبب |
|---|---|
| فولدر `web/` بكل محتوياته (`index.html`, `manifest.json`, `icons/`, `favicon.*`) | مطلوب لتشغيل `flutter run -d chrome` والمعاينة |
| `device_preview` dependency + غلاف `DevicePreview` في `lib/main.dart:40` | تشغيل المعاينة على الويب بدل الإميلاتور |
| `android/`, `ios/` + Fastlane + `shorebird.yaml` | النشر الرسمي للموبايل (خارج نطاق الويب) |
| `firebase.json` | إعداد FlutterFire لـ Android فقط — **لا يوجد hosting** |

---

## 4) فحص `kIsWeb` — كل المواضع

**الإجمالي:** 31 موضعًا في 21 ملفًا (داخل `lib/` فقط، ولا يوجد أي استخدام في `test/`).

### التصنيف:
- 🔴 **إخفاء/تعطيل ميزة عن الويب**
- 🟡 **سلوك مختلف حسب المنصة**
- ⚪ **تقني/تحت الغطاء**
- 🎨 **تجميلي**

| # | الملف : السطر | الكود | ماذا يفعل / يخفي | التصنيف |
|---|---|---|---|---|
| 1 | `lib/main.dart:40` | `kIsWeb && kDebugMode` | يلفّ التطبيق بـ `DevicePreview` على الويب في وضع التصحيح | 🎨 (أداة تطوير — يُبقى) |
| 2 | `lib/features/sharing/presentation/helpers/app_share.dart:25` | `delay = kIsWeb ? 500ms : 100ms` | تأخير أطول لالتقاط صورة المشاركة على الويب | ⚪ توقيت |
| 3 | `lib/features/settings/presentation/cubits/settings_cubit.dart:15` | `isRatingSupported: !kIsWeb` | **يعطّل** تقييم التطبيق على الويب | 🔴 تعطيل |
| 4 | `lib/features/settings/presentation/cubits/settings_cubit.dart:16` | ~~`shareText: kIsWeb ? shareWebAppText(...) : ...`~~ | **اتصلح**: بقى نص مشاركة موحّد (بدون رابط الويب) | ✅ تم |
| 5 | `lib/features/location_manager/data/repos/location_repo_impl.dart:176` | `if (kIsWeb) { remote } else { native }` | اختيار مصدر الـ geocoding حسب المنصة | 🟡 سلوك |
| 6 | `lib/features/location_manager/data/data_sources/local/location_local_data_source.dart:55` | `if (kIsWeb) return false;` | فتح إعدادات الموقع **لا يعمل** على الويب | 🔴 تعطيل |
| 7 | `lib/features/location_manager/data/data_sources/local/location_local_data_source.dart:75` | `if (kIsWeb) return null;` | **لا يوجد** "آخر موقع معروف" على الويب | 🔴 تعطيل |
| 8 | `lib/features/salat_ala_nabi/presentation/widgets/notification_and_enable_salat_alarm_toggle_widget.dart:29` | `if (kIsWeb) return;` | مفتاح تنبيه "الصلاة على النبي" **لا يفعل شيئًا** على الويب | 🔴 تعطيل |
| 9 | `lib/features/home/presentation/widgets/sections/home_features_category_section.dart:49` | `isRestricted: kIsWeb` | كارت "الصلاة على النبي" يظهر **مقيّد/مقفول** على الويب | 🔴 إخفاء |
| 10 | `lib/features/qibla/presentation/cubits/qibla_cubit.dart:45` | `if (kIsWeb) return null;` | **لا يوجد** stream للبوصلة على الويب | 🔴 تعطيل |
| 11 | `lib/features/qibla/presentation/cubits/qibla_cubit.dart:50` | `if (kIsWeb) return QiblaMode.map;` | يفرض **وضع الخريطة** على الويب | 🟡 سلوك |
| 12 | `lib/features/qibla/presentation/cubits/qibla_cubit.dart:58` | `if (kIsWeb) return;` | **يمنع** تبديل وضع القبلة على الويب | 🔴 تعطيل |
| 13 | `lib/features/qibla/data/data_sources/qibla_local_data_source.dart:38` | `if (kIsWeb) return null;` | **لا يوجد** بوصلة (compass) على الويب | 🔴 تعطيل |
| 14 | `lib/features/prayer/presentation/widgets/header/home_prayer_loaded.dart:103` | `top: kIsWeb ? AppSpacing.v16 : 0` | هامش علوي إضافي للويب | 🎨 تجميلي |
| 15 | `lib/features/app_update/presentation/cubits/app_update_state.dart:17` | `if (kIsWeb && !kDebugMode) return false;` | **يخفي** "يوجد تحديث متاح" على الويب | 🔴 إخفاء |
| 16 | `lib/features/app_update/presentation/cubits/app_update_state.dart:27` | `if (kIsWeb && !kDebugMode) return false;` | **يخفي** "التحديث الإجباري" على الويب | 🔴 إخفاء |
| 17 | `lib/core/utils/app_logger.dart:58` | `else if (!kIsWeb && Firebase.apps.isNotEmpty)` | **لا يرسل** الأخطاء لـ Crashlytics على الويب | ⚪ تقني |
| 18 | `lib/core/di/service_locator.dart:60` | `if (!kIsWeb) setupCrashlytics()` | **يتخطّى** Crashlytics على الويب | ⚪ تقني |
| 19 | `lib/core/di/service_locator.dart:92` | `if (!kIsWeb) { lifecycleManager... }` | **يتخطّى** مدير دورة الحياة/التوقيت على الويب | ⚪ تقني |
| 20 | `lib/core/cubits/app_cubit.dart:37` | `if (!kIsWeb) WakelockPlus...` | "إبقاء الشاشة صاحية" **للموبايل فقط** | 🔴 تعطيل |
| 21 | `lib/core/cubits/app_cubit.dart:66` | `if (!kIsWeb) WakelockPlus...` | نفس السلوك عند التبديل | 🔴 تعطيل |
| 22 | `lib/core/constants/app_links.dart:14` | ~~`if (kIsWeb) return webApp;`~~ | **اتصلح**: `storeLink => playStore` دائمًا | ✅ تم |
| 23 | `lib/core/common/layout/responsive_wrapper.dart:20` | `if (!kIsWeb) return child;` | على الويب **يلفّ** المحتوى في إطار بعرض موبايل (max 500) عند الشاشات العريضة | 🎨 تجميلي |
| 24 | `lib/core/bootstrap/heavy_services_bootstrapper.dart:47` | `if (!kIsWeb) { tz, notif, workmanager }` | **يتخطّى** الخدمات الثقيلة على الويب | ⚪ تقني |
| 25 | `lib/core/bootstrap/firebase_bootstrapper.dart:35` | `if (Firebase.apps.isEmpty \|\| kIsWeb) return;` | **يتخطّى** Crashlytics على الويب | ⚪ تقني |
| 26 | `lib/core/bootstrap/app_error_handler.dart:15` | `if (!kIsWeb) { FlutterError.onError = ... }` | على الويب **لا يوجد** معالج أخطاء مخصّص | ⚪ تقني |
| 27 | `lib/core/services/device_info/device_info_service.dart:49` | `if (kIsWeb) { webBrowserInfo } else { ... }` | معلومات الجهاز من المتصفح على الويب | 🟡 سلوك |
| 28 | `lib/core/services/permissions/app_permissions_manager.dart:73` | `if (kIsWeb) return false;` | فتح إعدادات التطبيق **لا يعمل** على الويب | 🔴 تعطيل |

### ملاحظات على الفحص
- أكتر المواضع اللي "بتخفي/بتعطّل" ميزة للمستخدم على الويب: **#3, #6, #7, #8, #9, #10, #12, #13, #15, #16, #20, #21, #28**.
- الموضعان **#4 و #22** كانا الوحيدين المرتبطين مباشرة بنشر الويب → **اتصلحوا**.
- مفيش أي استخدام لـ `kIsWeb` في `test/` ولا عبر `defaultTargetPlatform` / conditional imports.

---

## 5) قرارات تم تسجيلها

1. **تنفيذ الحذف:** ✅ نعم (تم).
2. **`app_links.dart` على الويب:** يرجّع `playStore` دائمًا (تم حذف `webApp`).
3. **المستندات (`README.md`, `PROJECT_STRUCTURE.md`, `.agents/PROJECT_CONTEXT.md`):** ⏸️ مؤجّلة لإعادة البناء.

---

## 6) الحالة النهائية / المتبقّي

- [x] حذف `vercel.json` (root)
- [x] حذف `web/vercel.json`
- [x] حذف `.github/workflows/web_deploy.yml`
- [x] إزالة سطر `.vercel` من `.gitignore`
- [x] `app_links.dart` → `storeLink = playStore`
- [x] `settings_cubit.dart` → نص مشاركة موحّد
- [ ] (مؤجّل) شارة الويب + مراجع Vercel في المستندات
- [ ] (اختياري) `AppStrings.shareWebAppText` في `lib/core/constants/app_strings.dart:337` بقى **غير مستخدم** — ينفع يتحذف
- [ ] لم يتم عمل **commit** — التعديلات في الـ working tree على فرع `refactor/folder-structure`

---

## 7) ملاحظات
- كل الحذف قابل للرجوع عبر git لأن الملفات كانت متتبَّعة على الفرع.
- `AppStrings.shareWebAppText` (سطر 337 في `app_strings.dart`) بقى **dead code** بعد التعديل — سِبتُه لحد ما تقرر (تفاديًا لأي تعارض).
- فولدر `web/` والمعاينة بالـ `device_preview` **لم يتأثّروا**.
