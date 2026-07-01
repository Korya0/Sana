# تقرير تدقيق معماري — `home`
**مقارنة بـ ARCHITECTURE_RUBRIC.md | مستوى التدقيق: أقصى دقة**

---

## 📊 ملخص تنفيذي

| الوحدة | الحالة | عدد المخالفات |
|--------|--------|--------------|
| Module 1-3: Fundamentals & SOLID | ⚠️ جزئي | 2 |
| Module 4-5: Software Quality | ❌ مخالفة | 3 |
| Module 6: Project Organization | ⚠️ جزئي | 1 |
| Module 7: Layering | ❌ مخالفة | 2 |
| Module 8: Flutter Internal | ❌ مخالفة | 3 |
| Module 9: Data & Communication Flow | ✅ جيد | 0 |
| Module 10: Widget Composition | ⚠️ جزئي | 1 |
| Module 11: Reusability & Design System | ✅ جيد | 0 |
| Module 12: Cross-Cutting Concerns | ❌ مخالفة | 1 |
| Module 13: Performance | ⚠️ جزئي | 1 |
| Module 14: Readability | ✅ جيد | 0 |
| **المجموع** | | **18 مخالفة** _(بعد الجولة الثانية)_ |

### ✅ ما هو ممتاز في هذا الفيتشر:
- ✅ الـ DI نظيف جداً ومقسم بشكل واضح.
- ✅ استخدام `BackdropFilter` لعمل بلور مميز عند تغييب صلاحيات الموقع في `HomePrayerSection` بشكل جمالي جذاب.
- ✅ هيكلية الـ Cubit والـ State للـ FeaturesList بسيطة وتتبع التدفق أحادي الاتجاه.

---

## 🏗️ Module 1-3: Fundamentals, Object Design & SOLID

### ❌ مخالفة #1 — OOP/Type Safety: `CategoryItem` يعتمد على `dynamic icon`
**الملف:** [category_item.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/home/data/models/category_item.dart#L13)

```dart
final dynamic icon; // ⚠️ استخدام dynamic يفقدنا الـ Type Safety!
```

**المشكلة:** استخدام نوع `dynamic` لتعريف الـ icon يفتح الباب لتمرير أي كائن غير متوقع (مثل String أو Widget) مما يسبب كراش عند محاولة عمل Cast لاحقاً.

**الحل:** استخدام `IconData` أو كلاس مخصص يجمع أنواع الأيقونات المختلفة.

---

### ❌ مخالفة #2 — SOLID (DIP): الـ Data layer تعتمد على كلاسات الـ UI
**الملف:** [features_local_data_source.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/home/data/datasources/features_local_data_source.dart#L3-L4)

```dart
import 'package:sana/core/constants/constants.dart'; // يحتوي على AppStrings
import 'package:sana/core/routing/app_routes.dart';     // يحتوي على AppRoutes
```

**المشكلة:** كلاس الـ Local Data Source (Data Layer) تستدعي مباشرة الـ `AppStrings` (UI) والـ `AppRoutes` (Routing). هذا يكسر مبدأ عكس التبعية (Dependency Inversion Principle) ويخلق تلاحماً صلباً (Tight Coupling) بين البيانات والواجهات.

**الحل:** تمرير الـ IDs فقط من الـ Data Layer، وتولي كلاس وسيطة في الـ Presentation مهمة تحويل الـ ID إلى الـ Route والـ Text المقابل.

---

## 🌟 Module 4-5: Software Quality & Scalability

### ❌ مخالفة #3 — Security: رمز الأمان للوحة التحكم مشفر كـ Plain Text في الكود
**الملف:** [app_constants.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/core/constants/app_constants.dart#L8)

```dart
static const String adminSecretPin = '31903556'; // ⚠️ رمز سري مكشوف!
```

**المشكلة الحرجة:** الـ PIN الخاص بحماية لوحة الإدارة وحذف تعليقات المستخدمين مكتوب بنص واضح (Plain Text) داخل كود التطبيق. أي هندسة عكسية للـ APK سيكشف الرمز السري فوراً.

**الحل:** تشفير الـ PIN محلياً (Hashing مثل SHA-256) ومقارنة الهاش الناتج، أو التحقق منه عبر طلب خارجي من السيرفر.

---

### ❌ مخالفة #4 — Fragile Code: استخدام الـ `Future.delayed` لتأخير استدعاء الـ Cubit
**الملف:** [home_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/home/presentation/views/home_view.dart#L39-L54)

```dart
create: (context) {
  final cubit = sl<AsmaUlHusnaCubit>();
  unawaited(
    Future<void>.delayed( // ⚠️ تأخير اصطناعي بـ 200 ملي ثانية!
      const Duration(milliseconds: 200),
    ).then((_) => cubit.loadDailyName()),
  );
  return cubit;
}
```

**المشكلة الحرجة:** استخدام `Future.delayed` لتأخير جلب البيانات من الـ state constructors هو أسلوب هش جداً لحل مشاكل تداخل الـ rebuilds. يسبب مشاكل سباق (Race Conditions) على الأجهزة البطيئة، ويجعل كتابة الـ Unit Tests شبه مستحيلة.

**الحل:** بدء التحميل مباشرة أو استدعاؤه داخل دالة الـ `initState` للـ View بعد استقرار الشجرة.

---

### ❌ مخالفة #5 — Crash Risk: Cast صلب وعنيف للـ icon داخل الـ Grid
**الملف:** [circular_category_grid_section.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/home/presentation/widgets/circular_category_grid_section.dart#L39)

```dart
icon: item.icon as IconData, // ⚠️ Cast صلب بدون تأكد!
```

**المشكلة:** تم تعريف الـ icon كـ `dynamic` في الـ model، ولكن هنا يتم عمل Cast صلب كـ `IconData`. إذا أضاف مطور آخر ميزة جديدة بأيقونة من نوع SVG (مثلاً String مسار)، سينهار التطبيق فوراً بـ `TypeError`.

**الحل:** استخدام التحقق الآمن:
```dart
icon: item.icon is IconData ? item.icon as IconData : Icons.error,
```

---

## 📂 Module 6: Project Organization

### ❌ مخالفة #6 — Dead Code: ملف `home_quran_card_section.dart` غير مستخدم تماماً
**الملف:** [home_quran_card_section.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/home/presentation/widgets/sections/home_quran_card_section.dart)

**المشكلة:** يحتوي الفيتشر على كلاس كاملة لكرت القرآن الكريم بالرئيسية غير مستخدمة ومتروكة بالكامل دون استدعاء. تخرق مبادئ نظافة الكود والـ Discoverability.

---

## 🧱 Module 7: Layering Concepts

### ❌ مخالفة #7 — Loose Boundaries: الـ View تستورد كائنات الـ Cubit الفرعية مباشرة
**الملف:** [home_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/home/presentation/views/home_view.dart#L9-L11)

```dart
import 'package:sana/features/asma_ul_husna/presentation/cubit/asma_ul_husna_cubit.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar_categories_cubit.dart';
```

**المشكلة:** شاشة الرئيسية تستورد وتعتمد بشكل صلب على الـ Cubits الخاصة بالفيتشرات الأخرى لتهيئتها، مما يمنع عزل فيتشر الـ `home` كفيتشر مستقل.

**الحل:** تهيئة الكيوبتات الفرعية في مكان مركزي (مثل الـ Routing أو Root Block Provider) وتمرير الشاشة الرئيسية كـ Consumer فقط.

---

## 🌳 Module 8: Flutter Internal Architecture

### ❌ مخالفة #8 — Performance: استخدام `shrinkWrap: true` في الـ GridView
**الملف:** [circular_category_grid_section.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/home/presentation/widgets/circular_category_grid_section.dart#L23)

```dart
GridView.builder(
  shrinkWrap: true, // ⚠️ يخرق مبدأ الـ Lazy Loading للـ Lists!
  physics: const NeverScrollableScrollPhysics(),
```

**المشكلة:** الـ `shrinkWrap` يجبر الـ GridView على حساب الـ height الخاص بكل العناصر دفعة واحدة بدلاً من بنائها بشكل كسول (Lazy). يؤدي ذلك إلى بطء وتكرار لعمليات الـ Layout.

**الحل:** بما أن الشاشة الرئيسية هي `CustomScrollView` بالكامل، يجب تحويل هذه الـ Grids إلى `SliverGrid` مباشر لتعمل بكفاءة 100%.

---

### ✅ مخالفة #9 — Layout Anti-pattern: بناء قائمة داخل قائمة مع تكرار الـ Scrollables
**الملف:** [home_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/home/presentation/views/home_view.dart#L78-L86)

```dart
SliverToBoxAdapter(
  child: HomeFeaturesCategorySection(), // Status: Resolved
)
```

**المشكلة:** تداخل الـ `SliverToBoxAdapter` مع الـ `GridView` (حتى لو كان NeverScrollable) يصعب من عمل الـ Viewport والـ Hit Testing الخاص بـ Flutter، ويسبب عمليات قياس (Layout passes) ثنائية مكررة.

---

### ❌ مخالفة #10 — Accessibility/Overflow: مساحة طولية ثابتة للـ Grid Cell
**الملف:** [circular_category_grid_section.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/home/presentation/widgets/circular_category_grid_section.dart#L32)

```dart
mainAxisExtent: 100, // ⚠️ حجم ثابت 100 بكسل!
```

**المشكلة:** تم تثبيت ارتفاع العنصر بـ 100 بكسل. إذا قام المستخدم بتكبير الخط من إعدادات الهاتف (Accessibility Font Scale)، سيتراكب النص مع الأيقونة ويحدث Overflow أو قص للنص.

---

## 🧩 Module 10: Widget Composition

### ❌ مخالفة #11 — Magic Value: تكرار أرقام الـ Aspect Ratio والأبعاد المشفرة
**الملف:** [circular_category_grid_section.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/home/presentation/widgets/circular_category_grid_section.dart#L28-L31)

```dart
crossAxisCount: 4,
mainAxisSpacing: 2,
crossAxisSpacing: 8,
childAspectRatio: 0.8,
```

**المشكلة:** أرقام التصميم والتخطيط مبعثرة داخل الكود بدون جمعها في ملف constants مركزي لتسهيل تعديل التصميم الكلي.

---

## ⚙️ Module 12: Cross-Cutting Concerns

### ❌ مخالفة #12 — Localization Violation: فحص معرب للنصوص (RegExp) لقص الكلمات
**الملف:** [home_azkar_category_section.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/home/presentation/widgets/sections/home_azkar_category_section.dart#L44-L47)

```dart
title: category.category.replaceFirst(
  RegExp(r'^(أذكار|اذكار)\s+'), // ⚠️ فحص نصي عربي مشفر!
  '',
),
```

**المشكلة:** تصفية النصوص وقص كلمة "أذكار" يعتمد على تعبير نمطي عربي صلب مدمج بالكود. لو أضيف دعم للغة الإنجليزية، فلن تعمل التصفية لعدم ملاءمتها للغة الجديدة، مما يثبت خرق مبدأ عزل اللغات.

**الحل:** وضع دالة معالجة النصوص داخل الـ localization helpers أو إرسال الاسم مقصوصاً مباشرة من المصدر.

---

## 🚀 Module 13: Performance-Oriented Architecture

### ❌ مخالفة #13 — UI Waste: الـ `MultiBlocProvider` بالـ `HomePrayerSection` ينشئ Providers مكررة
**الملف:** [home_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/home/presentation/views/home_view.dart#L66-L70)

```dart
MultiBlocProvider(
  providers: [
    BlocProvider.value(value: sl<AppDateCubit>()),
    BlocProvider.value(value: sl<PrayerTimesCubit>()),
  ],
  child: const HomePrayerSection(),
)
```

**المشكلة:** بما أن الـ Cubits يتم إحالتها كـ `.value` من الـ Service Locator، فليس هناك أي داعٍ لإعادة توفيرها محلياً بـ `MultiBlocProvider` للـ `HomePrayerSection` فقط إذا كان من الممكن استدعاؤها عبر `sl<AppDateCubit>()` مباشرة أو توفيرها على مستوى الجذر. يسبب هذا تضخماً غير مفيد لـ Elements Tree.

---

## 🔍 جولة ثانية — مخالفات إضافية

### 🔴 مخالفة #14 — Bug: كراش الـ Layout Overflow في حوار الـ PIN
**الملف:** [secret_pin_dialog.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/home/presentation/widgets/secret_pin_dialog.dart#L71-L187)

```dart
child: Padding(
  padding: const EdgeInsets.all(AppSpacing.v24),
  child: Column( // ⚠️ العمود صلب بدون أي حاوية تمرير!
    mainAxisSize: MainAxisSize.min,
    children: [ ... ]
```

**المشكلة:** يعتمد الحوار على `Column` صلب بداخل `Dialog`. عند فتح لوحة المفاتيح الرقمية على شاشات صغيرة أو عند تشغيل الهاتف بالوضع الأفقي (Landscape)، فإن المساحة المتبقية من الشاشة تكون أصغر من طول الحوار، مما يسبب كراش ظهور الخطوط الصفراء والسوداء الشهيرة للـ Overflow.

**الحل:** تغليف الـ Column بـ `SingleChildScrollView` ليتمكن من التمرير عند تقلص الشاشة بفعل الكيبورد.

---

### 🔴 مخالفة #15 — Performance: إعادة إنشاء الكيوبتات وإعادة قراءة الـ Assets مع كل دخول للرئيسية
**الملف:** [home_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/home/presentation/views/home_view.dart#L28-L57)

**المشكلة:** يتم تسجيل `FeaturesListCubit` و `AzkarCategoriesCubit` و `AsmaUlHusnaCubit` كـ Factory وتوليدهم داخل الـ `MultiBlocProvider` للـ `HomeView`. في كل مرة ينتقل فيها المستخدم لصفحة فرعية ثم يرجع للرئيسية، يتم إغلاق الكيوبتات السابقة وإنشاء كيوبتات جديدة تماماً، مما يطلق عمليات قراءة الـ JSON وإدخال/إخراج الملفات (I/O) بشكل متكرر ومسرف لبيانات ثابتة لا تتغير أبداً.

**الحل:** تسجيل هذه الكيوبتات كـ Singletons أو تخزين بيانات الـ Assets مؤقتاً في طبقة الـ Repository لمنع تكرار التحميل والـ I/O.

---

### 🟠 مخالفة #16 — Clean Layout: وجود خصائص تصميم ميتة ولا تأثير لها
**الملف:** [circular_category_grid_section.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/home/presentation/widgets/circular_category_grid_section.dart#L27-L33)

```dart
gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 4,
  mainAxisSpacing: 2,
  crossAxisSpacing: 8,
  childAspectRatio: 0.8, // ⚠️ ميتة ولا قيمة لها!
  mainAxisExtent: 100,  // ⚠️ هذا يلغي الـ childAspectRatio تماماً!
),
```

**المشكلة:** يحدد الـ delegate قيمة لـ `childAspectRatio` و `mainAxisExtent` معاً. في Flutter، تقوم خاصية `mainAxisExtent` بإلغاء وحجب نسبة العرض إلى الارتفاع تماماً، مما يجعل كود `childAspectRatio` زائداً ومضللاً للمطورين.

---

### 🟡 مخالفة #17 — Clean Code: ترك أكواد معلقة ومكتوبة كتعليقات بالكود
**الملف:** [home_features_category_section.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/home/presentation/widgets/sections/home_features_category_section.dart#L44)

```dart
( /* feature.route == AppRoutes.qibla || */ feature.route == ...
```

**المشكلة:** ترك شظايا الكود القديم المعلق كـ Comments في النسخة النهائية المرفوعة.

---

### 🟡 مخالفة #18 — Consistency: تجاوز إمتداد الـ Theme الموحد للمشروع
**الملف:** [home_prayer_section.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/home/presentation/widgets/sections/home_prayer_section.dart#L35-L48)

```dart
color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.4), // ⚠️ استدعاء كلاسيكي للثيم
```

**المشكلة:** يستدعي كلاس الـ `HomePrayerSection` الخلفية عبر `Theme.of(context)` بدلاً من استعمال الـ extension الموحد للمشروع `context.color.scaffoldBackgroundColor` الذي تم استخدامه في بقية الملفات.



# ملحق جولة ثانية — مخالفات home
**يُكمل: HOME_VIOLATIONS.md**

---

## 🔍 ملخص ما تم اكتشافه في الجولة الثانية لـ `home`

| # | المخالفة | التصنيف | الخطورة |
|---|----------|---------|---------|
| HM1 | **كراش الـ Layout Overflow في حوار الـ PIN عند ظهور الكيبورد** | Bug/UI 🔴 | عالي |
| HM2 | **إعادة تدمير وإنشاء الكيوبتات الاستاتيكية مع كل دخول للرئيسية** | Performance 🔴 | عالي |
| HM3 | **خصائص تصميم زائدة وميتة بالـ Grid (Redundant layout property)** | Clean Code 🟠 | متوسط |
| HM4 | **أكواد معلقة ومعطلة متبقية بالصفحة الرئيسية** | Clean Code 🟡 | منخفض |
| HM5 | **تجاوز إضافات ثيم الـ BuildContext الموحدة بالـ Prayer Section** | Consistency 🟡 | منخفض |

---

## 🔍 التفاصيل الفنية للمخالفات الإضافية

### 🔴 مخالفة HM1 — Bug: كراش الـ Layout Overflow في حوار الـ PIN
**الملف:** [secret_pin_dialog.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/home/presentation/widgets/secret_pin_dialog.dart#L71-L187)

```dart
child: Padding(
  padding: const EdgeInsets.all(AppSpacing.v24),
  child: Column( // ⚠️ العمود صلب بدون أي حاوية تمرير!
    mainAxisSize: MainAxisSize.min,
    children: [ ... ]
```

**المشكلة:** يعتمد الحوار على `Column` صلب بداخل `Dialog`. عند فتح لوحة المفاتيح الرقمية على شاشات صغيرة أو عند تشغيل الهاتف بالوضع الأفقي (Landscape)، فإن المساحة المتبقية من الشاشة تكون أصغر من طول الحوار، مما يسبب كراش ظهور الخطوط الصفراء والسوداء الشهيرة للـ Overflow.

**الحل:** تغليف الـ Column بـ `SingleChildScrollView` ليتمكن من التمرير عند تقلص الشاشة بفعل الكيبورد.

---

### 🔴 مخالفة HM2 — Performance: إعادة إنشاء الكيوبتات وإعادة قراءة الـ Assets مع كل دخول للرئيسية
**الملف:** [home_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/home/presentation/views/home_view.dart#L28-L57)

**المشكلة:** يتم تسجيل `FeaturesListCubit` و `AzkarCategoriesCubit` و `AsmaUlHusnaCubit` كـ Factory وتوليدهم داخل الـ `MultiBlocProvider` للـ `HomeView`. في كل مرة ينتقل فيها المستخدم لصفحة فرعية ثم يرجع للرئيسية، يتم إغلاق الكيوبتات السابقة وإنشاء كيوبتات جديدة تماماً، مما يطلق عمليات قراءة الـ JSON وإدخال/إخراج الملفات (I/O) بشكل متكرر ومسرف لبيانات ثابتة لا تتغير أبداً.

**الحل:** تسجيل هذه الكيوبتات كـ Singletons أو تخزين بيانات الـ Assets مؤقتاً في طبقة الـ Repository لمنع تكرار التحميل والـ I/O.

---

### 🟠 مخالفة HM3 — Clean Layout: وجود خصائص تصميم ميتة ولا تأثير لها
**الملف:** [circular_category_grid_section.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/home/presentation/widgets/circular_category_grid_section.dart#L27-L33)

```dart
gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 4,
  mainAxisSpacing: 2,
  crossAxisSpacing: 8,
  childAspectRatio: 0.8, // ⚠️ ميتة ولا قيمة لها!
  mainAxisExtent: 100,  // ⚠️ هذا يلغي الـ childAspectRatio تماماً!
),
```

**المشكلة:** يحدد الـ delegate قيمة لـ `childAspectRatio` و `mainAxisExtent` معاً. في Flutter، تقوم خاصية `mainAxisExtent` بإلغاء وحجب نسبة العرض إلى الارتفاع تماماً، مما يجعل كود `childAspectRatio` زائداً ومضللاً للمطورين.

---

### 🟡 مخالفة HM4 — Clean Code: ترك أكواد معلقة ومكتوبة كتعليقات بالكود
**الملف:** [home_features_category_section.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/home/presentation/widgets/sections/home_features_category_section.dart#L44)

```dart
( /* feature.route == AppRoutes.qibla || */ feature.route == ...
```

**المشكلة:** ترك شظايا الكود القديم المعلق كـ Comments في النسخة النهائية المرفوعة.

---

### 🟡 مخالفة HM5 — Consistency: تجاوز إمتداد الـ Theme الموحد للمشروع
**الملف:** [home_prayer_section.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/home/presentation/widgets/sections/home_prayer_section.dart#L35-L48)

```dart
color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.4), // ⚠️ استدعاء كلاسيكي للثيم
```

**المشكلة:** يستدعي كلاس الـ `HomePrayerSection` الخلفية عبر `Theme.of(context)` بدلاً من استعمال الـ extension الموحد للمشروع `context.color.scaffoldBackgroundColor` الذي تم استخدامه في بقية الملفات.
