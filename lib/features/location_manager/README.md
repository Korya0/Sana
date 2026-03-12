# 📍 Location Manager Feature

ميزة **إدارة الموقع** هي الطبقة المركزية لكل عمليات الـ GPS في التطبيق. تدير التحقق من الإذن، تفعيل الخدمة، وحفظ إحداثيات المستخدم. تُستخدم من قِبل `Qibla`, `Prayer Times`, وأي ميزة تحتاج موقعاً.

## 🚀 المميزات الرئيسية
- التحقق من تفعيل GPS وإذن الوصول للموقع.
- طلب إذن الموقع والتعامل مع كافة حالاته (Granted, Denied, PermanentlyDenied).
- حفظ الإحداثيات في SharedPreferences للوصول السريع.
- تحديث صامت (Silent Update) للموقع عند وجود موقع مخزن.
- جلب اسم المدينة والدولة (Reverse Geocoding).
- `LocationGuard` Widget يحمي أي صفحة تحتاج موقعاً.

## 🏗 الهيكل المعماري

```
location_manager/
├── data/
│   ├── constants/    ← LocationApiConstants (مفاتيح lat/lng)
│   ├── datasources/
│   │   ├── location_local_data_source.dart  (Geolocator)
│   │   └── location_remote_data_source.dart (Geocoding API)
│   └── repositories/ ← ILocationRepository + LocationRepository
└── presentation/
    ├── controller/
    │   ├── location_permission/ ← LocationCubit + LocationState (part of)
    │   └── location_name/       ← LocationNameCubit + LocationNameState (part of)
    └── widgets/
        └── location_guard.dart  ← الحارس الشامل للصفحات
```

## 📦 الـ States (Sealed Classes — Manual)

```dart
abstract class LocationState
  ├── LocationInitial
  ├── LocationLoading
  ├── LocationSuccess            { message }
  ├── LocationNeedsServiceEnable { message }
  ├── LocationNeedsPermission    { message }
  ├── LocationDisabled           { message }
  ├── LocationPermissionDenied   { message }
  ├── LocationPermissionPermanentlyDenied
  └── LocationError              { message }
```

## 🛡 نمط LocationGuard
`LocationGuard` هو Widget-Orchestrator يستخدم `BlocListener` لعرض Bottom Sheets تلقائياً بناءً على الـ State:
- يدعم الرجعة المنظمة عند الرفض (`onClose` callback).
- يدعم تحديث الموقع عند استعادة التطبيق (LifecycleObserver).
- يمنع عرض أكثر من Bottom Sheet في نفس الوقت (`_isBottomSheetShown`).

## ⚙️ الـ DI
| الكلاس | النوع | السبب |
|---|---|---|
| `ILocationRepository` | `LazySingleton` | مشترك بين Cubits متعددة |
| `LocationCubit` | `LazySingleton` | مشترك في كامل التطبيق |
| `LocationNameCubit` | `LazySingleton` | يستمع لـ LocationCubit stream |
