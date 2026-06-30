# App Update Architecture Violations

بناءً على الفحص المعماري الدقيق والشامل لقسم `app_update` مقابل قواعد `ARCHITECTURE_RUBRIC.md`، تم رصد المخالفات التالية (مع استثناء غياب ملفات التصدير):

## 1. المكان الخاطئ للمجلد (Module 6: Feature-based Structure)
- **القاعدة:** `Is the feature isolated in lib/features/?`
- **المخالفة:** المجلد متواجد في `lib/core/services/` رغم احتوائه على طبقة عرض (`presentation`) متكاملة تشمل (Widgets و Cubit).
- **السبب:** مجلد `core/services` مخصص للخدمات التي لا تحتوي على UI. يجب نقل الميزة إلى `lib/features/app_update`.

## 2. تكرار وتداخل في التسمية والهيكلة (Module 6: Naming & Organization)
- **المخالفة:** وجود المسار: `core/services/app_update/data/services/app_update_service.dart`.
- **السبب:** وجود مجلد `services` داخل مجلد `data` المتواجد أساساً بداخل مجلد `services` يتسبب بتكرار غير منطقي.

## 3. غياب المساواة (Equality) في الـ State والـ Model (Module 9 & Module 13: Rebuild Awareness)
- **القاعدة:** `Are we preventing unnecessary paints/layouts?` و `Is the state clearly modeled?`
- **المخالفة:** الـ classes الخاصة بـ `AppUpdateState` و `UpdateConfigModel` لا ترث من `Equatable` ولا تدعم مقارنة القيم (Value Equality).
- **السبب:** هذا سيجعل `BlocBuilder` و `buildWhen` في واجهة `UpdateOverlay` يقومان بإعادة البناء (Rebuild) بناءً على الـ (Reference Equality) مما يؤدي إلى Rebuilds غير ضرورية ويؤثر على الأداء.

## 4. تسرب منطق البيانات (Data Logic) إلى الـ Cubit (Module 7: Layer Responsibilities)
- **القاعدة:** `Is the boundary between layers respected?`
- **المخالفة:** الـ `AppUpdateCubit` يقوم بجلب الـ Remote Config ثم يقوم بنفسه بتوجيه أمر `await _repository.cacheConfig(remoteConfig)` ليتم تخزينها.
- **السبب:** عملية التخزين المؤقت (Caching) بعد جلب البيانات يجب أن تُدار داخلياً في الـ Repository، ولا يجب أن يعلم الـ Cubit بوجود "Cache" من الأساس، وظيفته فقط طلب البيانات وعرضها.

## 5. الخلط بين الـ Smart و الـ Dumb Widgets (Module 10: Widget Composition)
- **القاعدة:** `Are UI components (Dumb) separated from logic components (Smart)?`
- **المخالفة:** الـ Widgets الخاصة بالعرض مثل `ForceUpdateOverlay` تقوم بطلب الـ Cubit مباشرة: `context.read<AppUpdateCubit>().launchUpdateUrl()`.
- **السبب:** من الأفضل جعل هذه الـ Widgets "غبية" (Dumb) تستقبل دالة `VoidCallback onUpdatePressed` كـ parameter، ويكون `UpdateOverlay` (الـ Smart Widget) هو المسؤول عن تمرير الدالة لها، مما يجعل مكونات الـ UI قابلة لإعادة الاستخدام بسهولة بمعزل عن الـ Cubit.

---
**التوصية النهائية للتعديل:**
1. نقل الميزة إلى `lib/features/app_update/`.
2. إضافة `Equatable` لـ States و Models.
3. نقل منطق الـ Caching داخل دالة الجلب في الـ Repository.
4. فصل الاعتمادية على الـ Cubit داخل الـ Dumb Widgets.
