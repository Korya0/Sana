# 🛠️ مزية لوحة المطوّر (developer_dashboard)

## نظرة عامة

مزية `developer_dashboard` هي **لوحة تحكم داخلية مخصصة للمطوّر** تتيح له عرض وإدارة **ردود فعل ومقترحات المستخدمين** (`feedback`) التي تُرسل من التطبيق. تتصل مباشرة بـ Firestore لجلب هذه الردود وعرضها بشكل منظم، مع إمكانية حذفها أو مشاركتها أو نسخها.

> ⚠️ **هذه اللوحة مخصصة للمطوّرين فقط وليست مرئية للمستخدمين العاديين.**

---

## 📁 هيكل الملفات

```
developer_dashboard/
├── data/
│   ├── datasources/
│   │   └── dashboard_remote_data_source.dart   ← جلب + حذف من Firestore
│   ├── models/
│   │   └── dashboard_feedback_model.dart       ← نموذج بيانات الرد
│   └── repositories/
│       └── dashboard_repository.dart           ← غلاف Either + معالجة أخطاء
└── presentation/
    ├── controller/
    │   ├── dashboard_cubit.dart                ← المتحكم
    │   └── dashboard_state.dart                ← الحالات
    ├── views/
    │   └── developer_dashboard_view.dart       ← الصفحة الرئيسية
    └── widgets/
        ├── feedbacks_list_view.dart            ← قائمة الردود
        ├── feedback_admin_card.dart            ← بطاقة رد واحد
        ├── feedback_content.dart               ← محتوى الرد (نص + بيانات)
        ├── admin_feedback_actions.dart         ← أزرار الإجراءات
        └── share_card/
            └── feedback_share_card.dart        ← بطاقة مشاركة الرد
```

---

## 📦 طبقة البيانات (Data Layer)

### `dashboard_feedback_model.dart` — نموذج البيانات

| الخاصية | النوع | الوصف |
|---------|------|-------|
| `id` | `String` | معرف Firestore للوثيقة |
| `message` | `String` | نص رسالة المستخدم |
| `contactInfo` | `String` | معلومات التواصل (إن أدخلها المستخدم) |
| `timestamp` | `String` | وقت الإرسال بصيغة ISO 8601 |
| `metadata` | `Map<String, dynamic>` | بيانات الجهاز (نظام، إصدار، جهاز) |

**محتوى `metadata`:**
- `platform` — Android / iOS / Web
- `deviceModel` — اسم الجهاز
- `osVersion` — إصدار نظام التشغيل
- `appVersion` — إصدار التطبيق
- `buildNumber` — رقم البناء

---

### `dashboard_remote_data_source.dart` — مصدر البيانات

يتواصل مباشرة مع **Firestore**.

| الدالة | الوصف |
|--------|-------|
| `getFeedbacks()` | يجلب كل الردود من Firestore **مرتبة من الأحدث للأقدم** |
| `deleteFeedback(String id)` | يحذف وثيقة رد واحدة بمعرفها |

```dart
// جلب الردود مرتبة بالوقت تنازلياً
_firestore.collection('feedbacks')
    .orderBy('timestamp', descending: true)
    .get();
```

---

### `dashboard_repository.dart` — الريبوزيتوري

يُغلّف عمليات مصدر البيانات بـ `try/catch` ويرجع `Either<Failure, T>`.

| الدالة | الإرجاع |
|--------|---------|
| `getFeedbacks()` | `Either<ServerFailure, List<DashboardFeedbackModel>>` |
| `deleteFeedback(id)` | `Either<ServerFailure, void>` |

---

## 🧠 طبقة العرض (Presentation Layer)

### `dashboard_state.dart` — الحالات

| الحالة | الوصف |
|--------|-------|
| `DashboardInitial` | الحالة الأولية |
| `DashboardFeedbacksLoading` | جاري التحميل من Firestore |
| `DashboardFeedbacksLoaded` | تم التحميل (يحمل `List<DashboardFeedbackModel>`) |
| `DashboardFeedbacksError` | خطأ في التحميل (يحمل `message`) |

---

### `dashboard_cubit.dart` — المتحكم

#### `getFeedbacks()`:
يُحمّل الردود من Firestore ويُصدر الحالة المناسبة.

#### `deleteFeedback(String id)` — الحذف الفوري (Optimistic Update):

هذه الآلية تعمل بذكاء:

```
1. المستخدم يضغط الحذف بعد التأكيد
2. الرد يُزال فوراً من القائمة المعروضة (Optimistic Update)
   ← المستخدم يرى النتيجة فوراً
3. في الخلفية: يُرسل طلب الحذف لـ Firestore (Fire & Forget)
4. إذا نجح الطلب → لا شيء يتغير (الرد أُزيل بالفعل)
5. إذا فشل الطلب → يُعيد الرد لقائمة المعروضة (Rollback)
   + يُسجّل الخطأ في AppLogger
```

هذا يجعل تجربة المستخدم (المطوّر) سريعة دون انتظار.

---

### `developer_dashboard_view.dart` — الصفحة الرئيسية

بسيطة جداً: `Scaffold` يحتوي على `CustomScrollView` مع `CommonSliverAppBar` و`FeedbacksListView`.

---

### `feedbacks_list_view.dart` — قائمة الردود

تعرض الحالات المختلفة:

| الحالة | ما يُعرض |
|--------|----------|
| `DashboardFeedbacksLoading` | دوّار تحميل في منتصف الشاشة |
| `DashboardFeedbacksError` | `AppErrorWidget` مع زر إعادة المحاولة |
| `DashboardFeedbacksLoaded` (فارغة) | رسالة "لا توجد ردود بعد" |
| `DashboardFeedbacksLoaded` (بها عناصر) | `SliverList` من بطاقات `FeedbackAdminCard` |

---

### `feedback_admin_card.dart` — بطاقة رد واحد

تتكون من جزأين:
1. **`FeedbackContent`** — يعرض محتوى الرد.
2. **`AdminFeedbackActions`** — يعرض أزرار الإجراءات.

---

### `feedback_content.dart` — محتوى الرد

يعرض معلومات الرد بتنسيق مرتب:

**أعلى البطاقة:**
- **التاريخ** (مُنسَّق) على اليسار.
- **المنصة** (Android / iOS / Web) في badge ذهبي على اليمين.

**النص الرئيسي:**
- رسالة المستخدم بخط 16px.

**بيانات الجهاز (Metadata Box):**
- معلومات التواصل (إن وُجدت).
- اسم الجهاز.
- إصدار نظام التشغيل.
- إصدار التطبيق + رقم البناء.

> **ملاحظة:** يدعم `isSharing = true` لتغيير التنسيق عند المشاركة كصورة.

---

### `admin_feedback_actions.dart` — أزرار الإجراءات

شريط أزرار أسفل البطاقة يحتوي على:

| الزر | الإجراء |
|------|---------|
| 🗑️ (حذف) | يُظهر `CustomConfirmationDialog` قبل الحذف |
| 📤 (مشاركة) | ينشئ صورة من `FeedbackShareCard` ويشاركها |
| 📋 (نسخ) | ينسخ نص الرسالة للحافظة |

**حوار تأكيد الحذف:**
- `isDestructive: true` → يظهر زر التأكيد باللون الأحمر.

---

## 🔄 تدفق البيانات الكامل

```
المطوّر يفتح لوحة التحكم
      ↓
DeveloperDashboardView → FeedbacksListView
      ↓
DashboardCubit.getFeedbacks() (يُستدعى من خارج عند دخول الصفحة)
  → emit(DashboardFeedbacksLoading)
  → Firestore.collection('feedbacks').orderBy('timestamp').get()
  → emit(DashboardFeedbacksLoaded(feedbacks: [...]))
      ↓
FeedbacksListView → SliverList من FeedbackAdminCard
      ↓
المطوّر يضغط حذف:
  → AdminFeedbackActions → _confirmDelete() → CustomConfirmationDialog
  → عند التأكيد: DashboardCubit.deleteFeedback(id)
  → Optimistic Update: إزالة من القائمة فوراً
  → في الخلفية: Firestore.doc(id).delete()
```

---

## ☁️ Firestore Collection

| المجموعة | الوصف |
|----------|-------|
| `feedbacks` | كل ردود المستخدمين |

الوثيقة تُضاف تلقائياً بـ auto-ID من Firestore.

---

## 📦 المكتبات المستخدمة

| المكتبة | الغرض |
|---------|-------|
| `cloud_firestore` | قاعدة بيانات السحابة |
| `flutter_bloc` | إدارة الحالة |
| `dartz` | نمط Either |
| `intl` | تنسيق التواريخ |
| `solar_icons` | أيقونات الواجهة |

---

## 🔗 العلاقات مع المزايا الأخرى

- **`feedback`**: تُرسل الردود عبرها، وهذه اللوحة تعرضها وتديرها.
- **`core/sharing`**: لمشاركة الردود كصور.
