# تقرير تدقيق التمرير في ميزة azkar

## نطاق التدقيق (Scope)

- تم فحص **طبقة العرض فقط** في الميزة: كل الملفات تحت `lib/features/azkar/presentation/` (الشاشات، الـ widgets، الـ bottom sheets، الـ dialogs، والحالات المرئية).
- تمت قراءة ملفات مشتركة تحت `lib/core/widgets/` **لفهم السلوك فقط**، دون تدقيقها أو تعديلها، وتحديداً:
  - `lib/core/widgets/views/app_state_view.dart`
  - `lib/core/widgets/views/app_error_view.dart`
  - `lib/core/widgets/views/app_empty_view.dart`
  - `lib/core/widgets/slivers/common_sliver_app_bar.dart`
  - `lib/core/widgets/overlays/app_bottom_sheet.dart` / `app_sheet_body.dart` / `app_form_sheet.dart` / `custom_confirmation_dialog.dart`
- **لم يتم تعديل أي ملف إنتاجي**، ولم يتم تعديل `chat.md` أو أي ملف_plan/doc، ولم يتم عمل commit.
- ملف القياس المؤقت `test/azkar_scroll_probe_test.dart` تم حذفه بعد انتهاء القياس؛ لا توجد ملفات جديدة تحت `test/`.

## طريقة القياس

تم ضخ الـ widgets الحقيقية عبر اختبار مؤقت باستخدام:

- `tester.view.physicalSize` = `Size(320, 640)` و `Size(400, 900)`، مع `tester.view.devicePixelRatio = 1`.
- `tester.view.padding` إمّا `FakeViewPadding.zero` أو `const FakeViewPadding(left: 0, top: 47, right: 0, bottom: 34)`.
- `MaterialApp(theme: AppTheme.light)` مع استدعاء `AppSize.init(context)` داخل `MaterialApp.builder`.
- `Directionality(textDirection: TextDirection.rtl)`.
- قراءة `ScrollableState.position` الفعّال لكل `Scrollable` (وليس `Scrollable.controller` فقط، لأن الـ `SingleChildScrollView` الداخلي يشارك أحياناً الـ `PrimaryScrollController` الخارجي).
- أُجريت 136 حالة اختبار، كلها نجحت (`All tests passed!`).
- تم قياس إضافي عند `textScaler = 1.5` على `Size(320, 640)`.

التهيئات الأربع المختصرة:

| الرمز | التهيئة |
|---|---|
| A | `320x640` بدون safe-area |
| B | `320x640` مع top inset = 47 |
| C | `400x900` بدون safe-area |
| D | `400x900` مع top inset = 47 |

## Audit Health Score

| البند | النتيجة |
|---|---|
| شاشات/حالات نظيفة (`extentAfter = 0`) في التهيئة A | 11 من 18 |
| شاشات/حالات نظيفة في التهيئة B | 10 من 18 |
| حالات ذات تمرير غير ضروري مؤكد | 7 حالات (4 منها بزيادة ارتفاع الـ app bar بالضبط) |
| bottomsheets / dialogs ذات تمرير غير ضروري | 0 من 9 |
| استثناءات overflow على الشاشة الصغيرة | 1 (في `custom_azkar_form_view.dart`) |
| استثناءات overflow عند text scaler 1.5 | 1 (نفس الموضع، أكبر حجماً) |

## جدول القياسات — الشاشات وكل الحالات

القيم هي `extentAfter` للـ `CustomScrollView` الخارجي عند هذا الحالة. في كل الحالات كان `extentBefore = 0.0` و `pixels = 0.0` و `viewportDimension` = ارتفاع الشاشة (640 أو 900).

| الشاشة / الحالة | A: 320×640 لا آمن | B: 320×640safe47 | C: 400×900 لا آمن | D: 400×900safe47 | الحكم |
|---|---:|---:|---:|---:|---|
| `home-loaded` | 0.0 | 0.0 | 0.0 | 0.0 | نظيفة |
| `home-empty` | 260.7 | 307.7 | 305.1 | 352.1 | تمرير غير ضروري |
| `home-categories-error` | 212.7 | 259.7 | 257.1 | 304.1 | تمرير غير ضروري |
| `home-tasbeeh-error` | 143.6 | 190.6 | 170.7 | 217.7 | تمرير غير ضروري |
| `tasbeeh-loaded` | 0.0 | 0.0 | 0.0 | 0.0 | نظيفة |
| `tasbeeh-empty` (شبكة الجاهزية) | 0.0 | 0.0 | 0.0 | 0.0 | نظيفة |
| `tasbeeh-loading` (هيكل عظمي) | 0.0 | 0.0 | 0.0 | 0.0 | نظيفة |
| `tasbeeh-error` | 56.0 | 103.0 | 56.0 | 103.0 | تمرير غير ضروري |
| `custom-list-empty` | 0.0 | 0.0 | 0.0 | 0.0 | نظيفة |
| `custom-list-loaded` | 0.0 | 0.0 | 0.0 | 0.0 | نظيفة |
| `custom-list-loading` | 0.0 | 0.0 | 0.0 | 0.0 | نظيفة |
| `custom-list-error` | 56.0 | 103.0 | 56.0 | 103.0 | تمرير غير ضروري |
| `zikr-loaded` | 0.0 | 0.0 | 0.0 | 0.0 | نظيفة |
| `zikr-loading` (هيكل عظمي) | 0.0 | 34.0 | 0.0 | 0.0 | عابر/مقبول، يُراقب |
| `zikr-empty` | 56.0 | 103.0 | 56.0 | 103.0 | تمرير غير ضروري |
| `zikr-error` | 56.0 | 103.0 | 56.0 | 103.0 | تمرير غير ضروري |
| `form-empty` | 0.0 | 0.0 | 0.0 | 0.0 | نظيفة من ناحية التمرير، لكن Overflow |
| `form-one-item` | 0.0 | 0.0 | 0.0 | 0.0 | نظيفة من ناحية التمرير، لكن Overflow |

الـ `SingleChildScrollView` الداخلي في `AppStateView` كان دائماً `extentAfter = 0.0`؛ أي أن التمرير الزائد ليس داخله، بل ناتج عن تضخيم ارتفاع المحتوى داخل الـ `CustomScrollView` الخارجي.

### الـ bottom sheets والـ dialogs

كلها `extentAfter = 0.0` في التهيئات الأربع (القيمة المعروضة هي `viewportDimension` للجسم القابل للتمرير):

| الـ sheet / dialog | A | B | C | D | ملاحظة |
|---|---:|---:|---:|---:|---|
| `ReadingSettingsBottomSheet` (`AppSheetBody`) | 173.0 | 173.0 | 189.9 | 189.9 | نظيف |
| `AzkarHomeOptionsBottomSheet` | 235.5 | 235.5 | 259.2 | 259.2 | نظيف |
| `AzkarCategoryActionsBottomSheet` | 110.5 | 110.5 | 120.5 | 120.5 | نظيف |
| `TasbeehOptionsBottomSheet` | 54.8 | 54.8 | 59.7 | 59.7 | نظيف |
| `AzkarTasbeehSettingsBottomSheet` | 127.6 | 127.6 | 158.8 | 158.8 | نظيف |
| `EditTargetCountBottomSheet` (`AppFormSheet`) | 102.5 | 102.5 | 119.1 | 119.1 | نظيف |
| `ZikrFormBottomSheet` (`AppFormSheet`) | 339.8 | 339.8 | 413.7 | 413.7 | نظيف |
| `TasbeehItemFormBottomSheet` (`AppFormSheet`) | 229.3 | 229.3 | 276.5 | 276.5 | نظيف |
| `CustomConfirmationDialog` | 126.1 | 126.1 | 150.9 | 150.9 | نظيف — استخدام `SingleChildScrollView` مسموح هنا لأنه dialog بحجم المحتوى |

> ملاحظة: عند `textScaler = 1.5` ظهرت قيمة `extentAfter = 1.4` في حقل نص داخلي (`EditableText`) داخل `ZikrFormBottomSheet` فقط؛ هذا تمرير داخلي طبيعي لتحريك النص أثناء التحرير، وليس تمرير شاشة.

### قياس إضافي عند `textScaler = 1.5` على `320x640`

| الحالة | `extentAfter` | استثناء |
|---|---:|---|
| `home-loaded` | 0.0 | لا |
| `home-empty` | 260.7 | لا |
| `home-categories-error` | 212.7 | لا |
| `home-tasbeeh-error` | 143.6 | لا |
| `tasbeeh-error` | 56.0 | لا |
| `custom-list-error` | 56.0 | لا |
| `zikr-loaded` | 167.3 | لا (نمو حقيقي للنص) |
| `zikr-empty` / `zikr-error` | 56.0 | لا |
| `form-empty` / `form-one-item` | 0.0 | `A RenderFlex overflowed by 60 pixels on the right.` |

كل الـ sheets عند `textScaler = 1.5`: `extentAfter = 0.0` وبدون استثناءات.

## النتائج تفصيلاً (P0–P3)

### P0 — حالات الخطأ/الفراغ بملء الشاشة تضيف ارتفاع الـ app bar بالضبط

**المواقع:**
- `lib/features/azkar/presentation/views/tasbeeh_view.dart:168-175` — `TasbeehError` → `SliverFillRemaining(hasScrollBody: false)` + `AppErrorView`.
- `lib/features/azkar/presentation/views/custom_azkar_list_view.dart:67-75` — `CustomAzkarError` → `SliverFillRemaining(hasScrollBody: false)` + `AppErrorView`.
- `lib/features/azkar/presentation/widgets/zikr_list/zikr_list_content.dart:40-47` — `AzkarError` و `AzkarEmpty` → `SliverFillRemaining(hasScrollBody: false)` + `AppErrorView` / `AppEmptyView` (يُستخدمان من `lib/features/azkar/presentation/views/zikr_list_view.dart:443`).

**القياس:** `extentAfter = 56.0` بدون safe-area و `103.0` مع top inset 47، في التهيئات الأربع، رغم أن المحتوى بأكمله يتسع داخل الشاشة.

**الأثر:**
- الشاشة قابلة للتمرير بينما لا يوجد ما يستحق التمرير؛ المستخدم يرى "ارتداداً" فارغاً.
- في `custom_azkar_list_view.dart:48` الـ `CommonSliverAppBar` يستخدم الوضع الافتراضي `isPinned: false`، أي `floating: true / snap: true` (`lib/core/widgets/slivers/common_sliver_app_bar.dart:39-41`)، فيختفي الـ app bar عند أدنى تمرير — تماماً كعيب qibla الذي شُخّص سابقاً.
- في `tasbeeh_view.dart:123-125` و `zikr_list_view.dart:415-418` الـ app bar `isPinned: true`، فيبقى ظاهراً لكن التمرير الوهمي ما زال موجوداً.

**السبب الجذري:** `AppErrorView` / `AppEmptyView` يبنيان `AppStateView` (`app_error_view.dart:20`، `app_empty_view.dart:18`) الذي يحتوي على `SingleChildScrollView` + `ConstrainedBox(constraints: BoxConstraints(minHeight: viewport.height))` في `lib/core/widgets/views/app_state_view.dart:28-32`. عند وضعه داخل `SliverFillRemaining(hasScrollBody: false)` يصبح إجمالي الامتداد = ارتفاع الشاشة + ارتفاع الـ app bar.

**التوصية العملية:** لا تضع `AppStateView` داخل `SliverFillRemaining`. إمّا:
1. إضافة معامل `minHeight` اختياري إلى `AppStateView` (الافتراضي = ارتفاع الشاشة) وتمرير `0` في حالات الـ sliver، أو
2. إنشاء نسخة `AppStateSliver` بحجم المحتوى تستخدم `SliverFillRemaining(hasScrollBody: false)` مع `Center` مباشرة دون `SingleChildScrollView` وبدون `minHeight` كامل الشاشة، أو
3. على الأقل تمرير `constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height - AppSize.appBarInset(context))` للطفل داخل هذه الحالات الثلاثة.

---

### P1 — حالة فراغ/خطأ الصفحة الرئيسية تُضخّم بسبب `minHeight` كامل الشاشة

**المواقع:**
- `lib/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_section_widget.dart:52-73` (`AzkarCategoriesEmpty`) و `74-98` (`AzkarCategoriesError`) — `AppStateView` داخل `SliverToBoxAdapter` → `AppSectionCard`.
- `lib/features/azkar/presentation/widgets/azkar_tasbeeh_home/tasbeeh/tasbeeh_home_card.dart:98-106` (`TasbeehError`) — نفس النمط.
- الشاشة نفسها `lib/features/azkar/presentation/views/azkar_tasbeeh_home_view.dart:45` تستخدم `CustomScrollView` بدون `CommonSliverAppBar`، وحالة التحميل العادية فيها `extentAfter = 0.0` في التهيئات الأربع.

**القياس:** `home-empty` = 260.7 / 307.7 / 305.1 / 352.1، `home-categories-error` = 212.7 / 259.7 / 257.1 / 304.1، `home-tasbeeh-error` = 143.6 / 190.6 / 170.7 / 217.7. المقارنة مع `home-loaded = 0.0` تثبت أن التمرير ناتج عن الـ `minHeight` وليس عن محتوى حقيقي.

**الأثر:** عند تعذّر التحميل أو عدم وجود فئات، تظهر بطاقة بحجم الشاشة كاملة وتُجبر الصفحة على التمرير مئات البكسلات؛ بينما النص والزر وحدهما يحتاجان مساحة صغيرة.

**السبب الجذري:** `SliverToBoxAdapter` يعطي طفله ارتفاعاً غير محدود، فيأخذ `SingleChildScrollView` الداخلي حجم `ConstrainedBox` الذي يفرض `minHeight = viewport.height` (`app_state_view.dart:29-32`)، فيُضاف ذلك إلى امتداد الـ `CustomScrollView` الخارجي.

**التوصية:** استخدام نسخة محتوى-sized من `AppStateView` هنا (الخيار 1 أو 2 في P0)، مع إبقاء `Center` و `AppSectionCard` كما هما؛ لا حاجة لأي `minHeight` داخل sliver.

---

### P2 — overflow أفقي في شاشة نموذج الأذكار

**الموقع:** `lib/features/azkar/presentation/views/custom_azkar_form_view.dart:306-345`، وتحديداً الـ `Row` في السطر `306:29` الذي يجمع `AppTextButton(addZikr)` مع `Spacer` و `ConstrainedBox(maxWidth: AppSize.w88 * 2)` الذي يحتوي نص التلميح.

**القياس:**
- `320x640`: `A RenderFlex overflowed by 6.0 pixels on the right.` (مع وبدون safe-area).
- `400x900`: `A RenderFlex overflowed by 7.5 pixels on the right.`
- `Size(320,640)` مع `textScaler = 1.5`: `A RenderFlex overflowed by 60 pixels on the right.`
- يحدث في كلتي `form-empty` و `form-one-item`.

**الأثر:** جزء من نص التلميح أو زر "إضافة ذكر" يخرج من حدود الشاشة؛ عند تكبير الخط يصبح القطع واضحاً.

**السبب الجذري:** الزر الأول والـ `ConstrainedBox` الثاني كلاهما بحجمها الطبيعي داخل `Row` بـ `mainAxisAlignment.spaceBetween`؛ لا يوجد `Flexible`/`Expanded` يسمح بالانكماش، رغم أن `Text` الداخلي يملك `maxLines: 1` و `ellipsis` لكنه محاصر بعرض ثابت `AppSize.w88 * 2`.

**التوصية:** لفّ الطفل الأول في `Flexible(flex: 1)` أو تقليل `maxWidth` إلى `AppSize.w88`، والسماح للطفل الثاني بـ `Flexible` مع نص يستخدم `ellipsis`، أو استخدام `Wrap` عند العرض الضيق. يجب إعادة القياس بعد التعديل عند `textScaler = 1.5`.

---

### P3 — حالات تحميل عابرة وملاحظات بنيوية

1. `zikr-loading` عند `320x640` مع top inset 47 يعطي `extentAfter = 34.0` بينما في التهيئات الأخرى `0.0` (`lib/features/azkar/presentation/widgets/zikr_list/zikr_list_skeleton.dart` يُعرض عبر `ZikrListContent` في `zikr_list_content.dart:39`). هي حالة تحميل قصيرة ولا تسبب اختفاء الـ app bar لأنه `pinned`؛ لكنها تستحق مراقبة إن ظهرت بعد التحميل.
2. استخدام `SingleChildScrollView` داخل `AppStateView` يتعارض مع قاعدة `docs/ui/01_layout.md` التي تمنع `SingleChildScrollView` على مستوى الشاشة (يُسمح به فقط في الـ dialogs بحجم المحتوى). في azkar يظهر هذا داخل شاشات كاملة عبر الحالات المذكورة في P0 و P1؛ الحل البنيوي في P0 يعالج الجميع دفعة واحدة.
3. الـ `ConstrainedBox(maxHeight: ...)` في `lib/core/widgets/overlays/app_bottom_sheet.dart:30-33` و `app_sheet_body.dart:41-43` و `app_form_sheet.dart:56-71` يعمل بشكل صحيح: كل الـ sheets بحجم المحتوى ولم تظهر أي زيادة في `extentAfter`.
4. `CustomConfirmationDialog` في `lib/core/widgets/overlays/custom_confirmation_dialog.dart:42` يستخدم `SingleChildScrollView` — وهذا استثناء مقبول لأنه dialog بحجم المحتوى، والقياس يُظهر `extentAfter = 0.0`.

## الشاشات/الحالات النظيفة (`extentAfter = 0`)

- `home-loaded` (في جميع التهيئات الأربع).
- `tasbeeh-loaded`، `tasbeeh-empty`، `tasbeeh-loading`.
- `custom-list-empty`، `custom-list-loaded`، `custom-list-loading`.
- `zikr-loaded` (عند scaler 1.0؛ عند 1.5 يصبح 167.3 وهو نمو حقيقي للنص).
- `form-empty` و `form-one-item` من ناحية التمرير (لكنهما يعانيان من overflow، انظر P2).
- جميع الـ bottom sheets والـ dialogs التسعة.
- الـ `SingleChildScrollView` الداخلي في `AppStateView` نفسه: `extentAfter = 0.0` دائماً.

## الخلاصة

نعم، يوجد تمرير غير ضروري في azkar، وهو **نفس نمط عيب qibla**:

- 4 حالات قياسية (`tasbeeh-error`، `custom-list-error`، `zikr-empty`، `zikr-error`) تزيد بمقدار ارتفاع الـ app bar بالضبط: `56.0` بدون safe-area و `103.0` مع top inset 47.
- 3 حالات على الصفحة الرئيسية تزيد بمئات البكسلات بسبب `minHeight: MediaQuery.sizeOf(context).height`.
- المشكلة ليست في الـ sheets/dialogs، وإنما في استخدام `AppStateView` ذو الارتفاع الكامل داخل slivers.

## الخطوات التالية المقترحة

1. إصلاح P0 أولاً: توفير متغير `AppStateView` بحجم المحتوى (أو معامل `minHeight`) وتطبيقه في المواقع الأربعة، ثم إعادة القياس للتأكد من أن القيم تصبح `0.0` / `0.0` / `0.0` / `0.0`.
2. تطبيق نفس الإصلاح على P1 في `azkar_section_widget.dart` و `tasbeeh_home_card.dart`، والتحقق من أن `home-empty` و `home-categories-error` و `home-tasbeeh-error` تُصبح `0.0`.
3. إصلاح P2 في `custom_azkar_form_view.dart:306` بجعل الـ `Row` قابلاً للانكماش، وإضافة اختبار عند `textScaler = 1.5` على `Size(320, 640)`.
4. إضافة اختبارات انحدار دائمة (إلى جانب اختبارات qibla) تؤكد `extentAfter == 0` لحالات الخطأ/الفراغ في azkar عند التهيئات الأربع، لحماية من عودة النمط نفسه.
5. مراقبة `zikr-loading` عند top inset 47 (القيمة 34.0) وتقرير ما إذا كانت مقبولة كحالة تحميل عابرة.
