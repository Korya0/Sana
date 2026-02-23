# ميزة التاريخ (App Date Feature)

تتحكم في حساب وعرض التاريخ الهجري والميلادي داخل التطبيق.
مفيش أي اعتماد على Firebase أو Remote Config — كل حاجة محلية وبسيطة.

---

## هيكل الملفات

```
app_date/
├── README.md
├── data/
│   └── models/
│       └── app_date_value.dart         ← Model التاريخ (Equatable)
└── presentation/
    ├── controller/
    │   ├── app_date_cubit.dart          ← الـ Cubit (Singleton)
    │   └── app_date_state.dart          ← الـ State
    └── widgets/
        ├── hijri_and_gregorian_date_widget.dart   ← الودجت الرئيسية (StatefulWidget)
        ├── hijri_adjustment_bottom_sheet.dart      ← Bottom Sheet تعديل +1/0/-1
        └── hijri_social_verification_dialog.dart   ← دايلوج التحقق الشهري
```

---

## المكونات

### 1. `AppDateValue` (Model)
- يحمل التاريخ الميلادي (`gregorian`) والهجري (`hijri`) وقيمة التعديل (`adjustment`)
- يستخدم `factory` constructor عشان يضمن إن `DateTime.now()` ينادى مرة واحدة بس
- فيه `copyWith` لتحديث القيم بشكل immutable
- يعتمد على باكدج `hijri` لحساب التاريخ الهجري

### 2. `AppDateState`
- فيه حقلين بس:
  - `date` (`AppDateValue`) — التاريخ الحالي بالتعديل
  - `showVerificationDialog` (`bool`) — هل نعرض دايلوج التحقق

### 3. `AppDateCubit` (Singleton — يتسجل في `core_di.dart`)
- **يعتمد فقط على `SharedPref`** — مفيش Firebase ولا Remote Config
- **الدوال المتاحة:**
  - `setAdjustment(int adj)` — تعديل يدوي (+1 أو -1 أو 0)
  - `resetAdjustment()` — إرجاع التعديل لصفر
  - `confirmVerification()` — تأكيد التحقق الشهري
  - `refresh()` — تحديث التاريخ (ينادى عند منتصف الليل)

- **منطق التحقق الشهري:**
  - أشهر التحقق hardcoded: `[9, 10, 12]` (رمضان، شوال، ذو الحجة)
  - عند فتح التطبيق: لو الشهر الهجري الحالي ضمن القائمة **ولم يتم التحقق فيه مسبقاً** → يتم تفعيل `showVerificationDialog`
  - بعد التأكيد: يتم حفظ رقم الشهر في `lastVerifiedHijriMonth` بـ SharedPref

- **تحديث منتصف الليل:**
  - `Timer` يحسب الوقت المتبقي لنص الليل ويعمل `refresh()` تلقائياً

### 4. `HijriAndGregorianDateWidget` (StatefulWidget)
- **لماذا `StatefulWidget` وليس `StatelessWidget`؟**
  - لأن الـ `AppDateCubit` singleton بيتسجل في `core_di.dart` **قبل** `runApp()`
  - أي `emit` في الـ constructor بيحصل قبل ما أي `BlocListener` يتسجل
  - الحل: `addPostFrameCallback` في `initState` بيتحقق من الحالة الأولية **بعد** بناء الـ widget tree
  - الـ `BlocListener` بيغطي التغييرات اللاحقة (مثلاً عند منتصف الليل)

- **عند الضغط على التاريخ:** يفتح `HijriAdjustmentBottomSheet`
- **بيستخدم Shared Widgets من الـ Core:**
  - `showCustomBottomSheet()` ← من `core/common/widgets/custom_bottom_sheet.dart`
  - `AppTextStyles` ← من `core/theme/fonts/`
  - `AppColors` ← من `core/theme/style/`
  - `AppDateFormatter` ← من `core/utils/`

### 5. `HijriAdjustmentBottomSheet`
- 3 أزرار: `-1`، `0`، `+1` (بـ `for` loop بدون تكرار)
- زر "العودة للتاريخ الطبيعي" (يعمل `resetAdjustment`)
- لون الزر المحدد: ذهبي (`AppColors.gold`)

### 6. `HijriSocialVerificationDialog`
- بيسأل المستخدم: "هل اليوم هو [التاريخ] في بلدك؟"
- "نعم، صحيح" → `confirmVerification()` → يتقفل
- "لا، يوجد فرق" → `confirmVerification()` + يفتح `HijriAdjustmentBottomSheet`
- بيستخدم `CustomConfirmationDialog` من الـ Core

---

## مفاتيح SharedPref المستخدمة

| المفتاح | النوع | الوصف |
|---|---|---|
| `hijri_adjustment` | `int` | قيمة التعديل الحالية (0 أو +1 أو -1) |
| `last_verified_hijri_month` | `int` | آخر شهر هجري تم فيه التحقق |

---

## تسجيل الـ DI (`core_di.dart`)

```dart
..registerSingleton<AppDateCubit>(
  AppDateCubit(sl<SharedPref>()),
)
```

**ملاحظة:** Singleton لأن التاريخ مشترك بين عدة features (الصلاة، المحتوى اليومي).

---

## الـ Features اللي بتستخدم الـ Cubit

| Feature | الاستخدام |
|---|---|
| `prayer` | `appDateCubit.state.date.gregorian` لحساب مواقيت الصلاة |
| `daily_content` | `appDateCubit.state.date.gregorian` لتحديد المحتوى اليومي |

---

## ملاحظات مهمة للمستقبل

1. **مفيش Firebase Remote Config** — لو عاوز ترجعه مستقبلاً، ضيف dependency في الـ Cubit constructor وأضف method `syncWithRemoteConfig`
2. **أشهر التحقق hardcoded** في `_verificationMonths = [9, 10, 12]` — لو عاوز تغيرها، عدّل الـ list مباشرة
3. **الودجت `StatefulWidget`** — ده مش اختيار عشوائي، ده حل لمشكلة timing بين Singleton Cubit و BlocListener. **ما تحولهاش لـ StatelessWidget**
4. **الـ Timer** بيتلغى في `close()` — مفيش memory leak
5. **لو حصلت أي مشكلة في باكدج `hijri`** — التطبيق مش هيقع، هيعرض التاريخ الميلادي عادي

---

## آخر تحديث: 23 فبراير 2026
