# 📑 فهرس المحتويات (Table of Contents)
- [🚀 F01 — المتطلبات (Requirements)](#f01)
- [📖 F02 — وثيقة متطلبات المنتج (PRD)](#f02)
- [🏗️ F03 — البنية التحتية (Architecture)](#f03)
- [🗄️ F04 — تصميم قواعد البيانات (Database Design)](#f04)

---

# <a name="f01"></a> 🚀 F01 — Requirements

### 🎯 Goal

تمكين المستخدم من تصفح أنواع الأذكار، واختيار نوع معين، ثم قراءة جميع الأذكار التابعة له داخل شاشة واحدة، مع إمكانية تتبع عدد مرات التكرار، ومشاركة أو نسخ الذكر، والعمل بالكامل بدون اتصال بالإنترنت.

---

### 👤 User Stories

**Story 1 — Browse Azkar Categories**
**As a user**
I want to browse all Azkar categories (such as Morning, Evening, After Prayer, Sleep...)
**So that**
I can choose the type of Azkar I want to read.

---

**Story 2 — Read Azkar**
**As a user**
I want to open an Azkar category and read all Azkar directly from the list
**So that**
I can complete my daily Azkar without opening additional screens.

---

**Story 3 — Track Repetitions**
**As a user**
I want to decrease the repetition counter while reading each Zikr
**So that**
I know how many repetitions are remaining.

---

**Story 4 — Share & Copy**
**As a user**
I want to share or copy a Zikr
**So that**
I can easily send or save it.

---

**Story 5 — Exit Confirmation**
**As a user**
I want to be warned before leaving an unfinished Azkar session
**So that**
So that I don't leave the session unintentionally.

---

### 📋 Business Rules

**Categories**
- عرض جميع أنواع الأذكار الموجودة في البيانات.
- ترتيب الأنواع حسب البيانات.
- لكل نوع أيقونة.
- لا يتم عرض أي نوع لا يحتوي على أذكار.

---

**Azkar List**
عند اختيار نوع معين:
- يتم عرض الأذكار التابعة له فقط.
- يتم ترتيب الأذكار حسب البيانات.
- كل Card تعرض:
    - نص الذكر.
    - فضل أو مرجع الذكر (إن وجد).
    - عدد مرات التكرار (`count`).
- تتم قراءة الذكر مباشرة من الـ Card.
- لا توجد شاشة تفاصيل مستقلة.

---

**Counter**
- يبدأ العداد بصفر للتقدم المنجز وينتهي عند القيمة `count`.
- كل ضغطة تزيد التقدم بمقدار (1) حتى يصل للحد الأقصى.
- عند الوصول إلى الحد الأقصى:
    - تصبح البطاقة باهتة.
    - يتم التمرير للقائمة ليظهر الذكر التالي الغير مكتمل.
- الضغط بعد الاكتمال يتم تجاهله.

---

**Share & Copy**
- زر المشاركة يشارك **نص الذكر فقط**.
- الضغط المطول على الزر ينسخ:
    - نص الذكر.
    - فضل الذكر أو مرجعه (إن وجد).

---

**Exit**
إذا حاول المستخدم الخروج قبل إنهاء جميع الأذكار:
- يظهر Dialog تحذيري (بالاعتماد على حالة `hasStarted` وليس حساب العدادات في الواجهة).
- عند الخروج يتم فقدان التقدم الحالي.
- لا يتم حفظ التقدم.

---

**Data**
- البيانات للقراءة فقط.
- جميع البيانات تعمل بدون اتصال بالإنترنت.

---

### ⚙️ Functional Requirements

**Categories Screen**
النظام يجب أن:
- يعرض جميع أنواع الأذكار.
- يعرض اسم كل نوع (`title`).
- يعرض أيقونة لكل نوع عبر `CategoryIconMapper`.
- يسمح بفتح النوع عند الضغط عليه عبر `categoryId`.

---

**Azkar List Screen**
النظام يجب أن:
- يعرض اسم النوع المختار.
- يعرض جميع الأذكار التابعة له.
- يعرض داخل كل Card:
    - نص الذكر (`text`).
    - الوصف/المرجع (`description` / `reference`).
    - عدد التكرارات المطلوبة (`count`).
- يسمح بالضغط على العداد لزيادة التقدم.
- يسمح بالمشاركة.
- يسمح بالنسخ.
- ينتقل تلقائيًا للذكر التالي الغير مكتمل عبر `nextIncompleteIndex`.

---

**Exit Confirmation**
إذا حاول المستخدم مغادرة الشاشة قبل إنهاء جميع الأذكار (يُعرف من الـ State):
- يعرض Dialog تحذيري.
- يسمح للمستخدم بالبقاء أو الخروج.

---

### 🧩 Navigation

```text
Azkar Categories
        ↓
Azkar List
```

---

### 🚀 Non Functional Requirements

**Performance**
- فتح الشاشات بسرعة.
- تمرير سلس.
- انتقال تلقائي سلس بين الأذكار.

**Offline**
- جميع الوظائف تعمل بدون إنترنت.

**Reliability**
- التعامل مع غياب فضل الذكر بسلامة (`null` values).

**Maintainability**
- بنية Clean Architecture مع فصل واضح بين Presentation و Domain و Data.

---

# <a name="f02"></a> 📖 F02 — Product Requirements Document (PRD)

### Overview
**Feature Name:** Core Azkar (MVP)
**Objective:** توفير تجربة بسيطة وسلسة للمستخدم لقراءة الأذكار اليومية، حيث يبدأ باختيار نوع الأذكار، ثم يقرأ جميع الأذكار داخل شاشة واحدة بدون تفاصيل معقدة.

---

### Functional Requirements
**FR-1 — Display Categories**
يعرض النظام جميع أنواع الأذكار مع الأيقونات والانتقال للأذكار عند الضغط.

**FR-2 — Display Azkar**
يعرض النظام جميع الأذكار التابعة للنوع المختار في قائمة ممررة.

**FR-3 — Counter**
عداد تصاعدي حتى قيمة التكرار المطلوبة. بطاقة باهتة وانتقال تلقائي بعد الانتهاء.

**FR-4 — Share & Copy**
نسخ للمرجعية والنص مع المشاركة.

**FR-5 — Exit Confirmation**
Dialog تحذيري عند الخروج بدون إتمام كل الأذكار (لا يتم حفظ التقدم).

**FR-6 — Offline Data**
كل البيانات مدعومة ومقروءة محليًا عبر Local JSON ثم تُحفظ في Hive.

---

# <a name="f03"></a> 🏗️ F03 — Architecture

> **Objective**
> تصميم الميزة بالكامل بالالتزام بـ Clean Architecture, SOLID, Cubit, Repository Pattern

### Folder Structure (Actual)
```text
lib/features/azkar/
├── data/
│   ├── constants/azkar_constants.dart
│   ├── datasources/
│   │   ├── i_azkar_local_data_source.dart
│   │   └── azkar_local_data_source_impl.dart
│   ├── models/
│   │   ├── category_model.dart
│   │   └── zikr_model.dart
│   └── repositories/
│       └── azkar_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── category_entity.dart
│   │   └── zikr_entity.dart
│   ├── repositories/
│   │   └── i_azkar_repository.dart
│   └── usecases/
│       ├── get_categories_usecase.dart
│       └── get_azkar_by_category_usecase.dart
└── presentation/
    ├── cubits/
    │   ├── azkar/
    │   │   ├── azkar_cubit.dart
    │   │   ├── azkar_state.dart
    │   │   └── zikr_increment_result.dart
    │   └── categories/
    ├── routes/azkar_routes.dart
    ├── utils/category_icon_mapper.dart
    ├── views/
    │   ├── azkar_list_view.dart
    │   └── ...
    └── widgets/
        ├── zikr_item_card.dart
        ├── zikr_card/
        │   ├── zikr_actions_row.dart
        │   └── zikr_counter.dart
        └── ...
```

### Layers & Responsibilities

**Data Layer**
- **Datasource:** قراءة ملفات `version.json` و `categories.json` وباقي الأصناف وتخزينها في `Hive`. فتح الصناديق ديناميكياً بـ `categoryId`.
- **Repository Impl:** تستدعي `ensureDatabaseReady` (داخلياً لتجنب التكرار)، وتجلب البيانات وتحولها عبر `Result.success()`.
- **Models:** ترث من Entities لتجنب النسخ غير المبرر (`CategoryModel extends CategoryEntity` و `ZikrModel extends ZikrEntity`). لا يتم استخدام `toEntity()`.

**Domain Layer**
- الكيانات نقية (Entities).
- UseCases للـ Categories و Azkar.
- **لا توجد** UseCases للمتغيرات المتعلقة بالعرض (مثل العدادات).

**Presentation Layer**
- `AzkarCubit`: تدير حالة `AzkarLoaded` وتتحكم بتقدم كل ذكر محلياً (`counters` map). تُعيد `ZikrIncrementResult` (مكتمل، مزاد، متجاهل).
- `AzkarLoaded`: تمتلك `hasStarted` لمعرفة هل بدأ المستخدم، و `nextIncompleteIndex` للانتقال التلقائي دون تداخل الـ View.
- `CategoryIconMapper`: مابين معرف النوع (int) إلى الأيقونة.

---

### Data Flow

**أول تشغيل فقط:**
```text
App Start
      ↓
RepositoryImpl._ensureReady()
      ↓
AzkarLocalDataSource.ensureDatabaseReady()
      ↓
Check version.json vs metadata_box
      ↓
If newer -> clear old category boxes, update categories box, save new version
```

**Counter Flow (بدون UseCase):**
```text
User Taps Zikr Counter
      ↓
AzkarCubit.incrementZikr(id)
      ↓
Returns ZikrCompleted (or Incremented)
      ↓
View triggers haptics & View calls `onCompleted`
      ↓
View calls _scrollToNextItem -> uses state.nextIncompleteIndex
```

---

# <a name="f04"></a> 🗄️ F04 — Database / Local Data Design

### JSON Contracts

**categories.json**
```json
[
  {
    "id": 1,
    "title": "أذكار الصباح",
    ...
  }
]
```
| Field | Type | Required |
| --- | --- | --- |
| id | int | ✅ |
| title | String | ✅ |

**azkar_1.json (e.g. category 1)**
```json
[
  {
    "id": 101,
    "text": "...",
    "count": 3,
    "reference": "...",
    "description": "..."
  }
]
```
| Field | Type | Required |
| --- | --- | --- |
| id | int | ✅ |
| text | String | ✅ |
| count | int | ✅ |
| reference | String | ❌ |
| description | String | ❌ |

### Hive Boxes
- `metadataBoxName`: يحفظ `versionKey`.
- `categoriesBoxName`: يحفظ Categories (المفتاح int، المحتوى JSON String أو Model).
- `azkarCategoryBoxPrefix + id`: (مثال: `azkar_category_1`) يتم إنشاؤه أوتوماتيكياً فقط عند الطلب عبر `_loadAndSaveAzkar(categoryId)`.

### Models (Updated)
التحويل يتم تلقائياً بفضل الوراثة ولا توجد دوال `toEntity()` مستقلة ولا Mappers تفصل بين الـ Model والـ Entity كالتالي:

```dart
class CategoryModel extends CategoryEntity {
  const CategoryModel({required super.id, required super.title});
  factory CategoryModel.fromJson(...)
}

class ZikrModel extends ZikrEntity {
  const ZikrModel({required super.id, required super.text, required super.count, super.reference, super.description});
  factory ZikrModel.fromJson(...)
}
```

### Interfaces
```dart
abstract class IAzkarLocalDataSource {
  Future<void> ensureDatabaseReady();
  Future<List<CategoryModel>> getCategories();
  Future<List<ZikrModel>> getAzkarByCategory(int categoryId);
}

abstract class IAzkarRepository {
  Future<Result<List<CategoryEntity>>> getCategories();
  Future<Result<List<ZikrEntity>>> getAzkarByCategory(int categoryId);
}
```

### Performance & DB Decisions
- ✅ Offline First.
- ✅ المعرفات `id` و `categoryId` هي من نوع `int` حصراً لضمان دقة الاستعلامات والأداء.
- ✅ الوراثة المباشرة لـ `Model` من `Entity` تمنع النسخ غير المبرر.
- ✅ حماية `ensureDatabaseReady` في طبقة `RepositoryImpl` عبر حارس `_isReady` لتجنب الانتظار.
- ✅ صناديق (Boxes) ديناميكية باسم الصنف لتحميل الذاكرة فقط بالصنف المطلوب.
