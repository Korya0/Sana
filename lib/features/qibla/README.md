# 🧭 Qibla Feature

ميزة **اتجاه القبلة** تحسب اتجاه الكعبة المشرفة والمسافة إليها بناءً على موقع المستخدم، وتعرضها عبر بوصلة متحركة تعتمد على حساس المغناطيسية.

## 🚀 المميزات الرئيسية
- حساب اتجاه القبلة باستخدام خوارزمية Haversine الجغرافية.
- حساب المسافة للكعبة بدقة عالية.
- بوصلة متحركة تستجيب لحساس المغناطيسية في الوقت الفعلي.
- Skeletonizer أثناء التحميل.
- دليل استخدام تفاعلي (Help Dialog).

## 🏗 الهيكل المعماري

```
qibla/
├── data/
│   ├── datasources/  ← QiblaLocalDataSource (يقرأ lat/lng من SharedPref)
│   ├── models/       ← QiblaModels
│   ├── services/     ← QiblaService (حسابات Haversine - منطق عزل)
│   ├── qibla_constants.dart  ← إحداثيات الكعبة
│   └── repositories/ ← IQiblaRepository + QiblaRepository
└── presentation/
    ├── controller/ ← QiblaCubit + QiblaState (Sealed, part of)
    ├── views/      ← QiblaView
    └── widgets/
        ├── compass/  ← CompassArrow, CompassBackgroundPainter, CompassKaabaIcon, QiblaCompass
        ├── hint/     ← QiblaHintMessage, QiblaMessageConfig
        ├── loaded/   ← QiblaCompassStream, QiblaContentLayout, QiblaViewLoadedWidget
        ├── qibla_header_info.dart
        ├── qibla_help_dialog.dart
        └── skeletonizer_qiblaview.dart
```

## ⚡ نقطة قوة معمارية
دوال Repository هنا **synchronous** (ليست async) وهذا صحيح تماماً — لأن البيانات مقروءة من LocalStorageService(ذاكرة) وليس من شبكة أو ملف.

## 🧮 QiblaService — عزل المنطق الحسابي ✅
```
QiblaService.calculateQiblaDirection(lat, lng) → double (bearing)
QiblaService.calculateDistance(lat1, lng1, lat2, lng2) → double (km)
```
المنطق الحسابي معزول في `QiblaService` ولا ينتمي للـ Repository ولا الـ Cubit.

## 📦 الـ State (Sealed Classes — Manual)
```dart
abstract class QiblaState
  ├── QiblaInitial
  ├── QiblaLoading
  ├── QiblaLoaded  { qiblaDirection, distanceToKaaba }
  └── QiblaError   { message }
```

## ⚙️ الـ DI
| الكلاس | النوع | السبب |
|---|---|---|
| `IQiblaRepository` | `LazySingleton` | يعتمد على LocalStorageService|
| `QiblaCubit` | `Factory` | يُنشأ مع كل فتح للصفحة |
