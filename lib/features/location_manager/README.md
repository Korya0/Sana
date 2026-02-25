# Location Manager Feature

تحتوي هذه الميزة على منطق إدارة الموقع الجغرافي (Location) والأذونات (Permissions) وجلب اسم المنطقة (Geocoding).

## المميزات التقنية
- **إدارة الموقع**: التحقق من حالة الـ GPS وطلب تفعيله.
- **إدارة الأذونات**: منطق متقدم لطلب إذن الموقع (Handling Denied & Permanently Denied).
- **Geocoding**: تحويل الإحداثيات إلى اسم المدينة والدولة مع دعم كامل للويب (Web Support) عبر Nominatim API.
- **تحديث تلقائي**: يعتمد `LocationNameCubit` على الـ `LocationCubit` لتحديث اسم المدينة تلقائياً عند تغير الموقع.

## الهيكل المجلدات
- `data/datasources/`:
    - `location_local_data_source.dart`: التعامل مع مكتبة `geolocator`.
    - `location_remote_data_source.dart`: التعامل مع الـ Geocoding (موبايل وويب).
- `data/repositories/`:
    - `location_repository.dart`: وسيط بين الـ DataSources والـ Presentation مع معالجة الأخطاء باستخدام `Either`.
- `presentation/controller/`:
    - `location_permission/`: المسؤول عن طلب الأذونات وحالة الموقع.
    - `location_name/`: المسؤول عن جلب اسم المنطقة الحالي.
- `presentation/widgets/`:
    - `location_guard.dart`: `Widget` يحمي الشاشات التي تحتاج موقع ويطلب الإذن أو تفعيل الموقع قبل الدخول.

## ملاحظات للمطورين
- عند استخدام `LocationGuard` في أي شاشة، تأكد أن الـ `LocationCubit` موجود فوقه في الـ `Widget Tree`.
- ميزة الـ Geocoding في الويب تستخدم `Nominatim` ولا تحتاج API Key، ولكن يجب مراعاة حدود الاستخدام (Rate Limiting).
