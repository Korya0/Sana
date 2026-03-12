# 📖 Quran Feature

ميزة **القرآن الكريم** هي Wrapper نظيف لمكتبة `quran_library` الخارجية. تتولى تهيئة المكتبة وعرضها بالتصميم الموحد للتطبيق.

## 🚀 المميزات الرئيسية
- قراءة القرآن الكريم كاملاً.
- تصفح بالسور والأجزاء والأحزاب.
- تمييز الآيات وأيقونات التجويد.
- تصميم موحد (Dark Mode, Gold Accents).

## 🏗 الهيكل المعماري

```
quran/
└── presentation/
    ├── routes/ ← QuranRoutes
    └── views/  ← QuranView (FutureBuilder + QuranLibraryScreen)
```

> **ملاحظة:** لا يوجد Data Layer أو Cubit — هذا صحيح تماماً لأن الميزة هي Wrapper خالصة للمكتبة الخارجية.

## 🎨 رموز التصميم
- **Background:** `AppColors.quranBackground` (`0xFF161a1d`) — لون مخصص للقرآن.
- **Icons & Accents:** `AppColors.gold`.
- **Text:** `AppColors.textWhite`.

## 📝 نمط التهيئة
```dart
// يُهيأ مرة واحدة فقط عند فتح الصفحة
_initFuture = _initializeQuran(); // → QuranLibrary.init()
```
- إذا نجح: تظهر `QuranLibraryScreen`.
- إذا فشل: تظهر `AppErrorWidget` مع إمكانية إعادة المحاولة.
