# تصميم: ودجيت النص المتحرك + تقليل مساحة كروت الأذكار

**النوع:** تعديل محدود (bounded) — ملفان موجودان + ودجيت جديد في `core`.
**الحالة:** ✅ منفّذ — `flutter analyze`: **No issues found!**

---

## 1) الودجيت الجديد

**الملف:** `lib/core/widgets/text/app_marquee_text.dart`
**الكلاس:** `AppMarqueeText`

### الواجهة

| البارامتر | النوع | الافتراضي | الوظيفة |
|---|---|---|---|
| `text` | `String` | مطلوب | النص المعروض |
| `style` | `TextStyle` | مطلوب | ستايل النص القادم من `AppTextStyles` |
| `textAlign` | `TextAlign` | `TextAlign.center` | محاذاة النص عندما يكون داخل المساحة |

### كيف يقرر هل يتحرك أم لا؟

- يقيس عرض النص **فعليًا** داخل `LayoutBuilder` باستخدام `TextPainter`
  بنفس `style` (مدمجًا مع `DefaultTextStyle`) وبنفس `MediaQuery.textScalerOf(context)`
  — وليس بتقدير بعدد الحروف.
- **النص داخل المساحة:** `Text` عادي، بدون أنيميشن، بدون `AnimationController`
  (صفر تكلفة وقت الخمول).
- **النص متجاوز للمساحة:** يتم تفعيل الحركة.
- **المساحة غير محدودة العرض** (مثل `Row` بدون `Expanded`): نص ثابت — لا حركة.

### شكل الحركة

```text
وقفة ثانية واحدة  →  يخرج من جهة اليمين  →  يظهر من الشمال ويكمل لليمين  →  وقفة ثانية  →  تكرار
```

- **اتجاه واحد فقط** — لا رجوع لليسار ولا ping-pong.
- في **RTL**: النص يتحرك يمينًا حتى يخرج بالكامل، ثم تبدأ النسخة التالية من حافة
  الشمال وتتحرك يمينًا حتى تصل لنفس موضعه، ثم يتوقف ثانية، ثم تتكرر الدورة.
- في **LTR** العكس تلقائيًا حسب `Directionality`.
- إعادة التصفير تحدث والنص **خارج الشاشة تمامًا**، فلا يوجد أي قفزة مرئية.
- مثال: النص «الطعام والشراب» يظهر أولًا «الطعام والش…» ثم يتحرك يمينًا، وبعد خروجه
  يظهر من الشمال ويكمل لليمين، ثم يستقر ثانية واحدة قبل الدورة التالية.

### البناء التقني

```text
ClipRect
  └─ Transform.translate   (إزاحة محسوبة من قيمة الأنيميشن)
       └─ Align(alignment: AlignmentDirectional.centerStart, heightFactor: 1)
            └─ SizedBox(width: عرض النص المقاس)
                 └─ Text(maxLines: 1, softWrap: false)
```

- `AnimationController` واحد لكل كارت **ظاهر** فقط، ويتم `dispose()` له.
- `RepaintBoundary` حول كل نص متحرك حتى لا تُعاد رسم الشبكة كلها في كل إطار.
- يُحترم `MediaQuery.disableAnimationsOf(context)`: لو المستخدم طالب تقليل الحركة
  → نص ثابت بـ ellipsis بدون أي أنيميشن.
- الحركة خطية بسرعة ثابتة `marqueeSpeedPxPerSecond = 30`، ومدتها
  `(عرض النص + عرض المكان) / السرعة`.
- الدورة مبنية على `TweenSequence` داخل `AnimationController` واحد
  (خروج → دخول من الجهة الأخرى) — بدون `Timer` متكرر وبدون `async` أثناء الحركة.
- **الأداء:** الوقفة الثانية **موقوف فيها الـ ticker تمامًا** (`Timer` واحد ثم
  `forward(from: 0)`)، فمفيش أي إطار يُرسم أثناء الوقفة — تكلفة الخمول صفر.
- النص المُتحرك ملفوف بـ `Flexible` داخل الـ`Column` حتى لا يحدث overflow
  عند تكبير خط النظام على الشاشات الصغيرة.

### الثوابت الجديدة (في `AppConstants`)

```dart
// Marquee text
static const double marqueeSpeedPxPerSecond = 30;
static const Duration marqueePause1000ms = Duration(seconds: 1);
```

- السرعة والمدة ليستا مقاسات بكسل → مكانهما `AppConstants` مع وحدة في الاسم.
- لا حاجة لأي `AppSize` جديد؛ المسافات القائمة كافية.

---

## 2) كارت الأذكار

**الملف:** `lib/features/azkar/presentation/widgets/categories/azkar_category_card.dart`

قبل:

```dart
Text(
  title,
  textAlign: TextAlign.center,
  maxLines: AppConstants.maxTwoLines,
  overflow: TextOverflow.ellipsis,
  style: AppTextStyles.font12W700Primary(context),
)
```

بعد:

```dart
Flexible(
  child: AppMarqueeText(
    text: title,
    style: AppTextStyles.font12W700Primary(context),
  ),
)
```

- سطر واحد بدل سطرين، ونفس الستايل ونفس الشكل الخارجي للكارت
  (الدائرة + الأيقونة + `AppPressable`).
- `Flexible` حماية من الـ overflow لو المستخدم مكبّر خط النظام على شاشة صغيرة.

---

## 3) مسافات الشبكة

**الملف:** `lib/features/azkar/presentation/widgets/categories/azkar_categories_grid.dart`
**الملف:** `lib/core/constants/app_constants.dart`

| القيمة | قبل | بعد | الأثر |
|---|---|---|---|
| `azkarCategoryTileAspectRatio` | `0.65` | `0.9` | ارتفاع التايل ≈ 123px → ≈ 89px |
| `mainAxisSpacing` | `AppSize.p4` | `AppSize.p4` (بدون تغيير) | — |
| عدد الأعمدة | 4 | 4 | زي الحالي بالضبط |

**النتيجة:** المسافة بين الصف والصف الذي تحته تنزل من ≈ 54px إلى ≈ 20px.

**السبب:** المساحة الكبيرة كانت موجودة لاستيعاب عنوان من سطرين؛ بعد تحويل العنوان
إلى سطر واحد متحرك لم نعد نحتاجها، فارتفاع التايل نفسه هو مصدر الفراغ الأساسي —
وليس `mainAxisSpacing` (وهو أصغر توكن موجود أصلًا `p4`).

---

## 4) التحقق

```bash
flutter analyze   # No issues found!
```

- لا commits.
- لا push على GitHub.
- لا تشغيل لأي tests.

---

## 5) قرارات اتُّخذت (قابلة للتعديل)

1. **شكل الحركة:** اتجاه واحد — خروج من جهة اليمين ثم دخول من الشمال، بدون رجوع.
2. **الوقفة:** ثانية واحدة عند وضع البداية بين كل دورتين، والـticker متوقف خلالها
   (تكلفة صفر إطارات).
3. **السرعة:** `30 px/s`. لو بطيئة/سريعة جدًا نخليها `20` أو `45`.
4. **محاذاة العنوان:** يبقى في المنتصف عندما يدخل في المساحة، ويبدأ من حافة
   البداية فقط أثناء الحركة.
