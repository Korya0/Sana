# ملحق جولة ثانية — مخالفات daily_content
**يُكمل: DAILY_CONTENT_VIOLATIONS.md**

---

## 🔍 ملخص ما تم اكتشافه في الجولة الثانية لـ `daily_content`

| # | المخالفة | التصنيف | الخطورة |
|---|----------|---------|---------|
| DC1 | **فقدان تصنيف المفضلة (Sunnah favorites load as Hadith)** | Bug حقيقي 🔴 | عالي |
| DC2 | **تخطي العنصر الأول عند التثبيت النظيف (Skip Index 0)** | Bug حقيقي 🔴 | عالي |
| DC3 | **عدم تحديث كارت الأسماء الحسنى اليومي مع التاريخ** | Bug/UX 🔴 | عالي |
| DC4 | **استخدام `NestedScrollView` بدون داعٍ (Redundant Layout)** | Performance 🟠 | متوسط |
| DC5 | **عدم وجود حماية من استدعاء `loadDailyContent` المتزامن** | Race Condition 🟠 | متوسط |
| DC6 | **وجود ملف ميت `daily_content_dialog.dart`** | Clean Code 🟡 | منخفض |

---

## 🔍 التفاصيل الفنية للمخالفات الإضافية

### 🔴 مخالفة DC1 — Bug حقيقي: Sunnah favorites loaded as Hadith (Category corruption)
**الملف:** [daily_content_model.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/data/models/daily_content_model.dart#L36-L43)

```dart
Map<String, dynamic> toJson() {
  return {
    DailyContentKeys.header: header,
    DailyContentKeys.content: content,
    DailyContentKeys.attribution: attribution,
    DailyContentKeys.explanation: explanation,
    // ⚠️ مفتاح category مفقود تماماً!
  };
}
```

**بينما عند استرجاع البيانات:**
```dart
final categoryName = map[DailyContentKeys.category] as String?; // ⚠️ دائماً null!
final category = categoryName == DailyContentType.sunnah.name
    ? DailyContentType.sunnah
    : DailyContentType.hadith; // ⚠️ دائماً hadith!
```

**المشكلة الحرجة:** عند حفظ أي محتوى من نوع "Sunnah" في المفضلة، يتم حفظه بدون مفتاح الـ category. وعند استرجاع المفضلات، يتم إسناد نوع `hadith` افتراضياً لكل ما هو null. النتيجة: **كل السنن المفضلة تتحول إلى أحاديث في شاشة المفضلة!**

---

### 🔴 مخالفة DC2 — Bug حقيقي: تخطي العنصر الأول عند أول تشغيل (Skip Index 0)
**الملف:** [daily_content_repository.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/data/repos/daily_content_repository.dart#L76-L90)

```dart
final lastDate = _prefs.getString(_dateKey(category));
if (lastDate != todayDate) { // ⚠️ عند أول تشغيل lastDate = null
  await _advanceIndex(category, totalCount); // ⚠️ يتم تقديم المؤشر فوراً!
  await _prefs.setString(_dateKey(category), todayDate);
```

**المشكلة:** عند تثبيت التطبيق لأول مرة، يكون `lastDate` قيمته `null` وبالتالي `null != todayDate` تعطي `true`. يتم استدعاء `_advanceIndex` الذي يغير الـ index الافتراضي من `null/0` إلى `1`. النتيجة: **المستخدم لن يرى العنصر الأول (index 0) في قائمة التشغيل المشوشة أبداً!**

---

### 🔴 مخالفة DC3 — Bug/UX: عدم تحديث كارت الأسماء الحسنى اليومي مع التاريخ
**الملفات:** 
- [home_daily_wisdom_section.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/home/presentation/widgets/sections/home_daily_wisdom_section.dart#L52)
- [daily_content_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/cubit/daily_content_cubit.dart#L18)

**المشكلة:**
بينما الـ `DailyContentCubit` يستمع لـ `AppDateCubit` ويقوم بتحديث كروت الحديث والسنة تلقائياً عند تغيير اليوم (عبر `_dateSubscription`)، فإن كارت الأسماء الحسنى اليومي `DailyAsmaUlHusnaCard` يعتمد على `AsmaUlHusnaCubit` (المنشأ بشكل منفصل في `HomeView`) والذي **لا يستمع** لأي تحديث للتاريخ. إذا تغير اليوم والتطبيق مفتوح، ستتحدث كروت الأذكار بينما يظل كارت الأسماء الحسنى قديماً.

---

### 🟠 مخالفة DC4 — Performance: استخدام `NestedScrollView` بدون داعٍ (Redundant Layout)
**الملف:** [daily_content_favorites_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/views/daily_content_favorites_view.dart#L49-L56)

```dart
body: NestedScrollView(
  headerSliverBuilder: (context, innerBoxIsScrolled) => [
    const CommonSliverAppBar(title: AppStrings.dailyContentFavorites),
  ],
  body: _buildContentList(), // يحتوي على CustomScrollView!
),
```

**المشكلة:** شاشة المفضلة لا تحتوي على Tabs أو Pinned headers معقدة تستدعي استخدام `NestedScrollView`. استخدامه هنا يُضيف تعقيداً لا طائل منه ويخلق nesting layers زائدة للـ ScrollController والـ render tree. كان يكفي استخدام `CustomScrollView` واحد مباشر.

---

### 🟠 مخالفة DC5 — Concurrency: عدم وجود حماية من استدعاءات `loadDailyContent` المتزامنة
**الملف:** [daily_content_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/cubit/daily_content_cubit.dart#L25)

```dart
Future<void> loadDailyContent() async {
  // ⚠️ لا توجد حماية أو boolean flag لمنع استدعاء الدالة بشكل متزامن.
  // إذا أطلق الـ date stream عدة أحداث متتالية، سيتم تشغيل I/O والـ parsing بشكل متوازٍ مما قد يسبب race condition.
```

---

### 🟡 مخالفة DC6 — Clean Code: ملف ميت `daily_content_dialog.dart`
**الملف:** [daily_content_dialog.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/widgets/daily_content_dialog.dart)

```dart
// DELETED
// Replaced by showCustomInfoDialog in common overlays
```

**المشكلة:** الملف فارغ ومحذوف منطقياً ولكن لا يزال موجوداً في هيكل المشروع. يكسر نظافة الكود (Discoverability & Simplicity).
