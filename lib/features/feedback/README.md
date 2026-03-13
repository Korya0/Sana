# 💬 Feedback Feature

ميزة **الإبلاغ** تُتيح للمستخدمين إرسال ملاحظاتهم أو الإبلاغ عن مشاكل مباشرةً، مع دعم كامل للعمل بدون إنترنت (Offline Support) عبر Firestore.

## 🚀 المميزات الرئيسية
- إرسال ملاحظة أو تقرير مشكلة مع معلومات الاتصال الاختيارية.
- دعم كامل للعمل بدون اتصال (Firestore Offline Persistence).
- جمع معلومات الجهاز تلقائياً (نسخة النظام، الجهاز) مع كل تقرير.
- تحقق من المدخلات (Validation) قبل الإرسال.

## 🏗 الهيكل المعماري

```
feedback/
├── data/
│   ├── constants/    ← FeedbackKeys, FeedbackFirestoreKeys
│   ├── datasources/  ← IFeedbackRemoteDataSource (Firestore)
│   ├── models/       ← FeedbackModel (toJson فقط)
│   └── repositories/ ← IFeedbackRepository + FeedbackRepository
└── presentation/
    ├── controller/ ← FeedbackCubit + FeedbackState (Sealed Classes)
    ├── views/      ← FeedbackIssueView
    └── widgets/
        ├── feedback_form.dart
        ├── feedback_header.dart
        └── feedback_text_field.dart
```

## 📦 الـ State (Sealed Classes — Manual)
```dart
abstract class FeedbackState extends Equatable
  ├── FeedbackInitial
  ├── FeedbackSending
  ├── FeedbackSuccess { message }
  └── FeedbackFailure { error }
```

## 🧠 نمط Fire-and-Forget
يستخدم `FeedbackRepository` نمط **Fire-and-Forget** مع Firestore:
- يُرسل البيانات للـ Firestore queue ويعود بـ `Right(true)` فوراً.
- Firestore تتولى مسؤولية الإرسال الفعلي حتى لو كان الجهاز بدون إنترنت.
- في حال حدوث خطأ حقيقي (Exception): يُعيد `Left(NetworkFailure)` أو `Left(ServerFailure)`.

## 🎨 رموز التصميم
- **Spacing:** `AppSpacing.v12`, `v16`, `v24`, `v40`.
- **Colors:** `AppColors.gold` للأيقونة الرئيسية.

## ⚙️ الـ DI
| الكلاس | النوع | السبب |
|---|---|---|
| `IFeedbackRemoteDataSource` | `LazySingleton` | مشاركة connection |
| `IFeedbackRepository` | `LazySingleton` | - |
| `FeedbackCubit` | `Factory` | يُنشأ عند فتح الصفحة ويُتلف بعد الإرسال |
