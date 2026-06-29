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
