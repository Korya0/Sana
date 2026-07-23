# 📋 قرارات التصميم — Architecture Decisions

> **التاريخ:** 23 يوليو 2026  
> **الحالة:** متفق عليها وانتظار التنفيذ  
> **الفرع المستهدف:** `azkar_fature_phase_3`

---

## 1️⃣ نقل `religious_event_display_names.dart` إلى Prayer Feature

**المتفق عليه:** ✅ نعم

**التفاصيل:**
- الملف `lib/core/constants/religious_event_display_names.dart` ينقل إلى `lib/features/prayer/`
- المكان المقترح: `lib/features/prayer/domain/enums/religious_event.dart`
- `ReligiousEvent` enum و `ReligiousEventDisplayNames` class يبقوا معًا في نفس الملف
- إزالة التصدير (export) من `lib/core/constants/constants.dart`
- إضافة التصدير في Prayer feature barrel file
- تحديث الـ import في `lib/features/prayer/domain/entities/religious_event_entity.dart`

**السبب:**
- الكود مرتبط بالـ Domain الخاص بـ Prayer/Timing فقط
- لا تستخدمه أي Feature أخرى
- ينتمي لـ prayer domain logic وليس core constants

---

## 2️⃣ توحيد اللهجة في `AppStrings`

**المتفق عليه:** ✅ نعم — هينفذ

**المطلوب مناقشته (عند التنفيذ):**
- [ ] تحديد اللهجة الموحدة — الاقتراح: **الفصحى المبسطة** (Modern Simplified Fusha)
- [ ] وضع class-level doc comment في `AppStrings` يوضح معايير كتابة الـ strings الجديدة
- [ ] وضع معايير ثابتة:
  1. **ألفاظ موحدة** — استخدام كلمات ثابتة للمفاهيم المتكررة (مثلاً: "حدث خطأ" بدل التبديل بين "عذراً" و"نعتذر" و"حدث خطأ")
  2. **تجنب العامية الثقيلة** — مش هنستخدم "إيه/أيه"، "كده/كدا"، "بقى"
  3. **علامات ترقيم عربية** — استخدام علامات الترقيم العربية المناسبة
  4. **تجنب الفصحى المتقعرة** — يفضل "لم نتمكن من تحميل البيانات" بدل "تعذر تحميل البيانات"
  5. **ثبات المصطلحات الدينية** — ﷺ، صلى الله عليه وسلم، إلخ تكون موحدة
- [ ] لا يشمل ذلك تغيير strings الموجودة حالياً إلا إذا كانت متضاربة مع المعايير الجديدة

---

## 3️⃣ إعادة تنظيم مجلد `common/`

**المتفق عليه:** ✅ نعم، مع بعض الملاحظات

**الملاحظات التي تم رصدها:**
1. **تكرار `ShareCardContainer`** — موجود في:
   - `lib/core/services/sharing/presentation/share_card_container.dart`
   - `lib/features/sharing/presentation/share_card_container.dart`
   
2. **`permission_rationale_dialog.dart`** — موجود في `layout/` والأصح `overlays/dialog/`

3. **باقي التقسيم ممتاز** ولا يحتاج تغيير جوهري

**المطلوب (عند التنفيذ):**
- [ ] نقل التصدير (exports) وتوحيد `ShareCardContainer` في مكان واحد
- [ ] نقل `permission_rationale_dialog.dart` إلى `overlays/dialog/`
- [ ] تحديث الـ barrel files (`common.dart`)

---

## 4️⃣ مشكلة Firebase Timeout على الويب

**المتفق عليه:** ✅ نعم — مع تعديل معماري للحماية من الـ Hanging على الويب.

**التفاصيل (التعديل المعماري):**
- **الـ Timeout:** زيادة مدة الـ `timeout()` (مثلاً 8 ثوانٍ) بدلاً من إزالته كلياً، لحماية الويب من التعليق الأبدي (Hanging) في حال قيام الـ AdBlockers بحظر Firebase.
- **الـ Retry:** إضافة محاولة ثانية (Retry) إذا فشلت المحاولة الأولى، مع تأخير زمني (Delay) لمدة ثانية بينهما لمعالجة التذبذب السريع في الشبكة.
- **طريقة العرض في حال الفشل التام:** 
  - في `main.dart`، يتم وضع `try-catch` حول `initializeApp()`.
  - إذا فشلت التهيئة تماماً، نشغل تطبيق مصغر مؤقت `runApp(BootstrapErrorApp())` وهو عبارة عن `MaterialApp` فارغ من التبعيات (DI).
  - يعرض هذا التطبيق المصغر **`AppErrorView`** الموجود سلفاً، مع زر "إعادة المحاولة" (Retry).
  - زر إعادة المحاولة يقوم ببساطة باستدعاء دالة `main()` من جديد لبدء دورة الحياة من الصفر.

**المطلوب (عند التنفيذ كـ Feature/Fix مستقل وليس كإعادة هيكلة):**
- [ ] تعديل `FirebaseBootstrapper.initialize()` ليحتوي على Retry logic وزيادة الـ timeout.
- [ ] تعديل `main.dart` لإضافة الـ `try-catch` حول `initializeApp()`.
- [ ] إنشاء `BootstrapErrorApp` في `main.dart` لتعرض `AppErrorView` في حال فشل الـ `initializeApp()`.

---

## 5️⃣ تغيير تسمية `networking/` إلى `network/`

**المتفق عليه:** ✅ نعم

**التفاصيل:**
- `lib/core/networking/` ← `lib/core/network/`
- الاسم الأقصر والأشهر في مجتمع Flutter/Dart
- لا تغيير في المحتوى، فقط إعادة تسمية المجلد وتحديث الـ imports

**المطلوب (عند التنفيذ):**
- [ ] إعادة تسمية المجلد
- [ ] تحديث جميع الـ imports في المشروع
- [ ] تحديث الـ barrel files

---

## 6️⃣ `api_error_handler.dart` — التعامل مع الرسائل الإنجليزية

**المتفق عليه:** ✅ نعم — الرسائل الإنجليزية تمر عبر `FailureMapper` فقط

**التفاصيل:**
- الرسائل الإنجليزية في `api_error_handler.dart` (مثل `'No internet connection'`) هي **قيم افتراضية تقنية** فقط
- لا تظهر للمستخدم مباشرة — تمر عبر `FailureMapper.mapFailureToMessage()`
- الخطر الوحيد: لو أي كود استخدم `failure.message` مباشرة بدلاً من `FailureMapper`

**المطلوب (عند التنفيذ):**
- [ ] المراجعة للتأكد من أن جميع الـ Repositories تستخدم `FailureMapper`
- [ ] إضافة `@override` للـ `toString()` في كل `Failure` subclass لمنع تسرب الإنجليزية

---

## 7️⃣ مجلدات `error/` و `network/` — مناسبة كما هي

**المتفق عليه:** ✅ نعم — لا دمج مع `services/`

**التفاصيل:**
- `lib/core/error/` = Domain error types — مكانها صحيح
- `lib/core/network/` = Network layer — مكانها صحيح
- `lib/core/services/` = Infrastructure services — مكانها صحيح
- هذا التقسيم يتبع Clean Architecture ولا يحتاج تغيير

---

## 8️⃣ إعادة تنظيم Sharing Service

**المتفق عليه:** ✅ نعم — بشدة

**المشكلة الحالية:**
```
lib/core/services/sharing/ ← يحتوي على logic + presentation (خطأ)
lib/features/sharing/      ← يحتوي على presentation فقط
```
**تكرار:** `ShareCardContainer`, `AppClipboard`, `AppShare`, `WidgetToImageHelper` موجودة في كلا المكانين.

**الهيكل المستهدف:**
```
lib/core/services/sharing/          ← LOGIC + MODELS فقط
├── index.dart                       ← يصدّر logic و models فقط
├── logic/
│   ├── i_share_service.dart
│   └── share_service.dart
└── models/
    └── share_config.dart

lib/features/sharing/               ← PRESENTATION فقط
├── presentation/
│   ├── app_info_share.dart
│   ├── combined_share_copy_button.dart
│   ├── share_card_container.dart
│   └── utils/
│       ├── app_clipboard.dart
│       ├── app_share.dart
│       └── widget_to_image_helper.dart
```

**المطلوب (عند التنفيذ):**
- [ ] حذف `lib/core/services/sharing/presentation/` بالكامل
- [ ] تحديث `lib/core/services/sharing/index.dart` ليصدّر logic و models فقط
- [ ] التأكد من أن `lib/features/sharing/` يغطي كل الـ presentation widgets
- [ ] تحديث جميع الـ imports في المشروع اللي تشاور على `core/services/sharing/presentation/`
- [ ] حذف أي ملفات مكررة بعد التحقق من الـ imports

---

## 9️⃣ مراجعة تسميات مجلد `services/`

**المتفق عليه:** ✅ نعم — معظمها مناسب، مع ملاحظات بسيطة

| اسم الفولدر | التقييم | الإجراء |
|-------------|---------|---------|
| `analytics/` | ✅ ممتاز | لا تغيير |
| `assets/` | 🟡 مقبول | ترك كما هو |
| `background/` | ⚠️ غامض | تغيير إلى `background_tasks/` أو `work_manager/` |
| `database/` | ✅ ممتاز | لا تغيير |
| `device_info/` | ✅ ممتاز | لا تغيير |
| `haptic/` | ✅ ممتاز | لا تغيير |
| `local_storage/` | ✅ ممتاز | لا تغيير |
| `notification/` | ✅ ممتاز | لا تغيير |
| `permissions/` | ✅ ممتاز | لا تغيير |
| `sharing/` | 🟡 معاد تنظيمه | تمت مناقشته في النقطة 8 |
| `time/` | 🟡 غامض | تغيير إلى `timer/` |
| `url_launcher/` | ✅ ممتاز | لا تغيير |

**المطلوب (عند التنفيذ):**
- [ ] إعادة تسمية `background/` إلى `background_tasks/` (أو `work_manager/`)
- [ ] إعادة تسمية `time/` إلى `timer/`
- [ ] تحديث جميع الـ imports

---

## 🔟 مجلد `utils/` — نقل الـ feature-specific utilities

**المتفق عليه:** ✅ نعم — معظمها Shared، وما هو Feature-Specific ينقل

**التفاصيل:**
- `app_logger.dart` ← ✅ Shared (يبقى)
- `app_validators.dart` ← ✅ Shared (يبقى)
- `bloc_observer.dart` ← ✅ Shared (يبقى)
- `context_extension.dart` ← ✅ Shared (يبقى)
- `date_time_provider.dart` ← ✅ Shared (يبقى)
- `responsive_extension.dart` ← ✅ Shared (يبقى)
- `app_date_formatter.dart` ← ✅ Shared (يبقى)
- `version_utils.dart` ← ✅ Shared (يبقى)
- `app_feedback.dart` ← 🟡 يحتاج مراجعة — لو Feature-specific ينقل

**المطلوب (عند التنفيذ):**
- [ ] مراجعة `app_feedback.dart` — هل هو خاص بـ Feedback feature فقط؟
- [ ] إذا كان خاصًا، ينقل إلى `lib/features/feedback/`
- [ ] الباقي يبقى في `lib/core/utils/` كما هو

---

## 🗺️ خريطة الطريق — ترتيب التنفيذ المقترح

| الأولوية | النقطة | التعقيد | التأثير |
|----------|--------|---------|---------|
| 1 | **8️⃣ Sharing** (حذف التكرار) | 🟡 متوسط | إزالة تكرار + تحسين النظافة |
| 2 | **7️⃣ إعادة تسمية `network/`** | 🟢 سهل | تغيير مسار + imports فقط |
| 3 | **9️⃣ إعادة تسمية services** | 🟢 سهل | تغيير مسار + imports فقط |
| 4 | **1️⃣ نقل `religious_event_display_names`** | 🟢 سهل | نقل ملف + تحديث import |
| 5 | **4️⃣ Firebase Retry** (باستخدام AppErrorView الموجود) | 🟡 متوسط | تغيير في bootstrapper + main.dart |
| 6 | **3️⃣ تنظيم `common/`** | 🟢 سهل | نقل ملفين + تحديث barrel |
| 7 | **6️⃣ الرسائل الإنجليزية** | 🟢 سهل | إضافة @override toString |
| 8 | **🔟 نقل feature-specific utils** | 🟢 سهل | مراجعة + نقل |
| 2 | **2️⃣ توحيد اللهجة + معايير الكتابة** | 🔴 معقد | وضع class comment + مراجعة |

---

> **ملاحظة:** هذا الملف يمثل التزامات فنية فقط — لا تغيير في الكود حتى يتم الاتفاق على بدء التنفيذ.
