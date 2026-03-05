# 📿 مزية الأذكار (azkar)

## نظرة عامة

مزية `azkar` تُتيح للمستخدم الاطلاع على **مختلف أذكار الإسلام** المُصنَّفة في أكثر من 20 فئة (أذكار الصباح، المساء، النوم، المسجد... إلخ). يمكن للمستخدم الدخول إلى أي فئة وتسبيح الأذكار مع **عدّاد تفاعلي** يتتبع التقدم، ويتحرك تلقائياً للذكر التالي عند اكتمال كل ذكر.

---

## 📁 هيكل الملفات

```
azkar/
├── data/
│   ├── datasources/
│   │   └── azkar_local_data_source.dart       ← قراءة JSON + أيقونات + ترتيب
│   ├── models/
│   │   ├── azkar_category_model.dart           ← نموذج فئة الأذكار
│   │   └── zikr_model.dart                     ← نموذج ذكر واحد
│   └── repositories/
│       └── azkar_repository.dart               ← منطق الأعمال
└── presentation/
    ├── controller/
    │   ├── azkar_categories_cubit.dart         ← متحكم قائمة الفئات
    │   ├── azkar_category_loader_cubit.dart    ← متحكم تحميل فئة واحدة
    │   ├── azkar_list_cubit.dart               ← متحكم التسبيح والعدّاد
    │   └── azkar_list_state.dart               ← حالات جلسة التسبيح
    ├── views/
    │   ├── all_azkar_categories_view.dart      ← صفحة الفئات الكاملة
    │   ├── azkar_details_loader_view.dart      ← صفحة تحميل فئة بالـ ID
    │   └── azkar_list_view.dart                ← صفحة التسبيح الفعلية
    └── widgets/
        ├── azkar_list_content.dart             ← قائمة أذكار الفئة
        ├── zikr_item_card.dart                 ← بطاقة ذكر واحد (تفاعلية)
        ├── zikr_card/
        │   ├── zikr_content.dart               ← نص الذكر والتفسير
        │   ├── zikr_actions_row.dart           ← صف الإجراءات (مشاركة، نسخ، عدّاد)
        │   └── zikr_counter.dart               ← العدّاد الدائري
        └── share_card/
            └── zikr_share_card.dart            ← بطاقة مشاركة الذكر
```

---

## 📦 طبقة البيانات (Data Layer)

### `zikr_model.dart` — نموذج ذكر واحد

| الخاصية | النوع | الوصف |
|---------|------|-------|
| `id` | `int` | رقم الذكر داخل فئته |
| `text` | `String` | نص الذكر |
| `subText` | `String?` | نص إضافي/تفسير (اختياري) |
| `count` | `int` | عدد مرات التسبيح المطلوبة |

---

### `azkar_category_model.dart` — نموذج الفئة

يرث من `CategoryModel` (من مزية الرئيسية).

| الخاصية | النوع | الوصف |
|---------|------|-------|
| `id` | `String` | رقم الفئة ("1"، "2"...) |
| `category` | `String` | اسم الفئة (مثل: "أذكار الصباح") |
| `array` | `List<ZikrModel>` | قائمة الأذكار داخل هذه الفئة |
| `icon` | `IconData` | أيقونة الفئة |

---

### `azkar_local_data_source.dart` — مصدر البيانات

يقرأ ملف JSON من Assets ويُجمّع الفئات مع أيقوناتها.

#### جدول الأيقونات:

| الفئة | الأيقونة |
|------|---------| 
| 1 - التسبيح | `solidTasbihHand` |
| 2 - الصباح | `sunrise` |
| 3 - المساء | `sunfog` |
| 4 - النوم | `bed` |
| 5 - الاستيقاظ | `alarm` |
| 6 - الاستحمام | `shower` |
| 7 - المسجد | `mosque` |
| ... | ... |

#### الترتيب الذكي (Priority Ordering):
الفئات ذات الأولوية (الصباح `2`، المساء `3`، الاستيقاظ `5`، النوم `4`، التسبيح `1`) تُعرض أولاً، ثم باقي الفئات. يتم ذلك بـ**مرور واحد** على القائمة للأداء الأمثل.

#### الكاش (`_cachedCategories`):
البيانات تُقرأ مرة واحدة وتُخزَّن في الذاكرة. الاستدعاءات اللاحقة ترجع الكاش فوراً.

---

### `azkar_repository.dart` — الريبوزيتوري

| الدالة | الوصف |
|--------|-------|
| `getAllCategories()` | يُعيد كل فئات الأذكار كـ `Either<Failure, List>` |
| `getItemById(String id)` | يُعيد فئة واحدة بـ ID المحدد |

---

## 🧠 طبقة العرض (Presentation Layer)

### المتحكمات الثلاثة

#### 1. `AzkarCategoriesCubit` — متحكم قائمة الفئات

| الحالة | الوصف |
|--------|-------|
| `AzkarCategoriesInitial` | الحالة الأولية |
| `AzkarCategoriesLoading` | جاري التحميل |
| `AzkarCategoriesLoaded(azkarCategories)` | تم التحميل |
| `AzkarCategoriesError(message)` | خطأ في التحميل |

يبدأ التحميل تلقائياً عند إنشاء المتحكم (`unawaited(loadAzkar())`).

#### 2. `AzkarCategoryLoaderCubit` — متحكم فئة واحدة

يُحمّل فئة بعينها بناءً على ID تمريره من الـ Router.

| الحالة | الوصف |
|--------|-------|
| `AzkarCategoryLoaderInitial` | الحالة الأولية |
| `AzkarCategoryLoaderLoading` | جاري التحميل |
| `AzkarCategoryLoaderLoaded(category)` | تم التحميل |
| `AzkarCategoryLoaderError(message)` | خطأ |

#### 3. `AzkarListCubit` — متحكم جلسة التسبيح (الأهم)

هذا المتحكم يُدير التفاعل الكامل خلال جلسة التسبيح.

---

### `azkar_list_state.dart` — حالات جلسة التسبيح

#### `AzkarListInProgress` — الحالة النشطة

| الخاصية | النوع | الوصف |
|---------|------|-------|
| `category` | `AzkarCategoryModel` | الفئة الحالية |
| `zikrProgress` | `Map<int, int>` | عدد مرات الضغط لكل ذكر (index → count) |
| `currentIndex` | `int` | آخر ذكر تم ضغطه |
| `completedCount` | `int` | عدد الأذكار المكتملة |

**الدوال المساعدة:**
| الدالة | الوصف |
|--------|-------|
| `isZikrCompleted(index)` | هل وصل هذا الذكر للعدد المطلوب؟ |
| `isAllCompleted` | هل اكتملت جميع الأذكار؟ |
| `hasProgress` | هل بدأ المستخدم التسبيح؟ |
| `getCurrentCount(index)` | كم مرة سبّح هذا الذكر؟ |
| `getProgress(index)` | نسبة التقدم (0.0 → 1.0) |

#### دورة حياة الحالات:
```
AzkarListInitial
    → loadAzkar() →
AzkarListInProgress (يتحدث مع كل ضغطة)
    → عند اكتمال كل الأذكار →
AzkarListCompleted
```

---

### `azkar_list_cubit.dart` — دوال التسبيح

| الدالة | الوصف |
|--------|-------|
| `loadAzkar(category)` | يبدأ جلسة تسبيح جديدة للفئة |
| `incrementZikr(index)` | يزيد عداد ذكر واحد بـ +1 |
| `reset()` | يُعيد الجلسة للصفر |

#### آلية `incrementZikr`:
1. يتحقق أن الذكر لم يكتمل بعد.
2. يزيد العداد بـ 1.
3. إذا وصل للعدد المطلوب → `completedCount + 1`.
4. إذا اكتملت كل الأذكار → يُطلق `AzkarListCompleted`.
5. وإلا → يُحدّث الـ state بالتقدم الجديد.

---

### `all_azkar_categories_view.dart` — صفحة الفئات

تعرض قائمة الفئات بـ `AnimatedSliverList`. عند النقر على فئة:
- تنتقل لـ `AzkarDetailsLoaderView` مع تمرير `categoryId` و `category` كـ `extra`.

---

### `azkar_details_loader_view.dart` — صفحة تحميل الفئة

تُنشئ `AzkarCategoryLoaderCubit` وتطلب الفئة بالـ ID. عند النجاح، تُعرض `AzkarListView`.

---

### `azkar_list_view.dart` — صفحة التسبيح الرئيسية

تُدير جلسة التسبيح الكاملة:

**التمرير التلقائي بعد اكتمال ذكر:**
```
عند اكتمال ذكر → _handleZikrCompleted() → انتظر 300ms
→ اسحب الشاشة 35% من ارتفاعها للأسفل
→ أنيميشن سلس 800ms (easeInOutCubic)
```

**التعامل مع زر الرجوع (`_handleExit`):**
- إذا بدأ المستخدم التسبيح ولم يكتمل → **حوار تأكيد الخروج**.
- وإلا → خروج مباشر.

**عند اكتمال كل الأذكار:**
- `BlocListener` يرصد `AzkarListCompleted` → يُظهر `Toast` بالتهنئة → يرجع للصفحة السابقة.

---

### `zikr_item_card.dart` — البطاقة التفاعلية

البطاقة الرئيسية لكل ذكر. تستجيب لـ **النقر والضغط المطوّل**.

**Debounce (منع الضغط المتكرر السريع):**
```dart
static const _debounceDuration = Duration(milliseconds: 200);
```
إذا ضغط المستخدم مرتين في أقل من 200ms، يُتجاهل الثاني.

**Haptic Feedback:**
- ضغطة عادية → اهتزاز بسيط.
- اكتمال ذكر → اهتزازان متتاليان (200ms بينهما).

**بعد الاكتمال:**
- `opacity: 0.5` و `scale: 0.98` (أنيميشن 400ms) للدلالة على الانتهاء.
- لا يستجيب للضغط بعد الاكتمال (`onTap: isCompleted ? null : _handlePress`).

**تحسين الأداء:**
- `buildWhen`: لا يُعيد البناء إلا إذا تغيّر عداد هذا الذكر تحديداً.
- `RepaintBoundary`: يمنع إعادة رسم البطاقات الأخرى.

---

### `zikr_counter.dart` — العدّاد الدائري

يعرض تقدم التسبيح بشكل دائري مرئي:

```
[خلفية دائرية شفافة]
    +
[شريط تقدم متحرك (TweenAnimationBuilder 300ms)]
    +
[رقم العدد المتبقي] أو [✓ عند الاكتمال]
```

- `AnimatedSwitcher` يُبدّل بين الرقم وعلامة الاكتمال بأنيميشن `ScaleTransition`.

---

## 🔄 تدفق جلسة التسبيح الكامل

```
المستخدم يختار فئة (مثل: أذكار الصباح)
      ↓
AzkarDetailsLoaderView → AzkarCategoryLoaderCubit → تحميل الفئة
      ↓
AzkarListView → AzkarListCubit.loadAzkar(category) → AzkarListInProgress
      ↓
المستخدم ينقر على بطاقة ذكر:
  → Debounce 200ms
  → HapticFeedback
  → incrementZikr(index) → state يتحدث
  → ZikrCounter يُحدّث Progress Ring
      ↓
عند اكتمال ذكر:
  → اهتزاز مضاعف
  → تمرير تلقائي للذكر التالي
      ↓
عند اكتمال كل الأذكار:
  → AzkarListCompleted → Toast → pop()
```

---

## 📦 المكتبات المستخدمة

| المكتبة | الغرض |
|---------|-------|
| `flutter_bloc` | إدارة الحالة |
| `flutter_islamic_icons` | أيقونات إسلامية للفئات |
| `font_awesome_flutter` | أيقونات متنوعة للفئات |
| `solar_icons` | أيقونات إضافية |
| `dartz` | نمط Either |
