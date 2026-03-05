# 💬 مزية التغذية الراجعة (feedback)

## نظرة عامة

مزية `feedback` تُتيح للمستخدمين **إرسال مقترحاتهم أو الإبلاغ عن مشكلات** مباشرة للمطوّر. يملأ المستخدم نموذجاً بسيطاً، ويُرسَل الرد تلقائياً إلى Firebase Firestore مع بيانات الجهاز للمساعدة في التشخيص.

يتميز النظام بـ **"Fire & Forget"** — أي أن الإرسال يحدث بأسلوب لا يتطلب الانتظار، وFirestore يتولى الأمر حتى بدون إنترنت (تُرسَل عند عودة الاتصال).

---

## 📁 هيكل الملفات

```
feedback/
├── data/
│   ├── datasources/
│   │   └── feedback_remote_data_source.dart    ← الإرسال لـ Firestore
│   ├── models/
│   │   └── feedback_model.dart                  ← نموذج بيانات الإرسال
│   └── repositories/
│       └── feedback_repository.dart             ← جمع البيانات + الإرسال
└── presentation/
    ├── controller/
    │   ├── feedback_cubit.dart                  ← المتحكم
    │   └── feedback_state.dart                  ← الحالات
    ├── views/
    │   └── feedback_issue_view.dart             ← الصفحة الرئيسية
    └── widgets/
        ├── feedback_header.dart                 ← رأس الصفحة
        ├── feedback_form.dart                   ← النموذج
        └── feedback_text_field.dart             ← حقل الإدخال المخصص
```

---

## 📦 طبقة البيانات (Data Layer)

### `feedback_model.dart` — نموذج البيانات

يُمثّل رد الفعل الذي سيُرسل لـ Firestore.

| الخاصية | النوع | الوصف |
|---------|------|-------|
| `message` | `String` | نص رسالة المستخدم |
| `contactInfo` | `String` | معلومات التواصل (افتراضي: "غير متاح") |
| `timestamp` | `String` | وقت الإرسال بصيغة ISO 8601 |
| `metadata` | `Map<String, dynamic>` | بيانات الجهاز والتطبيق |

**`toJson()`** يُحوّل النموذج لـ Map لإرساله لـ Firestore.

---

### `feedback_remote_data_source.dart` — مصدر البيانات

خدمة بسيطة بدالة واحدة:

```dart
Future<void> sendFeedback(Map<String, dynamic> feedbackData) async {
  await _firestore.collection('feedbacks').add(feedbackData);
}
```

تُضيف وثيقة جديدة لمجموعة `feedbacks` في Firestore بـ auto-generated ID.

---

### `feedback_repository.dart` — الريبوزيتوري

**المسؤول الحقيقي عن تجميع البيانات قبل الإرسال.**

#### `sendFeedback()` — تدفق الإرسال:

```
1. جلب بيانات الجهاز من DeviceInfoService
   (المنصة، اسم الجهاز، إصدار OS، إصدار التطبيق، رقم البناء)
      ↓
2. إنشاء FeedbackModel:
   message = رسالة المستخدم
   contactInfo = معلومات التواصل (أو "غير متاح")
   timestamp = DateTime.now().toIso8601String()
   metadata = بيانات الجهاز
      ↓
3. إرسال إلى Firestore (Fire & Forget):
   unawaited(_remoteDataSource.sendFeedback(...))
      ↓
4. إرجاع Right(true) فوراً بدون انتظار Firestore
```

**لماذا `unawaited`؟**
Firestore يدعم الـ offline persistence — إذا لم يكن هناك إنترنت، يحفظ الرد محلياً ويُرسله عند عودة الاتصال. لذا لا حاجة لانتظار الاستجابة.

**معالجة أخطاء خاصة:**
```dart
if (e.toString().contains('unavailable') ||
    e.toString().contains('network') ||
    e.toString().contains('SocketException'))
  → Left(NetworkFailure(message: AppStrings.noInternet))
else
  → Left(ServerFailure(message: AppStrings.ourFault))
```

---

## 🧠 طبقة العرض (Presentation Layer)

### `feedback_state.dart` — الحالات

| الحالة | الوصف |
|--------|-------|
| `FeedbackInitial` | الحالة الأولية |
| `FeedbackSending` | جاري الإرسال (زر الإرسال في حالة تحميل) |
| `FeedbackSuccess` | تم الإرسال بنجاح (يحمل رسالة شكر) |
| `FeedbackFailure` | فشل الإرسال (يحمل رسالة الخطأ) |

---

### `feedback_cubit.dart` — المتحكم

```dart
Future<void> sendFeedback({
  required String issueDescription,
  String? contactInfo,
}) async {
  emit(FeedbackSending());
  final result = await repository.sendFeedback(
    message: issueDescription,
    contactInfo: contactInfo,
  );
  result.fold(
    (failure) => emit(FeedbackFailure(error: failure.message)),
    (_) => emit(FeedbackSuccess(message: AppStrings.thanksForYourContribution)),
  );
}
```

---

### `feedback_issue_view.dart` — الصفحة الرئيسية

تُنشئ `FeedbackCubit` عبر dependency injection (`sl<FeedbackCubit>()`).

**`BlocListener` يتعامل مع النتائج:**
| الحالة | الإجراء |
|--------|---------|
| `FeedbackSuccess` | يرجع للصفحة السابقة + يُظهر Toast بالشكر |
| `FeedbackFailure` | يُظهر Toast برسالة الخطأ |

**هيكل الصفحة:**
```
CustomScrollView
  ├── CommonSliverAppBar (عنوان الصفحة)
  └── SliverToBoxAdapter
      └── Column
          ├── FeedbackHeader  ← رأس الصفحة
          └── FeedbackForm    ← النموذج
```

---

### `feedback_header.dart` — رأس الصفحة

يعرض:
- **أيقونة** لمبة كهربائية ذهبية داخل دائرة شفافة (تعبيراً عن الأفكار والمقترحات).
- **نص توضيحي** يشجع المستخدم على المشاركة (`AppStrings.feedbackSubTitle`).

---

### `feedback_form.dart` — النموذج

نموذج بـ `Form` و`GlobalKey<FormState>` يحتوي على:

#### حقل التفاصيل (`_issueController`):
- `maxLines: 5` — نص متعدد الأسطر.
- **التحقق (Validation)**:
  - لا يقبل فارغاً.
  - يرفض النصوص الأقل من 10 أحرف.

#### حقل التواصل (`_contactController`):
- `keyboardType: TextInputType.emailAddress`.
- **اختياري** — إذا كان فارغاً يُرسَل `null`.

#### زر الإرسال:
```dart
BlocBuilder → AppPrimaryButton(
  isLoading: state is FeedbackSending
)
```
عند حالة `FeedbackSending`، يتحول الزر لـ Loading Indicator ويُمنع من الضغط مرة أخرى.

---

## 🔄 تدفق الإرسال الكامل

```
المستخدم يفتح صفحة التغذية الراجعة
      ↓
يملأ نموذج التفاصيل (min 10 أحرف)
+ معلومات التواصل (اختيارية)
      ↓
يضغط "إرسال" → Form Validation
  إذا النموذج صحيح:
      ↓
FeedbackCubit.sendFeedback()
  → emit(FeedbackSending)    ← زر الإرسال يتحول للتحميل
      ↓
FeedbackRepository.sendFeedback():
  1. جلب بيانات الجهاز
  2. إنشاء FeedbackModel
  3. unawaited(Firestore.add(...))  ← لا انتظار
  4. return Right(true)
      ↓
emit(FeedbackSuccess)
      ↓
BlocListener → context.pop() + AppToast "شكراً على مساهمتك"
```

---

## ☁️ Firestore Collection

| المجموعة | الوثيقة | الحقول |
|----------|---------|--------|
| `feedbacks` | (auto-ID) | `message`, `contactInfo`, `timestamp`, `metadata` |

---

## 📦 المكتبات المستخدمة

| المكتبة | الغرض |
|---------|-------|
| `cloud_firestore` | إرسال البيانات للسحابة |
| `flutter_bloc` | إدارة الحالة |
| `dartz` | نمط Either للأخطاء |
| `solar_icons` | أيقونة رأس الصفحة |
| `DeviceInfoService` (core) | جمع بيانات الجهاز |

---

## 🔗 العلاقات مع المزايا الأخرى

- **`developer_dashboard`**: الجانب المقابل لهذه المزية — تعرض لوحة التحكم ما يُرسله هذا النموذج.
- **`core/DeviceInfoService`**: مسؤول عن جمع بيانات الجهاز (platform، deviceModel، osVersion، appVersion).
- **`core/AppLogger`**: يُسجّل نجاح أو فشل الإرسال.
