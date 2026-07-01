# Teaching Prayer Feature 🕌

ميزة "تعليم الصلاة" تُقدم أقساماً ومواضيع تعليمية مفصلة عن كيفية أداء الصلاة بطريقة صحيحة معتمدة.

## التغييرات المعمارية (Architectural Refactoring) 🚀

تم تطبيق معايير **Clean Architecture** لحل العديد من المخالفات التي كانت تعيق قابلية صيانة واختبار الميزة:

### 1. إنشاء طبقة Domain
- تم فصل الـ Data Models بالكامل عن واجهة المستخدم من خلال إنشاء `TeachingPrayerSectionEntity` و `TeachingPrayerTopicEntity` و `TeachingPointEntity`.
- تم وضع الواجهة `ITeachingPrayerRepository` في `domain/repos` ليتم الاعتماد على التجريد وليس التطبيق المباشر (DIP).

### 2. تنظيف واجهة المستخدم من الـ Regex (UI Logic Extraction)
- **المشكلة السابقة**: كانت الواجهة `teaching_topic_details_bottom_sheet.dart` تحتوي على دالة `_buildHighlightedSpans` تستخدم `RegExp` لتحليل النص والبحث عن الأقواس لتلوينها.
- **الحل المطبق**: تم استخراج هذا المنطق بالكامل إلى `ParseTeachingContentUseCase` الذي يقوم بإرجاع `HighlightedSpanEntity` جاهزة للاستخدام من قبل الواجهة.
- **تحديث النموذج**: تم تحديث `TeachingPointEntity` ليحمل قائمة من `HighlightedSpanEntity` بدلاً من مجرد نص عادي.

### 3. تنظيف طبقة النماذج (Model Layer Cleanup)
- **المشكلة السابقة**: كان نموذج `TeachingPrayerTopicModel.fromJson` يستدعي `TeachingContentParser.parseContent` بشكل مباشر (اقتران قوي بين الـ Data Parsing والمنطق).
- **الحل المطبق**: 
  - إزالة `TeachingContentParser` من الموديل بالكامل.
  - تحويل وظيفة استخراج النقاط والأرقام إلى `ParseTeachingPointsUseCase`.
  - أصبح الـ Repository (`TeachingPrayerRepoImpl`) هو المسؤول عن استدعاء UseCases لتحويل النصوص القادمة من الـ JSON إلى Entities جاهزة ومحللة بالكامل.

### 4. تجريد الـ Framework Classes
- تم إزالة الاعتماد المباشر على `rootBundle` الخاص بـ Flutter داخل `TeachingPrayerLocalDataSource` واستبداله بواجهة `IAssetLoader` محقونة (Injected Interface) لتسهيل الـ Unit Testing.

### 5. دمج المكونات الضعيفة (Widget Consolidation)
- تم التخلص من ملفات `teaching_prayer_error_widget.dart` و `teaching_prayer_loading_widget.dart` ودمجها مباشرة عبر استخدام مكونات مركزية كـ `AppErrorView` و `CircularProgressIndicator` داخل الـ `TeachingPrayerView`.

### 6. المساواة اليدوية (Manual Equality)
- تم تطبيق دالتي `==` و `hashCode` يدوياً في جميع النماذج (`Models`) والكيانات (`Entities`) والحالات (`States`) بدلاً من `Equatable`.

## الملف المجمع (Barrel File)
تم إنشاء `teaching_prayer.dart` للتحكم بنقطة الدخول للميزة وعدم تعريض التركيب الداخلي לבاقي أقسام التطبيق.
