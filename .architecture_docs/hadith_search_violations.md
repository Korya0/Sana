# سجل المخالفات المعمارية - وحدة البحث في الأحاديث (features/hadith_search)

تم تدقيق كود وحدة البحث في الأحاديث في [lib/features/hadith_search](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search) بالكامل ومقارنتها مع المعايير المعمارية للمشروع المحددة في [ARCHITECTURE_RUBRIC.md](file:///d:/flutter/flutter_Projects/muslim_app/architecture_docs/ARCHITECTURE_RUBRIC.md).

أدناه تفصيل شامل لكافة المخالفات المعمارية والبرمجية المرصودة:

---

## 📊 ملخص تنفيذي للمخالفات

| # | المخالفة | الملف/الملفات | الخطورة |
|---|----------|---------------|---------|
| H1 | Layer Violation: الـ State تستورد Data Model مباشرةً | [hadith_favorites_state.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search/presentation/cubit/hadith_favorites/hadith_favorites_state.dart) | 🔴 |
| H2 | Anti-Pattern: دالة `isFavorite` تفحص subclass من الـ base class | [hadith_favorites_state.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search/presentation/cubit/hadith_favorites/hadith_favorites_state.dart) | 🔴 |
| H3 | Missing Domain Layer: لا توجد طبقة نطاق (Domain) بالكامل | `lib/features/hadith_search/` | 🔴 |
| H4 | Broken State Equality: غياب `==` و `hashCode` في الـ States | [hadith_search_state.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search/presentation/cubit/hadith_search/hadith_search_state.dart) | 🔴 |
| H5 | BuildContext across async gap: Share بدون check | [hadith_search_share_and_favorite_buttons.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search/presentation/widgets/hadith_search_share_and_favorite_buttons.dart) | 🔴 |
| H6 | Missing Barrel File: غياب ملف التجميع والتصدير `index.dart` | `lib/features/hadith_search/` | 🔴 |
| H7 | SRP: `HadithFavoritesCubit` يطلق التحميل في الـ Constructor | [hadith_favorites_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search/presentation/cubit/hadith_favorites/hadith_favorites_cubit.dart) | 🟠 |
| H8 | Missing Equality: `HadithModel` لا يحتوي على `==` و `hashCode` | [hadith_model.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search/data/models/hadith_model.dart) | 🟠 |
| H9 | Catch Exception Only: الـ Repository يصطاد Exception فقط | [hadith_repository.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search/data/repos/hadith_repository.dart) | 🟠 |
| H10 | Layer Violation: الـ Cubit يستورد Data Model مباشرةً | [hadith_search_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search/presentation/cubit/hadith_search/hadith_search_cubit.dart) | 🟠 |
| H11 | Logic Leakage: عملية معالجة وتلوين النص HTML في الـ Cubit | [hadith_search_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search/presentation/cubit/hadith_search/hadith_search_cubit.dart) | 🟠 |
| H12 | Logic Leakage: حساب الـ Scroll Pagination في الـ View | [hadith_search_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search/presentation/views/hadith_search_view.dart) | 🟠 |
| H13 | Layer Violation: الـ View تستورد Data Model مباشرةً | [hadith_favorites_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search/presentation/views/hadith_favorites_view.dart) | 🟠 |
| H14 | Clipboard.setData بدون معالجة أخطاء أو تنبيه للمستخدم | [hadith_search_share_and_favorite_buttons.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search/presentation/widgets/hadith_search_share_and_favorite_buttons.dart) | 🟠 |
| H15 | DRY Violation: تكرار كود المقارنة للبيانات يدوياً | [hadith_favorites_repository.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search/data/repos/hadith_favorites_repository.dart) | 🟠 |
| H16 | UI State: Optimistic update بدون آلية للتراجع عند الفشل | [hadith_favorites_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search/presentation/cubit/hadith_favorites/hadith_favorites_cubit.dart) | 🟡 |
| H17 | Missing DI Module: غياب ملف/مجلد إعدادات الـ DI للميزة | `lib/features/hadith_search/` | 🟡 |

---

## 🔴 أولاً: المخالفات الحرجة (High Severity)

### H1 — Layer Violation: الـ State تستورد Data Model مباشرةً
* **الملف:** [hadith_favorites_state.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search/presentation/cubit/hadith_favorites/hadith_favorites_state.dart#L1)
* **المشكلة:** تقوم طبقة العرض (State) باستيراد واستخدام `HadithModel` الذي ينتمي لطبقة البيانات مباشرة. هذا يخرق استقلالية الطبقات المعمارية (Layer Boundaries).
* **الحل:** يجب تحويل البيانات إلى Domain Entity (مثلاً `Hadith`) في طبقة النطاق، وجعل الـ State تتعامل مع الـ Entity فقط.

### H2 — Anti-Pattern: دالة `isFavorite` تفحص subclass من الـ base class
* **الملف:** [hadith_favorites_state.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search/presentation/cubit/hadith_favorites/hadith_favorites_state.dart#L6-L13)
* **المشكلة:** الـ base class تعرف تفاصيل عن الـ subclass `HadithFavoritesLoaded` وتقوم بعمل casting لها بداخل دالة `isFavorite`. هذا انتهاك لمبادئ البرمجة كائنية التوجه (OOP) ومبدأ التجريد.
* **الحل:** نقل الدالة `isFavorite` إلى كلاس `HadithFavoritesLoaded` واستخدام pattern matching في الـ UI.

### H3 — Missing Domain Layer: لا توجد طبقة نطاق (Domain) بالكامل
* **المجلد:** `lib/features/hadith_search/`
* **المشكلة:** الميزة تفتقر بالكامل لوجود مجلد `domain/` ولا تحتوي على Use Cases أو Entities أو Repository Interfaces في طبقة مستقلة. الكيوبيت يعتمد مباشرة على Data Repos و Data Models.
* **الحل:** إنشاء طبقة `domain` وتعريف الـ Entities والـ Use Cases وواجهات المستودعات فيها.

### H4 — Broken State Equality: غياب `==` و `hashCode` في الـ States
* **الملف:** [hadith_search_state.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search/presentation/cubit/hadith_search/hadith_search_state.dart)
* **المشكلة:** كلاس `HadithSuccess` يحتوي على قائمة `List<HadithModel>` ولكنه لا يعيد تعريف `==` و `hashCode`. عند مقارنة حالتين، ستتم المقارنة بالمرجع بالذاكرة وليس بالقيم، مما يسبب Rebuilds متكررة وغير ضرورية للـ UI.
* **الحل:** استخدام حزمة `Equatable` أو `Freezed` أو إعادة كتابة `==` و `hashCode` يدوياً لضمان مقارنة القيم بشكل صحيح.

### H5 — BuildContext across async gap: Share بدون mounted check
* **الملف:** [hadith_search_share_and_favorite_buttons.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search/presentation/widgets/hadith_search_share_and_favorite_buttons.dart#L22-L28)
* **المشكلة:** يتم استخدام الـ `BuildContext` لتمرير الـ Context إلى دالة `WidgetToImageHelper.shareWidget` بعد انتهاء عملية async (`await`) دون التحقق من شرط `mounted` للـ Widget، مما يسبب كراش محتمل للتطبيق.
* **الحل:** إضافة `if (!context.mounted) return;` قبل استخدام الـ Context بعد أي `await`.

### H6 — Missing Barrel File: غياب ملف التجميع والتصدير `index.dart`
* **المجلد:** `lib/features/hadith_search/`
* **المشكلة:** لا يوجد ملف `index.dart` لتصدير العناصر العامة للميزة، مما يجبر الملفات الخارجية على استيراد الملفات الداخلية العميقة بشكل مباشر ويزيد الاقتران.
* **الحل:** إنشاء ملف `hadith_search.dart` أو `index.dart` لتصدير الـ View والـ Cubit الأساسي فقط للشركاء الخارجيين.

---

## 🟠 ثانياً: المخالفات المتوسطة (Medium Severity)

### H7 — SRP: Cubit Constructor Side-Effect
* **الملف:** [hadith_favorites_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search/presentation/cubit/hadith_favorites/hadith_favorites_cubit.dart#L9-L11)
* **المشكلة:** استدعاء دالة `loadFavorites()` في الـ Constructor يسبب side-effect مباشر يجعل اختبار الوحدة (Unit Testing) صعباً لأن البيانات يتم تحميلها تلقائياً عند إنشاء الكائن.
* **الحل:** إزالة الاستدعاء من الـ Constructor وإطلاقه خارجياً باستخدام الـ cascade operator (`..loadFavorites()`) أثناء توفير الـ Cubit في الـ Route.

### H8 — Missing Equality: `HadithModel` لا يحتوي على `==` و `hashCode`
* **الملف:** [hadith_model.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search/data/models/hadith_model.dart)
* **المشكلة:** غياب مقارنة القيم في الـ Model يمنع مقارنة الأحاديث بشكل مباشر ويعوق أداء القوائم وإعادة الرسم.
* **الحل:** إعادة تعريف `==` و `hashCode` بداخل `HadithModel`.

### H9 — Catch Exception Only: الـ Repository يصطاد Exception فقط
* **الملف:** [hadith_repository.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search/data/repos/hadith_repository.dart#L21)
* **المشكلة:** التقاط الاستثناءات يتم باستخدام `on Exception catch (e)` فقط. الأخطاء من نوع `Error` (مثل `TypeError` أو `CastError`) لن يتم اصطيادها وستسبب انهيار التطبيق.
* **الحل:** استخدام `on Object catch (e, stack)` لضمان اصطياد كل أنواع المشاكل مع تسجيلها.

### H10 — Layer Violation: الـ Cubit يستورد Data Model مباشرةً
* **الملف:** [hadith_search_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search/presentation/cubit/hadith_search/hadith_search_cubit.dart#L4)
* **المشكلة:** الـ Cubit في طبقة العرض يعتمد مباشرة على كائن `HadithModel` من طبقة البيانات.
* **الحل:** الاعتماد على الـ Domain Entity وتمريرها للـ UI.

### H11 — Logic Leakage: عملية معالجة وتلوين النص HTML في الـ Cubit
* **الملف:** [hadith_search_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search/presentation/cubit/hadith_search/hadith_search_cubit.dart#L29-L41)
* **المشكلة:** دالة `_processAhadith` تقوم بمعالجة النصوص واستخدام تعبيرات نمطية لربط وإضافة HTML tags (`<span>`) للكلمات المفتاحية بداخل الـ Cubit. منطق تعديل النصوص لا يجب أن يقع في طبقة العرض أو الكيوبيت.
* **الحل:** نقل منطق الـ Formatting والمعالجة إلى طبقة الـ Domain أو كلاس مساعد منفصل يتم استدعاؤه بشكل منظم.

### H12 — Logic Leakage: حساب الـ Scroll Pagination في الـ View
* **الملف:** [hadith_search_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search/presentation/views/hadith_search_view.dart#L35-L46)
* **المشكلة:** الـ View تقوم بحساب مسافة الـ Scroll وتحديد متى وصلنا للنهاية (`_isBottom`) لاتخاذ قرار استدعاء `loadMoreHadiths`. منطق اتخاذ القرار بالتحميل التلقائي يجب أن يُدار بالكامل داخل الـ Cubit لتسهيل اختباره.
* **الحل:** تمرير الـ Scroll events للـ Cubit وجعله هو من يحدد الحاجة للتحميل بناءً على الحالة الحالية.

### H13 — Layer Violation: الـ View تستورد Data Model مباشرةً
* **الملف:** [hadith_favorites_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search/presentation/views/hadith_favorites_view.dart#L5)
* **المشكلة:** الـ View تنشئ قائمة محلية وتعرفها كـ `List<HadithModel>`. الـ View يجب أن تعتمد على واجهات مجردة أو Entities فقط.
* **الحل:** استبدال `HadithModel` بالـ Domain Entity.

### H14 — Clipboard.setData بدون معالجة أخطاء أو تنبيه للمستخدم
* **الملف:** [hadith_search_share_and_favorite_buttons.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search/presentation/widgets/hadith_search_share_and_favorite_buttons.dart#L17-L20)
* **المشكلة:** نسخ الحديث للحافظة يتم مباشرة عبر `Clipboard.setData` دون وجود try-catch ودون إظهار أي رسالة نجاح أو فشل للمستخدم (User Feedback).
* **الحل:** استخدام دالة مركزية لنسخ النصوص (مثل `ClipboardService`) تحتوي على معالجة أخطاء وتنبيه Toast/SnackBar للمستخدم.

### H15 — DRY Violation: تكرار كود المقارنة للبيانات يدوياً
* **الملف:** [hadith_favorites_repository.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search/data/repos/hadith_favorites_repository.dart#L50-L51)
* **المشكلة:** كود مقارنة الأحاديث بناءً على محتواها `f.hadithContent == hadith.hadithContent` يتكرر في 3 مواقع مختلفة (في دالتي الـ Repository ودالة الـ Cubit) بدلاً من تعريف المقارنة داخل الـ Model نفسه.
* **الحل:** تطبيق Object Equality على الـ Model لتجنب التكرار اليدوي.

---

## 🟡 ثالثاً: المخالفات المنخفضة (Low Severity)

### H16 — UI State: Optimistic update بدون آلية للتراجع عند الفشل
* **الملف:** [hadith_favorites_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/hadith_search/presentation/cubit/hadith_favorites/hadith_favorites_cubit.dart#L33-L34)
* **المشكلة:** يتم تحديث الحالة في الواجهة فوراً (Optimistic Update) ثم استدعاء الحفظ في الـ Repo بشكل `unawaited`. إذا فشلت عملية الحفظ الفعلي بالذاكرة المحلية، لن يتم التراجع عن الحالة (Rollback) مما يعرض المستخدم لبيانات غير صحيحة.
* **الحل:** إضافة معالجة الأخطاء والتراجع عن تعديل القائمة في الـ Cubit عند فشل عملية الـ Repository.

### H17 — Missing DI Module: غياب ملف/مجلد إعدادات الـ DI للميزة
* **المجلد:** `lib/features/hadith_search/`
* **المشكلة:** لا يوجد ملف `hadith_search_di.dart` أو مجلد `di` منظم لتسجيل عناصر الميزة في كائن حقن التبعيات `GetIt` بشكل مستقل، مما يقلل الاتساق والترتيب المعماري.
* **الحل:** إنشاء ملف تسجيل مستقل للميزة واستدعاؤه في ملف التسجيل المركزي للتطبيق.
