# 🔍 مزية البحث في الأحاديث (hadith_search)

## نظرة عامة

مزية `hadith_search` تُمكّن المستخدم من البحث في قاعدة بيانات ضخمة من الأحاديث النبوية الشريفة عبر الإنترنت. تدعم المزية البحث بكلمات دقيقة، عرض النتائج مع الحكم على صحة الحديث (صحيح، ضعيف، إلخ)، ومشاركة الأحاديث أو نسخها. كما تدعم **التحميل اللانهائي (Pagination)** لعرض آلاف النتائج بسلاسة.

---

## 📁 هيكل الملفات

```
hadith_search/
├── data/
│   ├── datasources/
│   │   ├── hadith_remote_data_source.dart   ← الاتصال بـ API (Dorar)
│   │   └── i_hadith_remote_data_source.dart  ← واجهة برمجية للمصدر
│   ├── models/
│   │   └── hadith_model.dart                ← تحويل JSON لبيانات
│   ├── repositories/
│   │   └── hadith_repository.dart           ← معالجة أخطاء الشبكة
│   └── utils/
│       └── hadith_html_parser.dart          ← تحليل محتوى HTML من الـ API
├── domain/
│   ├── entities/
│   │   └── hadith_entity.dart               ← كينونة البيانات الأساسية
│   ├── repositories/
│   │   └── i_hadith_repository.dart         ← واجهة المستودع
│   └── use_cases/
│       └── search_hadith_use_case.dart      ← منطق البحث الرئيسي
├── presentation/
│   ├── controller/
│   │   └── hadith_search/
│   │       ├── hadith_search_cubit.dart     ← المتحكم في البحث
│   │       └── hadith_search_state.dart     ← حالات البحث
│   ├── views/
│   │   └── hadith_search_view.dart          ← الشاشة الرئيسية للبحث
│   └── widgets/
│       ├── hadith_item_card.dart            ← بطاقة عرض الحديث
│       ├── hadith_search_text_field.dart    ← حقل إدخال البحث
│       ├── suggestions_grid.dart            ← كلمات مقترحة للبحث
│       └── skeletonizer_loading_hadith_view.dart ← شاشة التحميل الهيكلية
└── utils/
    └── hadith_formatter.dart                ← تنسيق النصوص وتلوين الأحكام
```

---

## 📦 طبقة البيانات والمنطق (Data & Domain)

### `hadith_model.dart` — نموذج البيانات
يحول البيانات القادمة من API "الدرر السنية" (Dorar) إلى كائنات برمجية. يدعم صيغتين من البيانات: JSON مباشر أو محتوى HTML يحتاج لتحليل (Parser).

### `hadith_repository.dart` — المستودع
يتعامل مع طلبات البحث ويحول أخطاء `Dio` (مثل انقطاع الإنترنت) إلى `Failure` يفهمه التطبيق لعرض رسائل خطأ واضحة للمستخدم.

### `hadith_search_cubit.dart` — المتحكم
يدير عملية البحث والتحميل الإضافي.
- **`searchHadith(query)`**: يبدأ بحثاً جديداً من الصفحة رقم 1.
- **`loadMoreHadiths()`**: يُستدعى عند تمرير المستخدم لنهاية القائمة لجلب الصفحة التالية تلقائياً.

---

## 🧠 طبقة العرض (Presentation Layer)

### `hadith_search_view.dart` — الشاشة الرئيسية
تُدير حالة الإدخال والتمرير.
- **Debouncing**: ينتظر 500ms بعد توقف المستخدم عن الكتابة قبل بدء البحث لتوفير موارد الشبكة.
- **Lazy Loading**: تستخدم `ScrollController` لرصد الوصول لنهاية القائمة وإطلاق طلب الصفحة التالية.

### `hadith_item_card.dart` — بطاقة الحديث
تعرض الحديث بتنسيق أنيق:
- **تلوين الأحكام**: يظهر شريط جانبي ملون حسب درجة الحديث (أخضر للصحيح، أحمر للضعيف، إلخ).
- **تمييز الكلمات**: يتم تمييز كلمة البحث داخل نص الحديث بلون ذهبي.
- **البيانات**: الراوي، المحدث، المصدر، الصفحة، وحكم المحدث.

### `suggestions_grid.dart` — كلمات مقترحة
تعرض مجموعة من الكلمات الشائعة (مثل: "الصلاة"، "النية"، "صيام") لمساعدة المستخدم على البدء بسرعة.

---

## 🔄 تدفق عملية البحث

```
المستخدم يكتب "الصلاة"
      ↓
انتظار 500ms (Debounce)
      ↓
HadithCubit.searchHadith("الصلاة")
  → emit(HadithLoading)
      ↓
SearchHadithUseCase(query)
  → HadithRepository.searchHadith(query, page: 1)
      ↓
HadithRemoteDataSource (Dorar API)
  → استلام JSON/HTML
  → HadithHtmlParser (إذا كان HTML)
      ↓
Cubit → emit(HadithSuccess)
      ↓
View → ListView.builder → HadithItemCard
```

---

## 🎨 التنسيق والألوان (HadithFormatter)

المزية تستخدم نظام تلوين ذكي بناءً على حكم المحدث:
- **صحيح / حسن**: أخضر (`AppColors.emerald`)
- **ضعيف / باطل / منكر**: أحمر (`AppColors.error`)
- **موضوع**: أحمر داكن
- **أحكام أخرى**: ذهبي أو رمادي

---

## 📦 المكتبات المستخدمة

| المكتبة | الغرض |
|---------|-------|
| `dio` | الاتصال بـ API الخارجي |
| `html` | تحليل (Parsing) محتوى HTML |
| `flutter_bloc` | إدارة حالة البحث |
| `skeletonizer` | تأثير التحميل الهيكلي |
| `equatable` | مقارنة الكائنات والحالات |
