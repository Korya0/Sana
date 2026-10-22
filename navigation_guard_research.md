# حماية من فتح شاشتين في نفس الوقت — تقرير بحثي

> **الحالة: منفّذ بالخيار A.** القواعد في [`docs/ui/05_navigation.md`](docs/ui/05_navigation.md).

## 1. الخلاصة

**نعم، توجد حماية، لكن Flutter و`go_router` لا يوفّرانها جاهزة.**

الحل المقترح: **قفل مركزي حول التنقل** (Navigation Guard) يُفحص قبل أي `push` أو `go`
أو `showDialog` أو تبديل تبويب. أول طلب يمر ويُقفل الباب، وأي طلب آخر يُرفض حتى
تنتهي حركة الانتقال. هذا يحل الحالة التي وصفتها: أربعة أصابع على أربع بطاقات ←
شاشة واحدة فقط.

التكلفة صغيرة جدًا: `bool` + `Timer` + `NavigatorObserver`، بدون أي حزمة جديدة.

---

## 2. لماذا يحدث هذا في مشروعنا؟

### 2.1 كل زر له مستشعر لمس مستقل

`AppPressable` يستخدم `GestureDetector` مع `onTap`، وكل نسخة منه لها
`TapGestureRecognizer` خاص بها. نظام الإيماءات في Flutter يفصل **كل إصبع** في
«حلبة» (arena) مستقلة. لذلك:

- إصبع على بطاقة «الصباح» + إصبع على بطاقة «المساء» = مستشعران مختلفان.
- كلاهما يرى ضغطته صحيحة، وكلاهما ينفّذ `onTap`.
- لا يوجد في `AppPressable` أي علم عام يمنع الثاني.

### 2.2 التنقل نفسه لا يمنع التكرار

في `azkar_categories_grid.dart`:

```dart
onTap: () => context.pushNamed(
  AppRoutes.azkarCategoryPath,
  pathParameters: {AppRoutes.categoryIdParam: '${category.id}'},
  extra: category.title,
),
```

`pushNamed` لا يفحص «هل هناك انتقال شغّال؟». كل نداء يضيف صفحة إلى المكدس.
لذلك ضغطتان متزامنتان = صفحتان فوق بعضهما.

نفس الشيء ينطبق على:

- `AppBottomSheet.show` — ممكن يفتح شيتين.
- `CustomConfirmationDialog.show` — ممكن يفتح ديالوجين.
- `navigationShell.goBranch` في الشريط السفلي — ممكن يبدّل تبويبين بسرعة،
  والنتيجة يعتمد على ترتيب المعالجة (آخر واحد يفوز غالبًا، لكن ليس مضمونًا).

### 2.3 هل حركة الانتقال تحمي؟

لا تعتمد عليها. حتى لو كانت بعض إصدارات Flutter تتجاهل اللمس على الصفحة
الجديدة أثناء الحركة، فإن الضغطتين تكونان قد بدأتا **قبل** بدء الانتقال،
والـ callbacks الخاصة بهما تُنفَّذ بالتتابع في نفس دورة الأحداث. الانتقال يقلل
نافذة الخطأ لكنه لا يمنع النداءين.

---

## 3. ما لا يكفي وحده

| الحل | لماذا لا يكفي |
|---|---|
| `AbsorbPointer` يظهر بعد بدء الانتقال | الضغطة الثانية قد تكون قد اكتملت بالفعل ونُفِّذ callbackها |
| `IgnorePointer` على الصفحة الجديدة | لا يوقف الضغطات التي انطلقت من الصفحة القديمة |
| فحص «هل الشاشة الحالية هي الهدف؟» | لا يميز بين تصنيفين مختلفين، وكلاهما هدف صحيح |
| `debounce` عشوائي 200ms | قد يمرّ الإصبع الرابع بعد انتهائه، وقد يمنع تنقلًا مشروعًا |
| تعطيل اللمس المتعدد على مستوى النظام | غير متاح في Flutter، ويضر بالتمرير والتكبير |

---

## 4. الخيارات المتاحة

### الخيار A — قفل بوابة التنقل (موصى به)

فكرة واحدة: **كل تنقل يمر من مكان واحد**، وهذا المكان يملك قفلًا.

```text
ضغطة 1 → Guard.acquire() = true  → push → قفل
ضغطة 2 → Guard.acquire() = false → تُرفض فورًا
انتهاء الانتقال → Guard.release()
```

**المزايا:**

- يمنع الشاشتين، والديلوجين، والشيتين، وتبديل التبويبين.
- لا يمس التمرير ولا التكبير ولا اللمس المتعدد في غير التنقل.
- سلوك مفهوم: أول طلب يفوز.
- بدون تبعيات.

**العيوب:**

- يجب تحويل كل نقاط التنقل الحالية لتستخدم البوابة (عددها صغير الآن).
- يحتاج تحريرًا موثوقًا للقفل (Observer + مؤقت احتياطي).

### الخيار B — منع اللمس المتعدد على مستوى المؤشر

عدّاد أصابع عام في جذر التطبيق عبر `Listener`، و`AppPressable` يرفض الضغط إذا
كان الإصبع الثاني موجودًا.

**المزايا:** يمنع أي ضغطتين متزامنتين في التطبيق كله، وليس التنقل فقط.

**العيوب:**

- قد يرفض ضغطات شرعية (بعض المستخدمين يضغطون بإصبعين).
- يحتاج تنسيقًا دقيقًا بين `down` و`up`، وإلا رفض ضغطات عادية.
- لا يحل حالة «ضغطتان متتاليتان بسرعة» — يحتاج القفل مع ذلك.
- تعقيد أعلى مقابل فائدة إضافية محدودة.

**الخلاصة:** لا نبدأ به. يمكن إضافته لاحقًا كطبقة اختيارية إذا ظهرت حالات أخرى.

### الخيار C — منع تكرار نفس المسار

مقارنة الهدف بالموقع الحالي قبل `go`:

```dart
if (GoRouterState.of(context).uri.toString() == target) return;
```

مفيد لمنع `go` المكرر، لكنه لا يمنع تصنيفين مختلفين. **مكمّل، وليس بديلًا.**

### الخيار D — حاجز بصري أثناء الانتقال

طبقة شفافة (`AbsorbPointer`) فوق التطبيق طالما القفل مفعّل.

**المزايا:** تغذية بصرية واضحة أن التطبيق «مشغول».

**العيوب:** لا يمنع أول ضغطة ثانية إن وصلت قبل بناء الطبقة، ويضيف عنصرًا
لشجرة الواجهة. **اختياري، وليس خط الدفاع الأول.**

---

## 5. التصميم المقترح بالتفصيل

### 5.1 ملف جديد: `lib/core/router/app_navigation_guard.dart`

```dart
import 'dart:async';
import 'package:flutter/widgets.dart';

/// One door for navigation: the first request wins, the rest are dropped
/// until the route transition completes.
abstract final class AppNavigationGuard {
  static bool _locked = false;
  static Timer? _fallback;

  static bool get isLocked => _locked;

  /// Returns false when another navigation is already in flight.
  static bool acquire() {
    if (_locked) return false;
    _locked = true;
    // Safety net: never stay locked if no transition reports completion.
    _fallback = Timer(const Duration(milliseconds: 600), release);
    return true;
  }

  static void release() {
    _fallback?.cancel();
    _fallback = null;
    _locked = false;
  }

  /// Runs [action] only if no navigation is in flight.
  static void run(VoidCallback action) {
    if (!acquire()) return;
    action();
  }
}
```

### 5.2 مراقب التنقل: `lib/core/router/app_navigator_observer.dart`

```dart
import 'package:flutter/widgets.dart';
import 'package:sana/core/router/app_navigation_guard.dart';

class AppNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _releaseWhenCompleted(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) _releaseWhenCompleted(newRoute);
  }

  void _releaseWhenCompleted(Route<dynamic> route) {
    final animation = route.animation;

    if (animation == null || animation.status == AnimationStatus.completed) {
      AppNavigationGuard.release();
      return;
    }

    void listener(AnimationStatus status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        animation.removeStatusListener(listener);
        AppNavigationGuard.release();
      }
    }

    animation.addStatusListener(listener);
  }
}
```

### 5.3 تسجيل المراقب في `app_router.dart`

```dart
static final GoRouter router = GoRouter(
  initialLocation: AppRoutes.homePath,
  observers: [AppNavigatorObserver()],
  // ...
);
```

### 5.4 بوابة التنقل

```dart
abstract final class AppNavigator {
  static void pushNamed(
    BuildContext context,
    String name, {
    Map<String, String>? pathParameters,
    Object? extra,
  }) {
    AppNavigationGuard.run(() {
      context.pushNamed(
        name,
        pathParameters: pathParameters,
        extra: extra,
      );
    });
  }

  static void go(BuildContext context, String location) {
    AppNavigationGuard.run(() => context.go(location));
  }
}
```

### 5.5 نقاط الاستخدام الحالية

| المكان | التغيير |
|---|---|
| `azkar_categories_grid.dart` | `AppNavigator.pushNamed(...)` بدل `context.pushNamed` |
| `app_router.dart` (زر إعادة المحاولة) | `AppNavigator.go(...)` |
| `main_view.dart` (تبديل التبويب) | قفل مستقل بسيط أو نفس `acquire/release` مع تحرير بعد إطار |
| `app_bottom_sheet.dart` | `AppNavigationGuard.run(...)` حول `showModalBottomSheet` |
| `custom_confirmation_dialog.dart` | `AppNavigationGuard.run(...)` حول `showDialog` |
| `azkar_list_view.dart` (الخروج/المشاركة) | لا يتغير: `Navigator.pop` ليس فتح شاشة جديدة |

### 5.6 دورة القفل

```text
acquire() ──► push / go / dialog ──► didPush ──► animation completed
    │                                                    │
    └── fallback 600ms ─────────────────────────────────► release()
```

- القفل يُوضع **قبل** نداء التنقل، لذلك الضغطة الثانية لا تجد بابًا مفتوحًا.
- `didPush` يُحرّر عند اكتمال الحركة، لا عند إغلاق الشاشة.
- المؤقت الاحتياطي يمنع «قفلًا أبديًا» إذا لم تصل الحركة (مسار فوري، خطأ، تبويب).
- `AnimationStatus.dismissed` يُحرّر أيضًا احتياطًا لو رجع المستخدم أثناء الحركة.

### 5.7 لماذا لا نضع القفل داخل `AppPressable`؟

لأن `AppPressable` يخدم العدّادات والأزرار غير التنقّلية أيضًا. لو منعنا كل
ضغطة أثناء التنقل سنوقف التطبيق كله، ولو انتظرنا إشارة من التنقل نحتاج نفس
البنية المركزية. لذلك القفل عند **باب التنقل** أنظف وأدق.

---

## 6. الحالات الحدّية

| الحالة | السلوك المطلوب |
|---|---|
| ضغطتان على نفس البطاقة | `AppPressable` أصلًا يعطي ضغطة واحدة غالبًا؛ القفل يمنع أي تكرار |
| ضغطتان على بطاقتين مختلفتين | الأولى تفتح، الثانية تُرفض |
| ضغطة على تبويبين | تبديل واحد فقط |
| ضغطتان على «مشاركة» و«نسخ» | ليست تنقلًا؛ لا يتغير شيء |
| ديالوج + ضغط خلفه | القفل يمنع فتح ديالوج ثانٍ |
| رجوع سريع أثناء الانتقال | `dismissed` يُحرّر القفل |
| فشل المسار | المؤقت الاحتياطي يُحرّر بعد 600ms |
| deep link / إشعار | يمر عبر الراوتر مباشرة؛ القفل لا يعطله |
| إيماءات التمرير والتكبير | لا تتأثر إطلاقًا |

---

## 7. خطة التحقق

### يدويًا (الأهم)

1. فتح شاشة الأذكار.
2. وضع أربعة أصابع على أربع بطاقات تصنيف في نفس اللحظة.
3. النتيجة المتوقعة: **شاشة قارئ واحدة فقط** أو لا شيء، وليس أربع شاشات.
4. تجربة إصبعين على تبويبين في الشريط السفلي ← تبديل واحد.
5. ضغطتان سريعتان على نفس البطاقة ← شاشة واحدة.
6. رجوع عادي، تمرير، وتكبير ← لا تغيير.

### اختبار آلي (اختياري، يحتاج موافقة منفصلة)

```dart
final g1 = await tester.startGesture(tester.getCenter(card1));
final g2 = await tester.startGesture(tester.getCenter(card2));
await g1.up();
await g2.up();
await tester.pumpAndSettle();

expect(find.byType(AzkarListView), findsOneWidget);
```

---

## 8. التكلفة والمخاطر

| البند | التقدير |
|---|---|
| ملفات جديدة | 2 (Guard + Observer) |
| ملفات معدّلة | 4–5 |
| تبعيات جديدة | لا شيء |
| تأثير الأداء | لا يُذكر (فحص `bool`) |
| خطر قفل عالق | منخفض — مؤقت احتياطي + `dismissed` |
| خطر منع تنقل مشروع | منخفض — القفل لا يتجاوز مدة الانتقال |
| التوافق مع الويب/سطح المكتب | يعمل؛ `pushNamed` نفسه |

---

## 9. التوصية

**ننفّذ الخيار A فقط في البداية:**

1. `AppNavigationGuard` + `AppNavigatorObserver`.
2. تسجيل المراقب في `GoRouter`.
3. تحويل `pushNamed` و`go` والديالوج والشيت إلى البوابة.
4. قفل بسيط لتبديل التبويبات.
5. إضافة القاعدة إلى `docs/ui/04_tap.md` (قسم جديد: «Navigation is single-entry»)
   أو ملف `docs/ui/05_navigation.md` إذا رأيت أنه يستحق ملفًا مستقلًا.

**لا نضيف** عدّاد الأصابع العام (الخيار B) ولا الحاجز البصري (الخيار D) الآن؛
القفل المركزي يحل المشكلة بدون تعقيد إضافي.

---

## 10. قرار مطلوب

- [ ] موافق على التنفيذ بالخيار A.
- [ ] أريد الخيار A + حاجز بصري أثناء الانتقال.
- [ ] أريد تجربة الخيار B أيضًا (منع اللمس المتعدد).
- [ ] أريد التقرير فقط الآن، والنقاش قبل أي كود.
