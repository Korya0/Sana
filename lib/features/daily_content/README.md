# 📖 مزية المحتوى اليومي (daily_content)

## نظرة عامة

مزية `daily_content` تعرض للمستخدم **3 محتويات دينية يومية** متجددة تلقائياً:
1. **حديث اليوم** — حديث نبوي شريف.
2. **سنة اليوم** — سنة سلوكية يومية.
3. **اسم الله الحسنى** — اسم من أسماء الله التسعة والتسعين (مُنسّق مع مزية `asma_ul_husna`).

تنتقل المحتويات تلقائياً كل يوم، وتتبع نظام **عشوائي مرتّب** لضمان عدم التكرار حتى تنتهي كل القوائم. يمكن للمستخدم حفظ المحتوى في **المفضلة** وإعادة الاطلاع عليه لاحقاً.

---

## 📁 هيكل الملفات

```
daily_content/
├── data/
│   ├── datasources/
│   │   └── daily_content_datasource.dart       ← تحميل JSON من Assets
│   ├── models/
│   │   └── daily_content_model.dart            ← نموذج محتوى + نوعه
│   └── repositories/
│       └── daily_content_repository.dart       ← منطق التناوب + المفضلة
└── presentation/
    ├── controller/
    │   ├── daily_content_cubit.dart             ← المتحكم الرئيسي
    │   └── daily_content_state.dart             ← الحالة
    ├── views/
    │   └── daily_content_favorites_view.dart    ← صفحة المفضلة
    └── widgets/
        ├── daily_content_dialog.dart            ← حوار عرض المحتوى كاملاً
        ├── daily_content_explanation_dialog.dart ← حوار الشرح
        ├── card/
        │   ├── daily_content_base_card.dart     ← البطاقة الأساسية (قابلة للإعادة)
        │   ├── daily_hadith_card.dart           ← بطاقة الحديث
        │   └── daily_sunnah_card.dart           ← بطاقة السنة
        └── share_card/
            └── daily_content_share_card.dart   ← بطاقة المشاركة
```

---

## 📦 طبقة البيانات (Data Layer)

### `daily_content_model.dart` — نموذج المحتوى

```dart
enum DailyContentType { hadith, sunnah }
```

| الخاصية | النوع | الوصف |
|---------|------|-------|
| `content` | `String` | النص الرئيسي (الحديث أو السنة) |
| `category` | `DailyContentType` | هل هو حديث أم سنة؟ |
| `header` | `String?` | عنوان اختياري |
| `attribution` | `String?` | المصدر (مثل: رواه البخاري) |
| `explanation` | `String?` | شرح اختياري للمحتوى |

---

### `daily_content_datasource.dart` — مصدر البيانات

يحمّل ملف JSON الذي يحتوي على قائمة الأحاديث وقائمة السنن.

**الكاش (`_cachedContent`):**
البيانات تُقرأ مرة واحدة وتُحفظ. الاستدعاءات اللاحقة ترجع الكاش مباشرة.

**هيكل الـ JSON:**
```json
{
  "daily_hadith": [{ "header": "...", "content": "...", "attribution": "...", "explanation": "..." }],
  "daily_sunnah": [{ "content": "...", "attribution": "..." }]
}
```

---

### `daily_content_repository.dart` — الريبوزيتوري (الأهم)

هذا هو قلب المزية. يُنفّذ نظام التناوب اليومي العشوائي.

#### الخصائص الأساسية:

**مفاتيح per-category للـ SharedPreferences:**
```dart
_shuffledKey(category)   → 'hadith_shuffled_indices'  // القائمة المُخلطة
_indexKey(category)      → 'hadith_current_index'      // موضعنا في القائمة
_dateKey(category)       → 'hadith_last_viewed_date'   // آخر يوم شاهدنا فيه
_viewedStatusKey(category) → 'hadith_viewed_today'     // هل شاهدنا اليوم؟
```

#### آلية التناوب العشوائي:

```
أول استخدام:
  → إنشاء قائمة [0, 1, 2, ..., N-1]
  → خلطها عشوائياً (shuffle)
  → حفظها في SharedPreferences
  → currentIndex = 0
      ↓
كل يوم جديد:
  → advanceCategoryIfNewDay() يتحقق إذا تغيّر اليوم
  → إذا نعم → currentIndex + 1
  → إذا وصلنا النهاية → خلط عشوائي جديد + العودة للصفر
      ↓
جلب المحتوى اليومي:
  → getDailyItem() → shuffledIndices[currentIndex]
  → يرجع العنصر في المكان المقابل من القائمة الأصلية
```

**مثال عملي:**
- عندنا 100 حديث.
- يُنشئ قائمة عشوائية: `[42, 7, 88, 3, ...]`
- اليوم الأول: `shuffledIndices[0] = 42` → نعرض الحديث رقم 42
- اليوم الثاني: `shuffledIndices[1] = 7` → نعرض الحديث رقم 7
- ...حتى ننتهي من كل القائمة → نُعيد الخلط وتبدأ من جديد.

#### المفضلة:

| الدالة | الوصف |
|--------|-------|
| `toggleFavorite(item)` | يضيف أو يُزيل من المفضلة ويحفظ |
| `isFavorite(item)` | هل هذا المحتوى في المفضلة؟ |
| `getFavorites()` | يرجع كل المفضلة |

التمييز بين العناصر في المفضلة يعتمد على `content + category` معاً.

---

## 🧠 طبقة العرض (Presentation Layer)

### `daily_content_state.dart` — الحالة

| الخاصية | النوع | الوصف |
|---------|------|-------|
| `status` | `DailyContentStatus` | initial / loading / success / failure |
| `dailyHadith` | `DailyContentModel?` | حديث اليوم |
| `dailySunnah` | `DailyContentModel?` | سنة اليوم |
| `dailyAsma` | `AsmaulHusnaModel?` | اسم الله لهذا اليوم |
| `hadithViewedToday` | `bool` | هل شاهد الحديث اليوم؟ |
| `sunnahViewedToday` | `bool` | هل شاهد السنة اليوم؟ |
| `isHadithFavorite` | `bool` | هل الحديث في المفضلة؟ |
| `isSunnahFavorite` | `bool` | هل السنة في المفضلة؟ |

---

### `daily_content_cubit.dart` — المتحكم

#### التهيئة:
```dart
DailyContentCubit(appDateCubit, repository, asmaRepository) {
  loadDailyContent();
  _dateSubscription = appDateCubit.stream.listen((_) => _checkRefresh());
}
```
يستمع لتغييرات التاريخ (`AppDateCubit`) → إذا تغيّر اليوم → يُعيد تحميل المحتوى.

#### `loadDailyContent()` — تدفق التحميل:

```
1. تحميل قوائم الأحاديث والسنن والأسماء
2. تحقق من اليوم الحالي وتحريك المؤشرات إذا لزم
3. جلب محتوى اليوم الحالي (حديث + سنة + اسم)
4. emit(state.copyWith(
     dailyHadith: ..., dailySunnah: ..., dailyAsma: ...,
     hadithViewedToday: ..., isHadithFavorite: ...
   ))
```

#### الدوال المتاحة:

| الدالة | الوصف |
|--------|-------|
| `markHadithAsViewed()` | يُسجّل أن المستخدم شاهد الحديث اليوم |
| `markSunnahAsViewed()` | يُسجّل أن المستخدم شاهد السنة اليوم |
| `toggleHadithFavorite()` | تبديل المفضلة للحديث |
| `toggleSunnahFavorite()` | تبديل المفضلة للسنة |
| `refresh()` | إعادة التحميل |

#### `_getTodayDateString()`:
يعتمد على `appDateCubit.state.date.gregorian` (التاريخ الميلادي) لتوليد string بصيغة `YYYY-MM-DD`. هذا يضمن التزامن مع النظام حتى لو تغيّر إعداد الهجري.

---

### `daily_content_base_card.dart` — البطاقة القاعدية

هذه بطاقة قابلة لإعادة الاستخدام وتستخدمها بطاقتا الحديث والسنة وأسماء الله.

**ما تحتويه:**
- **أيقونة خلفية كبيرة** شفافة (5% opacity) في الزاوية اليمنى السفلى.
- **رأس البطاقة**: عنوان + أزرار (المفضلة، المشاركة، النسخ، الشرح).
- **جسم البطاقة**: النص مع اكتشاف ذكي للفيض:
  - إذا النص يتجاوز سطرين → يظهر "اضغط هنا للمزيد".
  - أو إذا `footerText != null` → يظهره دائماً.

---

### `daily_content_dialog.dart` — حوار العرض الكامل

يُعرض عند نقر المستخدم على البطاقة أو أيقونة التفاصيل. يعرض:
- تسمية الفئة (حديث / سنة).
- العنوان (إن وجد) بحجم كبير.
- النص الكامل بخط القرآن.
- المصدر/الإسناد.
- أزرار المشاركة والنسخ.
- زر الإغلاق.

الحوار محدود الارتفاع بـ 70% من ارتفاع الشاشة مع `SingleChildScrollView` لتمرير المحتوى الطويل.

---

### `daily_content_favorites_view.dart` — صفحة المفضلة

تعرض كل المحتويات المحفوظة في المفضلة ببطاقات `_FavoriteCard`.

**ما تحتويه كل بطاقة:**
- العنوان أو أول 30 حرفاً من المحتوى.
- أيقونة قلب للحذف من المفضلة.
- أزرار مشاركة ونسخ.
- زر "شرح" (إذا وُجد).
- أول 3 أسطر من المحتوى.
- المصدر (إن وجد).

عند الضغط على البطاقة → يُفتح `DailyContentDialog` بالمحتوى الكامل.

---

## 🔄 تدفق البيانات الكامل

```
تشغيل التطبيق → DailyContentCubit يُنشأ
      ↓
loadDailyContent():
  ├── تحميل JSON (حديث + سنة) من Assets
  ├── جلب أسماء الحسنى من AsmaRepository
  ├── للفئات الثلاث (hadith, sunnah, asma):
  │   └── advanceCategoryIfNewDay() → إذا يوم جديد: تحريك المؤشر
  └── getDailyItem() × 3 → الحديث + السنة + الاسم
      ↓
emit(DailyContentState.success)
      ↓
Home Page → DailyHadithCard + DailySunnahCard + AsmaUlHusnaNameOfTheDayCard
      ↓
المستخدم ينقر على البطاقة → DailyContentDialog
المستخدم يضغط المفضلة → toggleHadithFavorite() → isFavorite يتغير
      ↓
AppDateCubit يُصدر حدث → _checkRefresh() → إذا يوم جديد → loadDailyContent()
```

---

## 💾 البيانات المحفوظة (SharedPreferences)

**لكل فئة (hadith, sunnah, asma):**

| المفتاح | النوع | الوصف |
|---------|------|-------|
| `{category}_shuffled_indices` | `String` (JSON) | القائمة المُخلطة |
| `{category}_current_index` | `int` | الموضع الحالي في القائمة |
| `{category}_last_viewed_date` | `String` | آخر تاريخ تحديث |
| `{category}_viewed_today` | `bool` | هل شُوهد اليوم؟ |
| `dailyContentFavorites` | `String` (JSON Array) | المحتوى المحفوظ في المفضلة |

---

## 📦 المكتبات المستخدمة

| المكتبة | الغرض |
|---------|-------|
| `flutter_bloc` | إدارة الحالة |
| `dartz` | نمط Either |
| `shared_preferences` | حفظ حالة التناوب والمفضلة |
| `solar_icons` | أيقونات الواجهة |

---

## 🔗 العلاقات مع المزايا الأخرى

- **`app_date`**: مصدر التاريخ للتحقق من اليوم الجديد عبر `AppDateCubit`.
- **`asma_ul_husna`**: يجلب `getNames()` منها لاختيار اسم اليوم.
- **`core/sharing`**: لمشاركة المحتوى كصورة.
