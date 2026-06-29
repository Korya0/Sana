# تقرير تدقيق معماري — `daily_content`
**مقارنة بـ ARCHITECTURE_RUBRIC.md | مستوى التدقيق: أقصى دقة**

---

## 📊 ملخص تنفيذي

| الوحدة | الحالة | عدد المخالفات |
|--------|--------|--------------|
| Module 1-3: Fundamentals & SOLID | ⚠️ جزئي | 5 |
| Module 4-5: Software Quality | ⚠️ جزئي | 4 |
| Module 6: Project Organization | ⚠️ جزئي | 2 |
| Module 7: Layering | ❌ مخالفة | 3 |
| Module 8: Flutter Internal | ⚠️ جزئي | 4 |
| Module 9: Data & Communication Flow | ⚠️ جزئي | 2 |
| Module 10: Widget Composition | ⚠️ جزئي | 2 |
| Module 11: Reusability & Design System | ✅ جيد | 0 |
| Module 12: Cross-Cutting Concerns | ⚠️ جزئي | 3 |
| Module 13: Performance | ⚠️ جزئي | 0 |
| Module 14: Readability | ⚠️ جزئي | 0 |
| **المجموع** | | **31 مخالفة** _(بعد الجولة الثانية)_ |

### ✅ ما هو ممتاز في هذا الفيتشر:
- ✅ `IDailyContentRepository` interface موجود ويُستخدم في DI
- ✅ الـ DI يستخدم `registerLazySingleton` بشكل صحيح
- ✅ الـ State يحتوي على `==` و `hashCode` و `copyWith` يدوياً
- ✅ الـ Cubit يُدير `StreamSubscription` ويُلغيه في `close()` بشكل صحيح
- ✅ `compute` مُستخدم للـ JSON parsing
- ✅ `DailyContentKeys` constants ممتازة
- ✅ Generic `getDailyItem<T>` ممتاز من حيث التصميم

---

## 🏗️ Module 1-3: Fundamentals, Object Design & SOLID

### ❌ مخالفة #1 — SRP: `DailyContentCubit` يحمل مسؤوليات متعددة (God Cubit)
**الملف:** [daily_content_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/cubit/daily_content_cubit.dart#L14-L154)

```dart
class DailyContentCubit extends Cubit<DailyContentState> {
  // 1. تحميل البيانات من DataSource
  // 2. منطق التنقل بين الأيام (advanceCategoryIfNewDay)
  // 3. تحديد المحتوى اليومي (getDailyItem)
  // 4. إدارة المشاهدة (markViewed / wasViewedToday)
  // 5. إدارة المفضلة (toggle/isFavorite)
  // 6. الاستماع لتغييرات التاريخ (StreamSubscription)
  // 7. تنسيق التاريخ (_getTodayDateString)
```

**المشكلة:** الـ Cubit الواحد يجمع: content loading + day-advancement logic + favorites management + date-change listening + viewed tracking. هذا يعني أن أي تغيير في أي وظيفة يُخاطر بتأثير الوظائف الأخرى.

**الحل:** تقسيم إلى:
- `DailyContentCubit` → تحميل المحتوى وحالة الـ UI
- `DailyFavoritesCubit` → إدارة المفضلة
- أو على الأقل نقل الـ favorites methods إلى repository مع stream

---

### ❌ مخالفة #2 — SRP: `DailyContentDataSource` مكتوبة كـ static-only class (مشكلة testability + SRP)
**الملف:** [daily_content_datasource.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/data/datasources/daily_content_datasource.dart#L38-L62)

```dart
class DailyContentDataSource {
  static const String _jsonPath = AppAssets.dailyContent;
  static Map<String, List<DailyContentModel>>? _cachedContent; // static!
  static Future<Map<...>> loadDailyContent() async { ... }    // static!
}
```

**المشكلة:**
1. Class كاملة static → لا يمكن mock-ها أو inject-ها
2. لا يوجد `IDailyContentDataSource` interface
3. الـ Cubit يستدعيها مباشرةً: `DailyContentDataSource.loadDailyContent()` ← tight coupling

---

### ❌ مخالفة #3 — DIP: `DailyContentCubit` يستدعي `DailyContentDataSource` مباشرةً
**الملف:** [daily_content_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/cubit/daily_content_cubit.dart#L31)

```dart
final contentData = await DailyContentDataSource.loadDailyContent(); // ← coupling مباشر!
```

**المشكلة:** الـ Cubit (Presentation layer) يستدعي مباشرةً `DataSource` (Data layer) متجاوزاً الـ Repository تماماً. هذا يكسر:
1. **Dependency Inversion** — يجب الاعتماد على abstractions
2. **Layer Boundaries** — الـ Cubit لا يجب أن يعرف عن الـ DataSource

**الحل:** نقل `loadDailyContent()` إلى `IDailyContentRepository` وتنفيذها في `DailyContentRepoImpl`.

---

### ❌ مخالفة #4 — SRP: `DailyContentFavoritesView` تجمع UI + Repository access + Cubit access
**الملف:** [daily_content_favorites_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/views/daily_content_favorites_view.dart#L29)

```dart
class _DailyContentFavoritesViewState extends State<DailyContentFavoritesView> {
  final IDailyContentRepository repository = sl<IDailyContentRepository>(); // ← مباشر من sl!
  List<DailyContentModel> favorites = [];
  bool isLoading = true;
  // ...
  void _loadAllFavorites() {
    setState(() {
      favorites = repository.getFavorites(); // ← يتجاوز Cubit!
      ...
    });
  }
```

**المشكلة:**
1. الـ View تصل إلى `IDailyContentRepository` مباشرةً بدلاً من المرور بالـ Cubit
2. تدير local state (`favorites`, `isLoading`) بدلاً من الاعتماد على الـ Cubit state
3. تستدعي `sl<IDailyContentRepository>()` من الـ View — مخالفة لـ Clean Architecture

**الحل:** إضافة `getFavorites` إلى `DailyContentCubit` state، والاستماع للـ state من الـ View.

---

### ❌ مخالفة #5 — SRP + OCP: `DailyContentShareCard` تحتوي على string-matching logic
**الملف:** [daily_content_share_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/widgets/share_card/daily_content_share_card.dart#L31-L37)

```dart
if (department != null) {
  finalDepartment = department!;
} else {
  finalDepartment = title?.contains(AppStrings.hadith) == true
      ? AppStrings.fromHadith
      : AppStrings.fromSunnah; // ← string matching لتحديد النوع!
}
```

**المشكلة:** الـ Widget تُحدد نوع المحتوى (hadith/sunnah) عبر فحص إذا كان العنوان يحتوي على string محدد. هذا:
1. هش جداً — لو تغيّر string الـ title ينكسر التحديد
2. مسؤولية تحديد النوع يجب أن تكون في الـ Model نفسه (`DailyContentType` enum موجود بالفعل!)

**الحل:** تمرير `DailyContentType` مباشرةً للـ `DailyContentShareCard`:
```dart
DailyContentShareCard(
  category: hadith.category, // ← استخدام DailyContentType.hadith
  ...
)
```

---

## 🌟 Module 4-5: Software Quality & Scalability

### ❌ مخالفة #6 — Testability: `DailyContentDataSource` static تمنع الاختبار الكامل
**الملف:** [daily_content_datasource.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/data/datasources/daily_content_datasource.dart#L42-L44)

```dart
static Map<String, List<DailyContentModel>>? _cachedContent; // global mutable state
static Future<...> loadDailyContent() async { ... }
```

**المشكلة:** يستحيل:
1. كتابة unit test للـ Cubit بدون تحميل بيانات حقيقية من assets
2. اختبار سيناريو "فشل التحميل" لأن الـ cache static ويتسرب بين tests
3. استبدال الـ DataSource بـ mock implementation

---

### ❌ مخالفة #7 — Testability: `DailyContentCubit` يُطلق `loadDailyContent()` في الـ constructor
**الملف:** [daily_content_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/cubit/daily_content_cubit.dart#L16-L18)

```dart
DailyContentCubit(this.appDateCubit, this.repository)
  : super(const DailyContentState()) {
  unawaited(loadDailyContent()); // side-effect في الـ constructor
  _dateSubscription = appDateCubit.stream.listen((_) => _checkRefresh());
}
```

**المشكلة:** أي test يُنشئ `DailyContentCubit` سيُشغّل `loadDailyContent()` فوراً كـ side-effect غير متحكَّم فيه.

---

### ❌ مخالفة #8 — Predictability: `_FavoriteCard.onDelete` callback يُشغّل منطقاً معقداً
**الملف:** [daily_content_favorites_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/views/daily_content_favorites_view.dart#L72-L78)

```dart
onDelete: () async {
  await repository.toggleFavorite(item); // ← مباشر على Repository!
  _loadAllFavorites();                   // ← setState
  if (!context.mounted) return;          // ← mounted check بعد await ✅
  unawaited(context.read<DailyContentCubit>().refresh()); // ← refresh كامل!
},
```

**المشكلة:** عملية حذف المفضلة تستدعي:
1. Repository مباشرةً
2. setState محلي
3. Cubit.refresh() كاملة (تُعيد تحميل كل شيء!)

هذا يعني أن حذف مفضلة واحدة يُسبب إعادة تحميل كامل للمحتوى اليومي — أداء سيء وغير ضروري.

---

### ❌ مخالفة #9 — Equality: `DailyContentModel` لا يحتوي على `==` و `hashCode`
**الملف:** [daily_content_model.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/data/models/daily_content_model.dart#L5-L60)

```dart
class DailyContentModel {
  // لا يوجد == override
  // لا يوجد hashCode override
  // لكن يُستخدم في isFavorite:
}
```

**المشكلة حرجة:** في `DailyContentRepoImpl.isFavorite`:
```dart
return _cachedFavorites.any(
  (f) => f.content == item.content && f.category == item.category,
);
```

الـ equality مُنفَّذة يدوياً بمقارنة `content` + `category`. لكن في `daily_content_favorites_view.dart`:
```dart
keyFinder: (item, index) => ValueKey(item.hashCode), // ← hashCode الافتراضي (Object identity)!
```

`item.hashCode` يعتمد على **object identity** (العنوان في الذاكرة) وليس على المحتوى. هذا يعني أن الـ `ValueKey` لن يكون ثابتاً — كل مرة يُعاد بناء القائمة، الـ keys ستكون مختلفة.

---

## 📂 Module 6: Flutter Project Organization

### ❌ مخالفة #10 — Missing Barrel Files: لا توجد barrel files
**المشكلة:** لا يوجد `index.dart` على مستوى الفيتشر. الـ Dashboard أو أي feature تريد استخدام `DailyHadithCard` أو `DailySunnahCard` تستورد مباشرةً من مسارات داخلية.

---

### ❌ مخالفة #11 — Dead File: `daily_content_dialog.dart` فارغ
**الملف:** [daily_content_dialog.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/widgets/daily_content_dialog.dart)

```dart
// DELETED
// Replaced by showCustomInfoDialog in common overlays
```

**المشكلة:** الملف موجود فيزيائياً بدون محتوى. يجب حذفه نهائياً — وجوده مضلل للقراء.

---

## 🧱 Module 7: Layering Concepts

### ❌ مخالفة #12 — Layer Violation: `DailyContentCubit` يستورد ويستدعي `DailyContentDataSource` مباشرةً
**الملف:** [daily_content_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/cubit/daily_content_cubit.dart#L8+L31)

```dart
import 'package:sana/features/daily_content/data/datasources/daily_content_datasource.dart'; // ← Presentation imports Data!
...
final contentData = await DailyContentDataSource.loadDailyContent(); // ← يتجاوز Repository
```

**المشكلة:** الـ Presentation layer تستورد وتستدعي الـ Data layer مباشرةً متجاوزةً الـ Repository interface. الـ Cubit يجب أن يتحدث فقط مع `IDailyContentRepository`.

---

### ❌ مخالفة #13 — Layer Violation: `DailyContentFavoritesView` تستورد `IDailyContentRepository` و `DailyContentModel`
**الملف:** [daily_content_favorites_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/views/daily_content_favorites_view.dart#L14-L15)

```dart
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';
import 'package:sana/features/daily_content/data/repos/daily_content_repository.dart';
// View تستورد من Data layer مباشرةً!
```

**المشكلة:** الـ View:
1. تحمل `IDailyContentRepository` كـ field مباشر
2. تستخدم `DailyContentModel` مباشرةً من `data/models`
3. تستدعي `sl<IDailyContentRepository>()` داخلها

---

### ❌ مخالفة #14 — Layer Violation: الـ DI يُسجّل `DailyContentCubit` كـ LazySingleton
**الملف:** [daily_content_di.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/di/daily_content_di.dart#L12-L17)

```dart
..registerLazySingleton<DailyContentCubit>(
  () => DailyContentCubit(sl<AppDateCubit>(), sl<IDailyContentRepository>()),
);
```

**المشكلة:** تسجيل الـ Cubit كـ `LazySingleton` معناه أن **نفس instance** يُستخدم في كل الشاشات. في `daily_content_routes.dart`:
```dart
child: BlocProvider.value(
  value: sl<DailyContentCubit>(), // ← نفس singleton للـ Favorites view!
```

لكن `DailyContentFavoritesView` **تتجاهل** الـ Cubit وتصل للـ Repository مباشرةً — وهذا يكشف أن الـ state management غير متسق. إذا كان Singleton، لماذا الـ View لا تستخدم الـ state منه؟

---

## 🌳 Module 8: Flutter Internal Architecture

### ❌ مخالفة #15 — BuildContext across async gap: Share في `_FavoriteCard`
**الملف:** [daily_content_favorites_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/views/daily_content_favorites_view.dart#L166-L176)

```dart
onSharePressed: () async => WidgetToImageHelper.shareWidget(
  context: context, // ← context من BlocBuilder محتمل unmounting
  widget: DailyContentShareCard(...),
  imageName: 'share_favorite_${item.hashCode}',
),
```

**المشكلة:** `context` يُمرَّر لعملية async بدون `mounted` check. الـ `_FavoriteCard` هو `StatelessWidget` — لا يوجد `mounted` property له — لكن الـ `context` قد يكون غير صالح بعد الـ async.

---

### ❌ مخالفة #16 — BuildContext across async gap: Share في `DailyHadithCard` و `DailySunnahCard`
**الملفات:**
- [daily_hadith_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/widgets/card/daily_hadith_card.dart#L44-L52)
- [daily_sunnah_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/widgets/card/daily_sunnah_card.dart#L44-L52)

```dart
onSharePressed: () async => WidgetToImageHelper.shareWidget(
  context: context, // ← context بدون mounted check
  ...
),
```

**المشكلة:** نفس المشكلة السابقة في كلا الـ widgets.

---

### ❌ مخالفة #17 — BuildContext across async gap: Copy في `DailyHadithCard` و `DailySunnahCard`
**الملفات:**
- [daily_hadith_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/widgets/card/daily_hadith_card.dart#L53-L57)
- [daily_sunnah_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/widgets/card/daily_sunnah_card.dart#L53-L57)

```dart
onCopyPressed: () async {
  final text = '${hadith.header ?? ""}\n${hadith.content}\n${hadith.attribution ?? ""}';
  await Clipboard.setData(ClipboardData(text: text.trim()));
  // لا try/catch، لا feedback، لا mounted check
},
```

**المشكلة:** Copy logic بدون error handling وبدون أي feedback للمستخدم. كذلك بدون `mounted` check للـ context.

---

### ❌ مخالفة #18 — Widget Lifecycle: `DailyContentFavoritesView` تستخدم `isLoading` state لا معنى له
**الملف:** [daily_content_favorites_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/views/daily_content_favorites_view.dart#L31-L43)

```dart
bool isLoading = true; // ← دائماً true ثم false فوراً

@override
void initState() {
  super.initState();
  _loadAllFavorites(); // ← synchronous في الواقع!
}

void _loadAllFavorites() {
  setState(() {
    favorites = repository.getFavorites(); // ← عملية sync (لا await)!
    isLoading = false;
  });
}
```

**المشكلة:** `getFavorites()` هي عملية **sync** (ترجع `_cachedFavorites` مباشرةً). الـ `isLoading = true` في البداية ثم `false` فوراً لا معنى له — لن يُرى أي loading indicator. الكود مُعقَّد بدون فائدة، ولا يُستخدم `isLoading` في الـ build method أصلاً!

---

## 🔄 Module 9: Data & Communication Flow

### ❌ مخالفة #19 — State Modeling: لا يوجد Freezed (لكن `==` موجود يدوياً)
**الملف:** [daily_content_state.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/cubit/daily_content_state.dart#L36-L44)

```dart
DailyContentState copyWith({
  DailyContentStatus? status,
  DailyContentModel? dailyHadith,
  DailyContentModel? dailySunnah,
  // ← لا يمكن تعيين dailyHadith = null بعد تحميله!
```

**مشكلة حرجة في `copyWith`:** لا يمكن تمرير `null` لتصفير `dailyHadith` أو `dailySunnah` بعد تحميلهما. مثلاً لو أردت emit حالة "failed" وتصفير البيانات:
```dart
emit(state.copyWith(
  status: DailyContentStatus.failure,
  dailyHadith: null, // ← لن يُطبَّق! سيُستخدم this.dailyHadith
));
```

هذا Bug حقيقي — `copyWith` لا تدعم تعيين optional fields إلى `null`.

---

### ❌ مخالفة #20 — Unidirectional Flow مكسور: الـ Favorites View تُعيد تحميل البيانات من مصدرين
**المشكلة:** عند حذف مفضلة:
1. `repository.toggleFavorite(item)` → يُحدّث `_cachedFavorites` في الـ Repository
2. `_loadAllFavorites()` → setState يقرأ من `repository.getFavorites()` مباشرةً
3. `DailyContentCubit.refresh()` → يُعيد تحميل كل شيء من الـ DataSource

ثلاثة مصادر مختلفة للـ data flow في عملية واحدة — هذا يُخفق في الـ Unidirectional Data Flow principle.

---

## 🧩 Module 10: Widget Composition

### ❌ مخالفة #21 — Code Duplication: `DailyHadithCard` و `DailySunnahCard` متطابقتان تقريباً
**الملفات:**
- [daily_hadith_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/widgets/card/daily_hadith_card.dart)
- [daily_sunnah_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/widgets/card/daily_sunnah_card.dart)

```dart
// DailyHadithCard:
BlocBuilder<DailyContentCubit, DailyContentState>(
  builder: (context, state) {
    final hadith = state.dailyHadith; // ← الفرق الوحيد
    if (hadith == null) return const SizedBox.shrink();
    return DailyContentBaseCard(
      title: AppStrings.hadithOfTheDay,          // ← مختلف
      icon: FlutterIslamicIcons.mohammad,        // ← مختلف
      isFavorite: state.isHadithFavorite,        // ← مختلف
      onFavoriteToggle: () => cubit.toggleHadithFavorite(), // ← مختلف
      onTap: () { cubit.markHadithAsViewed(); ... },        // ← مختلف
      ...
    );
  },
);

// DailySunnahCard: نفس الكود مع sunnah بدل hadith!
```

**المشكلة:** 90% من الكود مكرر. يجب دمجهما في widget واحد parametrized:
```dart
class DailyContentCard extends StatelessWidget {
  const DailyContentCard({required this.type, super.key});
  final DailyContentType type;
  // ...
}
```

---

### ❌ مخالفة #22 — Smart Widget: `_FavoriteCard` يحتوي على تفاصيل layout معقدة + logic
**الملف:** [daily_content_favorites_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/views/daily_content_favorites_view.dart#L97-L249)

**المشكلة:** `_FavoriteCard` هو widget خاص (`_`) داخل ملف الـ View (152 سطراً). يحتوي على:
- Layout معقد (Stack + Positioned + Column + Row + Row)
- Delete + Share + Copy + Explanation logic
- TextButton مُنسَّق يدوياً داخله

يجب استخراجه إلى ملف منفصل `daily_content_favorite_card.dart`.

---

## ⚙️ Module 12: Cross-Cutting Concerns

### ❌ مخالفة #23 — Error Handling: `Clipboard.setData` بدون error handling أو feedback
**الملفات:** [daily_hadith_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/widgets/card/daily_hadith_card.dart#L53-L57), [daily_sunnah_card.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/widgets/card/daily_sunnah_card.dart#L53-L57), [daily_content_favorites_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/views/daily_content_favorites_view.dart#L177-L183)

```dart
onCopyPressed: () async => Clipboard.setData(
  ClipboardData(text: '...'),
  // لا try/catch، لا SnackBar، لا AppLogger
),
```

**المشكلة:** ثلاثة أماكن تنسخ للـ clipboard بدون:
1. أي feedback للمستخدم (لا SnackBar يؤكد النسخ)
2. Error handling (لو فشل setData لن يعلم المستخدم)

---

### ❌ مخالفة #24 — Error Handling: Share بدون error handling في ثلاثة أماكن
**الملفات:** نفس الثلاثة ملفات

```dart
onSharePressed: () async => WidgetToImageHelper.shareWidget(...),
// لا try/catch في أي منها
```

---

### ❌ مخالفة #25 — Logging: `_loadFavoritesFromPrefs` تُعيد `[]` عند الخطأ بصمت
**الملف:** [daily_content_repository.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/data/repos/daily_content_repository.dart#L200-L218)

```dart
List<DailyContentModel> _loadFavoritesFromPrefs() {
  ...
  try {
    ...
    return decoded.map((e) {
      final categoryName = map[DailyContentKeys.category] as String?;
      final category = categoryName == DailyContentType.sunnah.name
          ? DailyContentType.sunnah
          : DailyContentType.hadith; // ← لو category = null أو غير معروف → يُعامَل كـ hadith!
      return DailyContentModel.fromJson(map, category);
    }).toList();
  } on Exception catch (e, stack) {
    unawaited(AppLogger.error('LoadFavorites Error', ...));
    return []; // ← يُخفي خطأ بيانات المفضلة!
  }
}
```

**مشكلتان:**
1. إرجاع `[]` عند parsing error → المستخدم يفقد مفضلاته بصمت
2. الـ `categoryName` يُعامَل كـ hadith افتراضياً حتى لو كان `null` — لا error أو warning

---

## 🏆 ملخص المخالفات حسب الأولوية

### 🔴 عالية الخطورة (يجب إصلاحها فورًا)
| # | المخالفة | الملف |
|---|----------|-------|
| **#3** | `DailyContentCubit` يستدعي `DailyContentDataSource` متجاوزاً الـ Repository | `daily_content_cubit.dart` |
| **#9** | `DailyContentModel.hashCode` غير override → `ValueKey(item.hashCode)` غير موثوق | `daily_content_model.dart` |
| **#12** | Presentation تستورد Data layer مباشرةً | `daily_content_cubit.dart` |
| **#19** | `copyWith` لا تدعم تعيين nullable fields إلى `null` — **Bug حقيقي** | `daily_content_state.dart` |

### 🟠 متوسطة الخطورة
| # | المخالفة | الملف |
|---|----------|-------|
| **#1** | God Cubit — مسؤوليات متعددة | `daily_content_cubit.dart` |
| **#2** | DataSource static بلا interface | `daily_content_datasource.dart` |
| **#4** | View تصل إلى Repository مباشرةً | `daily_content_favorites_view.dart` |
| **#6** | Static cache يمنع الاختبار | `daily_content_datasource.dart` |
| **#7** | Side-effect في constructor | `daily_content_cubit.dart` |
| **#8** | Cubit.refresh() كاملة لحذف مفضلة واحدة | `daily_content_favorites_view.dart` |
| **#13** | View تستورد Data Model و Repository | `daily_content_favorites_view.dart` |
| **#14** | Cubit كـ LazySingleton والـ View تتجاهله | `daily_content_di.dart` |
| **#20** | Unidirectional flow مكسور في الـ Favorites | `daily_content_favorites_view.dart` |
| **#21** | `DailyHadithCard` و `DailySunnahCard` كود مكرر | كلا الملفين |

### 🟡 منخفضة الخطورة
| # | المخالفة | الملف |
|---|----------|-------|
| **#5** | `DailyContentShareCard` string-matching لتحديد النوع | `daily_content_share_card.dart` |
| **#10** | لا barrel files | المجلد الجذر |
| **#11** | `daily_content_dialog.dart` ملف ميت | `presentation/widgets/` |
| **#15** | Share context بدون mounted check في Favorites | `daily_content_favorites_view.dart` |
| **#16** | Share context بدون mounted check في Cards | `daily_hadith_card.dart` + `daily_sunnah_card.dart` |
| **#17** | Copy بدون error handling أو feedback | كل الـ cards |
| **#18** | `isLoading` state عديم الفائدة | `daily_content_favorites_view.dart` |
| **#22** | `_FavoriteCard` ضخم داخل ملف الـ View | `daily_content_favorites_view.dart` |
| **#23** | Copy بدون error handling أو feedback (3 أماكن) | متعددة |
| **#24** | Share بدون error handling (3 أماكن) | متعددة |
| **#25** | `_loadFavoritesFromPrefs` تُرجع `[]` بصمت | `daily_content_repository.dart` |
| **#26** | Sunnah favorites loaded as Hadith (Category corruption) | `daily_content_model.dart` |
| **#27** | تخطي العنصر الأول عند أول تشغيل (Skip Index 0) | `daily_content_repository.dart` |
| **#28** | عدم تحديث كارت الأسماء الحسنى اليومي مع التاريخ | `daily_content_cubit.dart` |
| **#29** | استخدام `NestedScrollView` بدون داعٍ (Redundant Layout) | `daily_content_favorites_view.dart` |
| **#30** | عدم وجود حماية من استدعاءات `loadDailyContent` المتزامن | `daily_content_cubit.dart` |
| **#31** | ملف ميت `daily_content_dialog.dart` | `daily_content_dialog.dart` |

---

## 🔍 جولة ثانية — مخالفات إضافية

### 🔴 مخالفة #26 — Bug حقيقي: Sunnah favorites loaded as Hadith (Category corruption)
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

**المشكلة الحرجة:** عند حفظ أي محتوى من نوع "Sunnah" في المفضلة، يتم حفظه بدون مفتاح الـ category. وعند استرجاع المفضلات، يتم إسناد نوع `hadith` افتراضياً لكل ما هو null. النتيجة: **كل السنن المفضلة تتحول إلى أحاديث في شاشة المفضلة!**

---

### 🔴 مخالفة #27 — Bug حقيقي: تخطي العنصر الأول عند أول تشغيل (Skip Index 0)
**الملف:** [daily_content_repository.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/data/repos/daily_content_repository.dart#L76-L90)

```dart
final lastDate = _prefs.getString(_dateKey(category));
if (lastDate != todayDate) { // ⚠️ عند أول تشغيل lastDate = null
  await _advanceIndex(category, totalCount); // ⚠️ يتم تقديم المؤشر فوراً!
  await _prefs.setString(_dateKey(category), todayDate);
```

**المشكلة:** عند تثبيت التطبيق لأول مرة، يكون `lastDate` قيمته `null` وبالتالي `null != todayDate` تعطي `true`. يتم استدعاء `_advanceIndex` الذي يغير الـ index الافتراضي من `null/0` إلى `1`. النتيجة: **المستخدم لن يرى العنصر الأول (index 0) في قائمة التشغيل المشوشة أبداً!**

---

### 🔴 مخالفة #28 — Bug/UX: عدم تحديث كارت الأسماء الحسنى اليومي مع التاريخ
**الملفات:** 
- [home_daily_wisdom_section.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/home/presentation/widgets/sections/home_daily_wisdom_section.dart#L52)
- [daily_content_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/cubit/daily_content_cubit.dart#L18)

**المشكلة:**
بينما الـ `DailyContentCubit` يستمع لـ `AppDateCubit` ويقوم بتحديث كروت الحديث والسنة تلقائياً عند تغيير اليوم (عبر `_dateSubscription`)، فإن كارت الأسماء الحسنى اليومي `DailyAsmaUlHusnaCard` يعتمد على `AsmaUlHusnaCubit` (المنشأ بشكل منفصل في `HomeView`) والذي **لا يستمع** لأي تحديث للتاريخ. إذا تغير اليوم والتطبيق مفتوح، ستتحدث كروت الأذكار بينما يظل كارت الأسماء الحسنى قديماً.

---

### 🟠 مخالفة #29 — Performance: استخدام `NestedScrollView` بدون داعٍ (Redundant Layout)
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

### 🟠 مخالفة #30 — Concurrency: عدم وجود حماية من استدعاءات `loadDailyContent` المتزامنة
**الملف:** [daily_content_cubit.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/cubit/daily_content_cubit.dart#L25)

```dart
Future<void> loadDailyContent() async {
  // ⚠️ لا توجد حماية أو boolean flag لمنع استدعاء الدالة بشكل متزامن.
  // إذا أطلق الـ date stream عدة أحداث متتالية، سيتم تشغيل I/O والـ parsing بشكل متوازٍ مما قد يسبب race condition.
```

---

### 🟡 مخالفة #31 — Clean Code: ملف ميت `daily_content_dialog.dart`
**الملف:** [daily_content_dialog.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/daily_content/presentation/widgets/daily_content_dialog.dart)

```dart
// DELETED
// Replaced by showCustomInfoDialog in common overlays
```

**المشكلة:** الملف فارغ ومحذوف منطقياً ولكن لا يزال موجوداً في هيكل المشروع. يكسر نظافة الكود (Discoverability & Simplicity).


---

## 📈 مقارنة مع الفيتشرات السابقة

| الجانب | asma_ul_husna | azkar | daily_content | التقييم |
|--------|--------------|-------|---------------|---------|
| DataSource Interface | ❌ | ✅ | ❌ | يحتاج إصلاح |
| Repository Interface | ❌ | ✅ | ✅ | daily_content أفضل من asma |
| State == & hashCode | ❌ | ❌ | ✅ (يدوي) | daily_content الأفضل |
| Static Cache | ❌ | ❌ | ❌ | كلها مشكلة |
| Side-effect في Constructor | ⚠️ | ❌ | ❌ | مشكلة مشتركة |
| Layer Violations | 3 | 3 | 3 | متساوية |
| Error Handling | ❌ | ❌ | ❌ | مشكلة مشتركة |
| God Cubit | ❌ | ✅ | ❌ | azkar الأفضل |
| Code Duplication | ⚠️ | ✅ | ❌ (2 cards) | azkar الأفضل |
| **عدد المخالفات** | **32** | **27** | **25** | **daily_content الأفضل** |
