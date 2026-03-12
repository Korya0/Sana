# 🛠 Developer Dashboard Feature

ميزة **لوحة تحكم المطور** هي واجهة داخلية (Admin-Only) تُمكّن المطور من مراجعة تعليقات المستخدمين (Feedbacks) التي يرسلونها عبر ميزة الإبلاغ، مع إمكانية حذفها بعد معاينتها.

## 🚀 المميزات الرئيسية
- عرض قائمة كاملة بتعليقات المستخدمين من Firestore.
- حذف تعليق مع **Optimistic Update + Rollback** في حال فشل الحذف.
- مشاركة محتوى التعليق كصورة.
- واجهة Admin احترافية مع بطاقات مفصّلة.

## 🏗 الهيكل المعماري

```
developer_dashboard/
├── data/
│   ├── datasources/ ← IDashboardRemoteDataSource + impl (Firestore)
│   ├── models/      ← DashboardFeedbackModel (Equatable)
│   └── repositories/ ← IDashboardRepository + DashboardRepository
└── presentation/
    ├── controller/ ← DashboardCubit + DashboardState (Sealed Classes)
    ├── views/      ← DeveloperDashboardView
    └── widgets/
        ├── admin_feedback_actions.dart
        ├── feedback_admin_card.dart
        ├── feedback_content.dart
        ├── feedbacks_list_view.dart
        └── share_card/ ← FeedbackShareCard
```

## 📦 الـ State (Sealed Classes — Manual)
```dart
abstract class DashboardState extends Equatable
  ├── DashboardInitial
  ├── DashboardFeedbacksLoading
  ├── DashboardFeedbacksLoaded { feedbacks }
  └── DashboardFeedbacksError  { message }
```

## 🧠 نمط Optimistic Update
يقوم `DashboardCubit` بـ:
1. إزالة التعليق من الـ State فوراً (UI يتحدث بدون تأخير).
2. إرسال طلب الحذف للسيرفر في الخلفية.
3. في حال الفشل: إعادة التعليق المحذوف للقائمة تلقائياً (Rollback).

## ⚙️ الـ DI
| الكلاس | النوع |
|---|---|
| `IDashboardRemoteDataSource` | `LazySingleton` |
| `IDashboardRepository` | `LazySingleton` |
| `DashboardCubit` | `Factory` |
