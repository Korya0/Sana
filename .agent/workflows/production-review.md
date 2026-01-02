---
description: Production Code Review and Cleanup Workflow
---

# Production Code Review - مراجعة الكود للـ Production

هذا الملف يوثق الخطوات اللازمة للتأكد من جاهزية الكود للـ Production.

## ✅ الخطوات المكتملة

### 1. دمج ملفات Constants (تم)

- تم دمج `AppSpacing` و `AppStrings` في `app_constants.dart`
- تم تحديث جميع الـ imports

### 2. إعادة هيكلة Force Update (تم)

- تم نقل جميع ملفات Force Update إلى `lib/core/services/force_update/`
- الملفات الجديدة:
  - `force_update_service.dart`
  - `force_update_cubit.dart`
  - `force_update_state.dart`
  - `update_config_model.dart`

### 3. تحديث Documentation (تم)

- تم إزالة Firebase من Technology Ecosystem

---

## ⚠️ ملفات يجب حذفها يدوياً

// turbo-all

### الملفات القديمة بعد إعادة الهيكلة:

```powershell
# حذف ملفات Constants القديمة
Remove-Item "lib/core/constants/app_spacing.dart"
Remove-Item "lib/core/constants/appstrings.dart"

# حذف ملفات Force Update القديمة
Remove-Item "lib/core/services/force_update_service.dart"
Remove-Item "lib/core/logic" -Recurse
Remove-Item "lib/core/models" -Recurse

# حذف ملفات Report الفارغة
Remove-Item "lib/features/report/model" -Recurse
```

---

## 📋 هيكل المشروع المحدث

```
lib/
├── core/
│   ├── common/
│   │   ├── animations/
│   │   └── widgets/
│   ├── constants/
│   │   ├── app_assets.dart
│   │   └── app_constants.dart  ← (يحتوي AppConstants, AppSpacing, AppStrings)
│   ├── di/
│   ├── error/
│   ├── routing/
│   ├── services/
│   │   ├── date_gregorian_and_hijri/
│   │   ├── force_update/  ← (مجلد جديد منظم)
│   │   │   ├── force_update_cubit.dart
│   │   │   ├── force_update_service.dart
│   │   │   ├── force_update_state.dart
│   │   │   └── update_config_model.dart
│   │   ├── location/
│   │   ├── sharedpref/
│   │   └── share_service.dart
│   ├── theme/
│   └── utils/
└── features/
    ├── asma_ul_husna/
    ├── azkar/
    ├── daily_content/
    ├── home/
    ├── prayer/
    ├── qibla/
    ├── quran/
    ├── report/
    │   ├── data/
    │   └── presentation/
    ├── salat_ala_Nabi/
    ├── splash/
    ├── tazkiyah/  ← (فارغة - يمكن إزالتها إذا لم تكتمل)
    └── teaching_prayer/
```

---

## 🔍 للتحقق من صحة التغييرات

```powershell
flutter analyze
flutter build apk --release
```
