# 🔍 مزية البحث في الأحاديث (hadith_search)

## نظرة عامة

مزية `hadith_search` تُمكّن المستخدم من البحث في قاعدة بيانات ضخمة من الأحاديث النبوية الشريفة عبر الإنترنت. تدعم المزية البحث بكلمات دقيقة، عرض النتائج مع الحكم على صحة الحديث (صحيح، ضعيف، إلخ)، ومشاركة الأحاديث أو نسخها. كما تدعم **التحميل اللانهائي (Pagination)** لعرض آلاف النتائج بسلاسة، ونظام **المفضلة** لحفظ الأحاديث محلياً.

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
│   │   ├── hadith_repository.dart           ← معالجة أخطاء الشبكة
│   │   └── hadith_favorites_repository.dart  ← إدارة المفضلة محلياً (ILocalStorageService )
│   └── utils/
│       └── hadith_html_parser.dart          ← تحليل محتوى HTML من الـ API
├── domain/
│   ├── entities/
│   │   └── hadith_entity.dart               ← كينونة البيانات الأساسية
│   ├── repositories/
│   │   ├── i_hadith_repository.dart         ← واجهة مستودع البحث
│   │   └── i_hadith_favorites_repository.dart ← واجهة مستودع المفضلة
│   └── use_cases/
│       └── search_hadith_use_case.dart      ← منطق البحث الرئيسي
├── presentation/
│   ├── controller/
│   │   ├── hadith_search/                   ← إدارة حالة البحث والنتائج
│   │   └── hadith_favorites/                ← إدارة حالة المفضلة
│   ├── views/
│   │   ├── hadith_search_view.dart          ← شاشة البحث الرئيسية
│   │   └── hadith_favorites_view.dart       ← شاشة الأحاديث المحفوظة
│   └── widgets/ ...
```

---

## 🏗️ التصميم المعماري (Clean Architecture)

تلتزم الميزة بنمط **Clean Architecture** بالكامل:
1. **Entities**: تعبر عن البيانات المستقلة عن أي مصدر خارجي.
2. **Use Cases**: تفصل منطق العمل (مثل البحث) عن واجهة المستخدم.
3. **Repository Pattern (DIP)**: يتم الاعتماد على الواجهات (`Interfaces`).
   - *تحسين*: يعتمد `HadithFavoritesRepository` على واجهة `ILocalStorageService ` بدلاً من المكتبة مباشرة لضمان سهولة الاختبار.

---

## 🧠 طبقة العرض (Presentation Layer)

### `HadithCubit` & `HadithFavoritesCubit`
- **Search Cubit**: يدير البحث اللحظي، الـ Debouncing، والتحميل الإضافي (Pagination).
- **Favorites Cubit**: يدير إضافة/حذف الأحاديث من القائمة المحلية وضمان تحديث الواجهة فوراً.

### المميزات التقنية:
- **HTML Parsing**: يتم تحليل رد الـ API الذي يحتوي على HTML لعرض نص نظيف.
- **Lazy Loading**: جلب بيانات إضافية عند الوصول لآخر القائمة بصمت.
- **Sealed States**: استخدام حالات محددة (Initial, Loading, Success, Error) يدوياً.

---

## 📦 المكتبات المستخدمة

| المكتبة | الغرض |
|---------|-------|
| `dio` | الاتصال بـ API الخارجي (Dorar) |
| `html` | تحليل محتوى الـ HTML للعناصر النصية |
| `flutter_bloc` | إدارة حالات البحث والمفضلة |
| `skeletonizer` | تأثير التحميل الاحترافي |
| `dartz` | نمط `Either` لمعالجة الأخطاء |

---

## 🎨 التنسيق والألوان (HadithFormatter)

المزية تستخدم نظام تلوين ذكي بناءً على حكم المحدث:
- **صحيح / حسن**: أخضر (`AppColors.emerald`)
- **ضعيف / باطل / منكر**: أحمر (`AppColors.error`)
- **موضوع**: أحمر داكن
- **أحكام أخرى**: ذهبي أو رمادي
