# تحليل: `ZikrListView` و`ZikrCounter` — لماذا Stateful؟ وهل يؤثر على الأداء؟

> **نطاق هذا الملف:** يوثّق التحليل الذي سبق التعديل. قسم **«التنفيذ»** في نهاية الملف يوضح ما طُبّق فعليًا. لم تُشغَّل أي اختبارات، ولم يُعمل أي commit — بناءً على تعليماتك.

## الملفات التي تمت قراءتها

| الملف | الدور |
|---|---|
| `lib/features/azkar/presentation/views/zikr_list_view.dart` | الشاشة (233 سطر) |
| `lib/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_counter.dart` | عدّاد الذكر (303 سطر) |
| `lib/features/azkar/presentation/cubits/azkar/azkar_cubit.dart` + `azkar_state.dart` | حالة الأذكار والعدّادات |
| `lib/features/azkar/presentation/cubits/reading_settings/*` | حجم الخط وإعدادات القراءة |
| `lib/features/azkar/presentation/widgets/zikr_list/zikr_list_content.dart` | جسم القائمة (سلايفرز) |
| `lib/features/azkar/presentation/widgets/zikr_list/zikr_card/*` | الكارت + المحتوى + صف العدّاد |
| `lib/core/widgets/slivers/app_sliver_list.dart` | القائمة الكسولة |

---

## 1. `ZikrListView` — لماذا Stateful؟

### 1.1 الأعضاء التي تجعلها Stateful

| العضو | التصنيف | المبرر التقني | هل يصلح داخل Cubit؟ |
|---|---|---|---|
| `_scrollController` | View / lifecycle | يحتاج `initState` + `dispose` + `animateTo` + `hasClients` + `position.maxScrollExtent` | **لا.** الـ Cubit لا يملك `ScrollPosition`، ولا يجب أن يعرف `BuildContext` |
| `_canPop` | Navigation gate | يمنع الخروج من الشاشة قبل تأكيد المستخدم (`PopScope`) | **لا.** قرار واجهة لحظي، عمره = عمر الشاشة |
| `_isPopping` | Guard | يمنع تنفيذ `BlocListener` لنفس الحدث مرتين أثناء الخروج | **لا.** Guard خاص بالـ UI |
| `_scrollToNextItem` | Behavior | يقرأ `MediaQuery.sizeOf` + `ScrollController` + `AzkarCubit.state` | **لا.** يعتمد على View APIs |
| `_handleExit` | Navigation | `CustomConfirmationDialog` ثم `Navigator.pop` | **لا.** Navigation مسؤولية الـ View/الراوتر |

**الخلاصة:** الشاشة Stateful **لسبب واحد حقيقي** هو دورة حياة `ScrollController`، وسببين ثانويين هما بوابتا الخروج (`_canPop`, `_isPopping`). **لا توجد أي حالة عمل (business state) داخل `State`** — كل حالة الأذكار والعدّادات في `AzkarCubit`، وكل حالة إعدادات القراءة في `ReadingSettingsCubit`.

### 1.2 هل يؤثر ذلك على الأداء؟

**لا بشكل ملموس.** الأسباب:

1. `setState` يُستدعى **مرتين فقط** في عمر الشاشة:
   - عند اكتمال كل الأذكار (سطر 160)،
   - عند الخروج بعد التأكيد (سطر 95).
2. لا يوجد `addListener` على الـ ScrollController، ولا `Timer`، ولا عمل لكل إطار. الشاشة ساكنة تمامًا وقت التمرير.
3. الضغط على الكارت **لا يمر عبر `setState` إطلاقًا**، ومسار إعادة البناء محسوب بدقة:

```text
incrementZikr() → emit(AzkarLoaded جديد)
        │
        ├─ ZikrListContent.buildWhen: runtimeType فقط  → لا يُعاد بناؤه ✅
        │
        └─ كل ZikrItemCard.buildWhen: مقارنة عدّاده فقط
                 → كارت واحد يُعاد بناؤه ✅ (O(1))
                    → ZikrCounter يستقبل props جديدة → أنيميشن
```

النتيجة: تكلفة الضغطة = إعادة بناء كارت واحد + فحص O(n) رخيص في `buildWhen` لكل كارت. وهذا هو النمط الصحيح.

**ملاحظات أداء دقيقة (غير مؤثرة عمليًا، للمعرفة فقط):**

| النقطة | التقييم |
|---|---|
| `setState` يعيد بناء شجرة الشاشة كاملة (Providers + Listeners + Scaffold + Slivers) | مقبول: مرتين فقط في العمر، والبناء مجرد إنشاء Widgets رخيصة |
| `emit(copyWith(counters: {...counters}))` ينسخ الـ Map عند كل ضغطة | O(n) حيث n = عدد الأذكار في التصنيف (صغير) |
| `isAllCompleted` getter يُحسب في كل `listenWhen` | O(n) لكل تغيير حالة، مهمل |
| `MediaQuery.sizeOf(context)` داخل `Future.delayed` (سطر 63) | يسجّل dependency خارج `build`؛ يجعل الشاشة تُعاد بناؤها عند تغيّر حجم النافذة/الكيبورد. ليس خطأً، لكن الأولى قراءته في `build` أو قبل `delay` |
| `Future.delayed` غير قابل للإلغاء | محمي بـ `mounted` و`hasClients` — آمن |
| إنشاء الـ Cubits داخل `build()` عبر `MultiBlocProvider` | آمن: `create` يُنفَّذ مرة واحدة ولا يُعاد مع إعادة بناء الـ State |

### 1.3 لماذا لا نعمل Cubit (أو أكثر من Cubit) لهذه المهام؟

القاعدة الفاصلة: **الـ Cubit للحالة، والـ State للعرض.**

| ينتمي إلى Cubit | ينتمي إلى State |
|---|---|
| بيانات تُجلب من طبقة أعلى (أذكار/تصنيفات) | `ScrollController` ودورة حياته |
| حالة تُحفظ أو تُشارك بين شاشات (حجم الخط) | `PopScope` وبوابات الخروج |
| منطق له قواعد قابلة للاختبار (عدّاد، اكتمال) | حوارات ونافيجيشن لحظي |
| قيمة يجب أن تبقى بعد إعادة بناء الواجهة | أنيميشن مرتبط بالإطار (tickers) |
| حالة تُراقَب بـ `BlocBuilder` | `MediaQuery` / `ScrollPosition` / `FocusNode` |

المهام التي جعلت الشاشة Stateful هي كلها في العمود الأيمن — ولا واحدة منها قابلة للاختبار كمنطق مستقل، ولا واحدة منها تحتاج البقاء بعد إغلاق الشاشة.

**لماذا Cubit ثالث سيكون خطأً هندسيًا:**

1. سيضطر لامتلاك `ScrollController` أو استقباله — وهذا يسرّب مسؤولية العرض إلى الطبقة المنطقية.
2. سيحتاج `BuildContext`/`MediaQuery` لحساب مسافة التمرير — ممنوع في Cubit.
3. سيزيد عدد الـ Providers والـ boilerplate مقابل صفر مكسب في الاختبارية أو إعادة الاستخدام.
4. `_canPop` و`_isPopping` لا معنى لهما خارج عمر الشاشة؛ وضعهما في Cubit يخلق حالة "معلّقة" تحتاج تصفيرًا يدويًا.

### 1.4 لماذا يوجد Cubitan بالفعل؟ ولماذا هذان تحديدًا؟

التقسيم الحالي سليم لأنه يقسم حسب **المسؤولية**، لا حسب عدد المهام:

| Cubit | يملك | لماذا منفصل |
|---|---|---|
| `AzkarCubit` | تحميل الأذكار + العدّادات + العنوان + الاكتمال | محتوى الشاشة الأساسي، ويتغيّر مع كل ضغطة |
| `ReadingSettingsCubit` | `fontSize` + تحميل/حفظ الإعدادات | تفضيل قراءة مستقل، يتغيّر نادرًا، ويُستهلك في كل كارت |

لو دُمجا في Cubit واحد، لأدى تغيير حجم الخط إلى إعادة حساب/إعادة بناء مرتبطة بحالة العدّادات، والعكس. الفصل يمنح كل كارت `BlocBuilder` مستقلًا لكل مصدر.

### 1.5 متى نضيف Cubit جديدًا؟ (شروط واضحة)

أضِف Cubit فقط عند تحقق واحد أو أكثر من الآتي:

1. **بقاء الحالة:** نريد أن يستأنف المستخدم العدّادات بعد إغلاق الشاشة → هذا يحتاج `AzkarProgressCubit`/Repository وليس State.
2. **مشاركة بين شاشات:** نفس العدّاد يظهر في شاشة "المفضلة" أو "متابعة القراءة".
3. **منطق قابل للاختبار ومعقد:** قواعد اكتمال/أهداف يومية/سلاسل (streaks) تتجاوز `increment`.
4. **حالة الشاشة تُستعاد بعد `pop`:** لو أصبح التمرير أو موضع آخر عنصر جزءًا من تجربة يجب استعادتها (وهذا يبقى أنسب في View مع `PageStorageKey` لا Cubit).
5. **اختبار منطق الخروج/الاكتمال مطلوب:** حتى حينها، يُختبر `AzkarCubit` (وهو قابل للاختبار الآن) لا `_canPop`.

**قرار مقترح:** الإبقاء على `StatefulWidget` كما هي الآن. لا مبرر لـ Cubit ثالث.

### 1.6 ملاحظات دقيقة (بدون تعديل الآن)

- **`ZikrItemCard` Stateful بلا أي حقل حالة** — يمكن أن تكون `StatelessWidget`؛ لا يوجد `initState`/`dispose`/`setState` فيها. `_handlePress` تستخدم `context.read` فقط، وهذا متاح في Stateless. (ملاحظة الشاشة نفسها لا تتأثر.)
- **`_canPop` قبل `Navigator.pop()` مباشرة (سطر 160):** `Navigator.pop` البرمجي لا يمر عادةً بفحص `PopScope.canPop` (هذا الفحص يخص `maybePop` وزر الرجوع). لذا `setState` هناك قد يكون زائدًا؛ لكنه غير ضار ويُبقي الـ `PopScope` متسقًا. يستحق تحققًا قبل أي تبسيط.
- **`_isPopping` بدون `setState`:** صحيح ومقصود — لا يوجد أثر بصري.
- **`ZikrItemCardContent` يستخدم `AnimatedScale` + `AnimatedOpacity` عند الاكتمال:** هذا انتقال حالة وليس تأثير ضغط، لكنه "حركة/تغيير بصري"؛ يحتاج تأكيدًا صريحًا إن كان مسموحًا وفق `docs/ui/04_tap.md` (الذي يمنع أي movement كتأثير ضغط).
- **`ZikrActionsRow`:** `mainAxisAlignment: MainAxisAlignment.end` **متوافق** مع `docs/ui/01_layout.md` §2 (المسموح لليسار بصريًا في RTL)، وليس مخالفة.

---

## 2. `ZikrCounter` — لماذا Stateful؟ ولماذا الحجم كبير؟

### 2.1 لماذا Stateful؟ (مبرر كامل)

| السبب | التفصيل |
|---|---|
| `AnimationController` | يحتاج `TickerProvider` + `dispose`. القيمة `progress` تأتي من الأب، لكن **الحركة** تحتاج زمنًا وحالة داخلية |
| `didUpdateWidget` | يقارن `oldWidget.progress` بالجديد ويبدأ الحركة من القيمة الحالية `_animation.value` — لا يمكن فعل ذلك في Stateless |
| `_RollingNumber` | تحتفظ بـ `_incoming` و`_outgoing` و`AnimationController` ثانٍ + `statusListener` لتنظيف الرقم الخارج بعد انتهاء التدحرج |
| التاريخ (history) | أهم نقطة: لتدحرج رقم، يجب **تذكّر الرقم السابق**. الـ props تحمل الحالي فقط، وStateless لا يملك ذاكرة |

**الحكم:** Stateful هنا **مبرر بالكامل**، وليس خيارًا أسلوبيًا. أي محاولة لجعلها Stateless ستفقد أنيميشن التدحرج والـ progress ring.

### 2.2 لماذا الحجم 303 أسطر؟ (تفكيك فعلي)

| النطاق | الأسطر | المحتوى |
|---|---|---|
| 1–131 | ~131 | `ZikrCounter` + State: الحلقة (track + progress) + `AnimatedSwitcher` (رقم ↔ علامة اكتمال) |
| 133–303 | ~171 | `_RollingNumber`: محرك تدحرج الأرقام رقمًا رقمًا |

الحجم ناتج عن **تعقيد سلوكي حقيقي**، لا عن تكرار أو كود زائد:

1. ثلاث حركات مستقلة: حلقة التقدم، تبديل الرقم/العلامة، تدحرج كل رقم.
2. `reduceMotion` (احترام تقليل الحركة).
3. أرقام لاتينية داخل تطبيق RTL → `textDirection: TextDirection.ltr` + محاذاة بالقيمة المكانية.
4. عرض خانة موحّد لكل رقم كي لا "تهتز" الأرقام المجاورة.
5. قياس عرض الرقم عبر `TextPainter` لضبط الخانات.
6. إدارة `CurvedAnimation` وإعادة إنشائها وتنظيفها.

**هل يخالف الـ docs؟** لا:
- `docs/architecture/03_code_conventions.md` §Comments + `docs/ui/02_widgets.md` §3 يطلبان **private widget classes** بدل `_buildX()`، وهذا مطبّق عبر `_RollingNumber`.
- القاعدة تنص أن الـ private class تعيش في ملف مستهلكها — لذا **لا يصح** نقل `_RollingNumber` إلى ملف منفصل (خصوصية Dart على مستوى المكتبة، وسيضطر لأن يصبح public ويُصدَّر).
- لا توجد قاعدة "عدد أسطر أقصى" في المشروع.

**الحكم:** الحجم مقبول هيكليًا. التحسين الممكن هو **تقليل التعقيد** لا تقطيع الملف.

### 2.3 الأداء — ما يحدث فعليًا

#### أ) عند أول بناء لكل كارت (مشكلة حقيقية صغيرة)

```dart
// initState
_animation = _animate(widget.progress, widget.progress); // begin == end
unawaited(_controller.forward());                        // 300ms بلا تغيير بصري
```

كل كارت ظاهر على الشاشة يشغّل `AnimationController` لمدة 300ms عند أول ظهور، رغم أن القيمة لا تتغيّر (من `progress` إلى `progress`). النتيجة: ~18 إطارًا من إعادة بناء `AnimatedBuilder` + إعادة رسم لكل كارت بلا فائدة. التأثير محدود (يتزامن مع بناء القائمة نفسه)، لكنه إهدار مضمون وقابل للإزالة لاحقًا بشرط `if (begin != end)`.

#### ب) أثناء التغيير (المسار الطبيعي)

- `didUpdateWidget` ينشئ `Tween` + `CurvedAnimation` جديدين ويبدأ من 0 → 300ms.
- `AnimatedBuilder` يعيد بناء `SizedBox` + `CircularProgressIndicator` **كل إطار**.
- `_RollingNumber` يعيد بناء صف الخانات كل إطار، وينشئ `Text`/`TextSpan` جديدة لكل رقم → إعادة layout للنص كل إطار للرقم المتغيّر (وللثابت أيضًا).
- `AlwaysStoppedAnimation<Color>` تُنشأ كل إطار (تخصيص صغير متكرر).

#### ج) إعادة الرسم (نقطة تستحق القياس)

`ZikrItemCardContent` فيه `RepaintBoundary` واحد حول الكارت كاملًا. `CircularProgressIndicator` يرسم داخل هذا الحدود، لذا **إعادة رسم الحلقة كل إطار تعيد رسم محتوى الكارت بالكامل** (نص الذكر الطويل + الفاصل + العدّاد) خلال 300ms. إضافة `RepaintBoundary` حول `ZikrCounter` وحده تعزل إعادة الرسم في مساحة 56×56. هذا أهم تحسين أداء محتمل في هذا الملف، ويحتاج `Profile` mode للتأكيد قبل التنفيذ.

#### د) `_maxDigitWidth` — 10 عمليات layout

```dart
for (var digit = 0; digit <= 9; digit++) { TextPainter(...)..layout(); }
```

تُستدعى في كل `build` لـ `_RollingNumber` (أي عند كل تغيير قيمة، وعند كل إعادة بناء للأب) → 10 عمليات قياس نص. ليست لكل إطار، لكنها متكررة بلا داعٍ: النمط لا يتغيّر إلا مع تغيّر `style` (أي حجم الخط). القياس نفسه سليم (`dispose` يُستدعى ✅).

#### هـ) `reduceMotion` — ثغرة سلوكية

`animate` يُحترم في `AnimatedSwitcher` و`_RollingNumber`، لكن **حلقة التقدم تستمر في الحركة** لأن `_controller.forward(from: 0)` في `didUpdateWidget` غير مشروط بـ `context.reduceMotion`، ولا يمكن قراءة `context` هناك بأمان. هذا يخالف روح `docs/design_system/02_tokens.md` §5 (`context.reduceMotion` = تخطّي الحركة عند طلب المستخدم).

#### و) ازدواج مصدر الحقيقة

`ZikrCounter` يستقبل `remainingCount` و`progress` معًا، وهما مشتقّان من نفس الحقيقة (المتبقي والكل). لا يوجد ما يضمن تطابقهما؛ لو أخطأ الأب في أحدهما ستتناقض الحلقة والرقم. الأفضل لاحقًا: تمرير `completed`/`total` فقط وحساب الاثنين داخليًا (أو تمرير `progress` فقط واشتقاق المتبقي). هذا قرار API وليس تعديلًا فوريًا.

### 2.4 خيارات تقليل الحجم/التكلفة (بدون تنفيذ الآن)

| الخيار | الأثر | التكلفة | التوصية |
|---|---|---|---|
| تخطّي `forward()` عند `begin == end` | يوفّر 300ms × كل كارت عند أول ظهور | سطر واحد | ✅ يُنصح به لاحقًا |
| `RepaintBoundary` حول `ZikrCounter` | يعزل إعادة الرسم أثناء الأنيميشن | سطر واحد + قياس في Profile | ✅ يُنصح به بعد القياس |
| استخدام `AnimatedBuilder(child:)` وتخزين `Text` الثابتة | يقلّل layout النص لكل إطار | متوسط | ✅ تحسين مقبول |
| تخزين `_maxDigitWidth` وحسابه عند تغيّر `style` فقط | يحذف 10 قياسات لكل rebuild | صغير | ✅ تحسين مقبول |
| استخراج حلقة التقدم إلى `_ProgressRing` داخل نفس الملف | قراءة أوضح، نفس عدد الأسطر تقريبًا | صغير | اختياري |
| استبدال تدحرج الأرقام بـ `AnimatedSwitcher` واحد للرقم كاملًا | -~100 سطر | **يفقد سلوكًا مقصودًا** | ❌ يحتاج موافقة تصميم |
| نقل `_RollingNumber` لملف منفصل | لا شيء تقنيًا | يخالف قاعدة private class في ملف المستهلك | ❌ لا |

---

## 3. جدول القرار النهائي

| السؤال | الجواب |
|---|---|
| هل `ZikrListView` Stateful بمبرر؟ | **نعم.** `ScrollController` + بوابتا خروج. لا business state داخلها |
| هل يؤثر على الأداء؟ | **لا.** `setState` مرتين في العمر، ولا عمل لكل إطار |
| هل نحتاج Cubit ثالث؟ | **لا.** الحالة الحقيقية موزّعة بالفعل على Cubitين حسب المسؤولية |
| متى نضيف Cubit؟ | عند بقاء/مشاركة/اختبار منطق حقيقي (تخزين التقدم، أهداف يومية) |
| هل `ZikrCounter` Stateful بمبرر؟ | **نعم.** أنيميشن + ذاكرة القيمة السابقة + دورة حياة ticker |
| هل حجمها 303 سطر مشكلة؟ | **لا هيكليًا**؛ التعقيد سلوكي. التحسين = تبسيط، لا تقطيع |
| أكبر مكسب أداء محتمل | `RepaintBoundary` حول العدّاد + إلغاء حركة أول بناء بلا تغيير |
| أكبر فجوة سلوكية | حلقة التقدم لا تحترم `reduceMotion` |

---

## 4. أسئلة مفتوحة قبل أي تعديل

1. هل المطلوب أن تُحفظ العدّادات بعد الخروج من الشاشة؟ (حاليًا تُصفَّر عند كل `loadAzkar`.) لو نعم → هذا هو المبرر الحقيقي الوحيد لإضافة Cubit/Repository للتقدم.
2. هل `AnimatedScale`/`AnimatedOpacity` عند الاكتمال مقصودان ومُعتمدان تصميميًا، أم يدخلان تحت منع "الحركة" في `04_tap.md`؟
3. هل تدحرج الأرقام رقمًا رقمًا متطلب تصميمي ثابت، أم يمكن تبسيطه إلى تبديل رقم كامل لتقليل التعقيد؟
4. هل `ZikrItemCard` يمكن تحويلها إلى `StatelessWidget` (لا حالة فيها) ضمن تحسين قادم؟
5. هل تريد أن تكون حلقة التقدم ساكنة عند `reduceMotion`؟

> بعد إجاباتك على هذه النقاط يمكن كتابة خطة تعديل دقيقة، وتبقى القيود قائمة: **بدون اختبارات وبدون commit**.

---

## 5. التنفيذ — ما تم تطبيقه

**قراراتك:** الموافقة على كل التحسينات + **تصفير العدادات مقصود** (لذلك لم نُضف Cubit/Repository للتقدم؛ العدادات تبقى داخل `AzkarCubit` وتُصفَّر عند إعادة التحميل).

| # | الملف | التغيير | الأثر |
|---|---|---|---|
| 1 | `zikr_counter.dart` | حذف `forward()` الفارغ عند أول بناء (`begin == end`) | لا مزيد من 300ms عمل بلا تغيير بصري لكل كارت عند الظهور |
| 2 | `zikr_counter.dart` | `RepaintBoundary` حول العدّاد | إعادة رسم الحلقة لا تعيد رسم الكارت كاملًا |
| 3 | `zikr_counter.dart` | احترام `reduceMotion` لحلقة التقدم (عبر `didChangeDependencies`) | تخطّي حركة الحلقة عند طلب المستخدم، وإكمالها فورًا إن تغيّر الإعداد أثناء الحركة |
| 4 | `zikr_counter.dart` | تخزين `_slotWidth` وإعادة قياسه فقط عند تغيّر النمط/مقياس النص | حذف 10 عمليات `TextPainter` من كل rebuild |
| 5 | `zikr_counter.dart` | تخزين `Text` لكل رقم وإعادة استخدامه | لا إنشاء/إعادة layout لنص الأرقام في كل إطار |
| 6 | `zikr_counter.dart` | استخراج `_ProgressRing` + استخدام `color:` بدل `AlwaysStoppedAnimation` لكل إطار | بناء أوضح وتخصيصات أقل |
| 7 | `zikr_counter.dart` | API جديد: `completedCount` + `totalCount` بدل `remainingCount` + `progress` | مصدر حقيقة واحد للرقم والحلقة، واشتقاق `isCompleted` داخليًا |
| 8 | `zikr_actions_row.dart` | تمرير `completedCount`/`totalCount` واشتقاق المتبقي والاكتمال | إزالة الازدواج، والوصولية كما هي |
| 9 | `zikr_item_card.dart` | `ZikrItemCard` أصبحت `StatelessWidget` | لا حالة زائفة |
| 10 | `zikr_item_card.dart` | `ZikrItemCardContent` يستقبل `completedCount` بدل `remainingCount` + `progress` | تماشي مع API الجديد |
| 11 | `zikr_list_skeleton.dart` | تحديث الـ skeleton للـ API الجديد + `const` | لا أخطاء تحليل |
| 12 | `zikr_list_view.dart` | إزالة `_canPop` و`setState` قبل `Navigator.pop()`؛ `canPop: false` ثابت | تبسيط: `Navigator.pop()` البرمجي لا يمر بفحص `PopScope` (مؤكد من مصدر Flutter) |
| 13 | `zikr_list_view.dart` | استبدال `Future.delayed` و`MediaQuery.sizeOf` بـ `Timer` + `position.viewportDimension` | إلغاء قابل للتنظيف، ومسافة تمرير مبنية على الـ viewport الفعلي |
| 14 | `zikr_list_view.dart` | `_isExiting` + `_isCompleting` + إلغاء المؤقتات في `dispose` | منع حوارين/عمليتي pop متزامنتين |
| 15 | `zikr_state_analysis.md` | توثيق التنفيذ | مرجع للتغييرات |

### ما لم يُغيَّر عن قصد

- **`AnimatedScale` + `AnimatedOpacity` عند الاكتمال:** انتقال حالة وليس تأثير ضغط؛ يحتاج قرار تصميم منفصل قبل الحذف. أُبقي عليه كما هو.
- **`Row(mainAxisAlignment: MainAxisAlignment.end)` في `ZikrActionsRow`:** متوافق مع قواعد RTL في `docs/ui/01_layout.md`.
- **بنية الملف:** `_ProgressRing` و`_RollingNumber` بقيا داخل `zikr_counter.dart` كما تنص قاعدة الـ private class.

### نتيجة البوابة

```text
flutter analyze
No issues found!
```

**لم تُشغَّل اختبارات (`flutter test`)، ولم يُعمل أي commit — حسب تعليماتك.**
