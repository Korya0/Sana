# Salat Ala Nabi Feature 📿

ميزة "الصلاة على النبي" هي ميزة توفر للمستخدمين إشعارات دورية للصلاة على النبي في أوقات مخصصة يتم تعيينها من قبل المستخدم.

## التغييرات المعمارية (Architectural Refactoring) 🚀

تم إعادة هيكلة هذه الميزة بالكامل لتتوافق مع معايير **Clean Architecture** و **SOLID Principles**، ومعالجة المخالفات السابقة كالآتي:

### 1. فصل الاهتمامات (Separation of Concerns)
- **استخراج طبقة Domain**: تم إنشاء `domain/entities`، و `domain/repos`، و `domain/use_cases`.
- **تنظيف الـ Cubit**: تم إزالة الاعتمادية المباشرة لـ `IAppPermissionsManager` من `ReminderCubit`. أصبحت الواجهة (UI) هي المسؤولة عن طلب إذن الإشعارات عبر الـ OS، وما إن يتم القبول حتى تعطي الأمر للـ Cubit بالتحديث.
- **إزالة تفاصيل المنصة (`kIsWeb`)**: تم إزالة التحقق من المنصة في الكيوبيت لنقله إما لطبقات الـ UI (حيث يتم طلب الصلاحيات) أو لطبقات الـ Service التي تتخذ القرار بناءً على المنصة.

### 2. تنظيف النماذج والكيوبيت (Dumb Models & Lean Cubits)
- **نقل المنطق خارج الموديل**: تم نقل الدالة التي تحسب ساعات العمل `isWithinWorkingHours` والدالة التي تنسق الوقت `_formatTime` خارج `ReminderSettingsModel`.
  - منطق حساب ساعات العمل تم استخراجه إلى UseCase خاص: `CheckWorkingHoursUseCase`.
  - تم استخراج منطق تنسيق الوقت ليصبح مقتصراً على الواجهة `WorkingHoursWidget`.
- **تقليص مهام الكيوبيت**: استُخدم `UpdateWorkingHoursUseCase` للتعامل مع منطق تحديث فترات ساعات العمل، لتقليل الضغط على الـ `ReminderCubit`.
- **التخلي عن Equatable**: تمت إضافة مقارنات مخصصة `==` و `hashCode` في جميع حالات الـ Cubit و الـ Entities.

### 3. تحسين قابلية الاختبار (Testability & Pure Logic)
- استخراج `DateTime.now()` من أعماق الدالة المعتمة `salawatCallbackDispatcher` وتمرير الوقت بشكل صريح إلى دالة التنفيذ `_executeSalawatTask` مما يسهل اختبار هذا الجزء بالكامل لاحقاً.
- التخلي عن استدعاء `loadSettings()` المباشر عبر `unawaited` بداخل مشيد الكيوبيت. أصبح استدعاؤها صريحاً عبر `init()` في واجهة المستخدم (Lifecycle Control).

### 4. الإدارة الصارمة للإشعارات واللوجر (AppLogger & Notifications)
- التخلص من الـ Magic Numbers في الإشعارات عن طريق نقلها وإعطائها ثوابت في `AppSalawatConstants`.
- التخلص من التهيئة المتكررة لخدمة الإشعارات `_notificationService.initialize()` مع كل ظهور للإشعار، وتم الاكتفاء بتهيئتها في الأماكن المناسبة عبر الـ App Initialization.
- استخدام `AppLogger.reportToFirebase` في استثناءات المهام الخلفية الحرجة و `AppLogger.localError` للأخطاء التشغيلية العادية.

## الملف المجمع (Barrel File)
تم توفير `salat_ala_nabi.dart` كبوابة وحيدة للوصول إلى الميزة، مما يحجب تفاصيل الـ Injection والواجهات الداخلية عن باقي النظام.
