# 🕋 ميزة القبلة (Qibla Feature)

## 📌 نظرة عامة
ميزة القبلة هي المسؤولة عن توجيه المستخدم نحو الكعبة المشرفة بدقة، وتدعم عرض البوصلة الحية (Compass Mode) وعرض الخريطة التفاعلية (Map Mode). تمت إعادة هيكلة هذه الميزة بشكل كامل لتتوافق مع معمارية Clean Architecture، ومبادئ الـ DIP و SOLID.

## 🏗 البنية المعمارية (Clean Architecture)

- **Domain Layer**:
  - `entities`: تحتوي على كائنات نقية مستقلة تمامًا (لا تعتمد على `equatable`) وتحتوي على دوال المقارنة يدوياً `==` و `hashCode`.
  - `repos`: يحتوي على `IQiblaRepository` كموجه لجميع متطلبات الـ Cubit.
  - `use_cases`: تم تنظيف `GetQiblaDirectionUseCase` وإزالة التعقيدات مثل الـ IIFE ليصبح مقروءًا وأسهل في الاختبار. وتم تمرير كلاً من الـ Service والـ Repository في `GetQiblaCompassStreamUseCase`.

- **Data Layer**:
  - `datasources`: يضم `IQiblaLocalDataSource` لعزل استدعاءات خارجية مثل `FlutterCompass.events` والتخزين المحلي (SharedPreferences).
  - `repos`: يحتوي على تنفيذ الـ Repository `QiblaRepoImpl` حيث تم نقل جميع النصوص الصلبة والتصريحات الخارجية للتعامل مع الـ Failures بدلًا من الـ Strings المباشرة.

- **Presentation Layer**:
  - **الكيوبيت (Cubit)**: الـ `QiblaCubit` يعتمد فقط على الـ Repositories والـ UseCases ولا يحتوي على أي مراجع لحزم مثل `flutter_compass`.
  - **الواجهة (Widgets)**: تم إصلاح واجهة الخريطة والبوصلة لمنع إعادة رسم المستشعرات في `build` وتأخير الاستدعاء بـ `addPostFrameCallback`. تم تأكيد تخزين الرسومات في الذاكرة وعدم رسم البوصلة عبثاً عبر إصلاح `shouldRepaint`.

## ⚡️ أبرز التحسينات
- إزالة `equatable` والالتزام بطلب المستخدم.
- عزل إنشاء الـ Stream تماماً من الـ `build` ونقله لـ `StatefulWidget` في `qibla_compass_stream_widget.dart`.
- إضافة اللوجر (`AppLogger.error`) بشكل دقيق لضمان الإبلاغ الصحيح للـ Firebase عند أخطاء الموقع وحساسات الأجهزة.
- تنظيف شامل للملفات المهجورة.
