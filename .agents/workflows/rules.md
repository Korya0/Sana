## ⚖️ 0. المبادئ الهندسية (Engineering Principles)
نلتزم التزاماً **صارماً جداً** بمبادئ هندسة البرمجيات لضمان كود قابل للتوسع والصيانة:

### ✅ مبادئ SOLID:
1.  **S (Single Responsibility)**: كل كلاس/دالة لها وظيفة واحدة فقط. (مثلاً: الـ Repository يجلب البيانات فقط، لا يعالج الـ UI).
2.  **O (Open/Closed)**: الكود مفتوح للتوسع، مغلق للتعديل. نستخدم الـ `abstract classes` والـ `interfaces`.
3.  **L (Liskov Substitution)**: أي كلاس فرعي يجب أن يحل محل الكلاس الأساسي دون كسر البرنامج.
4.  **I (Interface Segregation)**: العميل لا يجب أن يُجبر على الاعتماد على واجهات لا يستخدمها.
5.  **D (Dependency Inversion)**: نعتمد على التجريد (Abstractions) وليس التنفيذ (Concretions). نستخدم `GetIt` للـ Dependency Injection.

### 🚀 أفضل الممارسات (Best Practices):
- **Software Engineering**:
    - **Don't Repeat Yourself (DRY)**: لا تكرر الكود؛ أي كود متكرر يجب استخراجه في دالة أو ويدجت مشتركة.
    - **You Ain't Gonna Need It (YAGNI)**: لا تضف ميزات أو تعقيدات إلا إذا كنت فعلاً تحتاجها الآن.
    - **KISS (Keep It Simple, Stupid)**: حافظ على بساطة الحلول؛ التعقيد ليس دليلاً على الاحترافية.
    - **Clean Naming**: الأسماء يجب أن تكون معبرة عن الوظيفة (مثال: `getUserData` بدلاً من `fetch`).

- **Flutter/Dart Specific**:
    - **Const Everything**: استخدم `const` بكثرة لتحسين أداء الـ Rendering.
    - **Avoid Deep Nesting**: إذا زاد تداخل الويدجت عن 3-4 مستويات، قم بتقسيمها إلى ويدجت أصغر.
    - **Late & Null Safety**: استخدم `late` بحذر شديد، ويفضل دائماً التعامل مع الـ `nullable types` بشكل صريح.
    - **Strings & Localization**: لا تضع نصوصاً مباشرة (Hardcoded)؛ استخدم ملفات الثوابت أو الـ Localization.
    - **Build Method Purity**: اجعل دالة الـ `build` نظيفة جداً؛ لا تقم بأي عمليات منطقية أو Logic داخلها.
    - **Extensions**: استخدم الـ Extensions لإضافة وظائف متكررة للأنواع الأساسية (مثل `ContextExtensions` للـ Navigation والـ Theme).
    - **Mixins**: استخدم الـ Mixins لفصل المنطق المتكرر في الـ Cubits (مثل التحقق من الإنترنت).



---

## 🏗️ 1. المعمارية (Architecture)
نعتمد نظام **Clean Architecture** المقسم حسب الميزات (**Feature-driven**):

### الهيكل الأساسي للميزات (Feature Folders):
- `data/`: يحتوي على `models`, `datasources`, و `repositories_impl`.
- `domain/`: (اختياري) يحتوي على `entities`, `usecases`, و `repositories_interface`. يُستخدم فقط عند وجود منطق عمل معقد (Business Logic) يحتاج للفصل.
- `presentation/`: يحتوي على `bloc/cubit`, `pages`, و `widgets`.

### النواة (Core Folder):
يحتوي على كافة الخدمات والأدوات المشتركة التي تعتمد عليها الميزات:
- `core/api/`: Dio services, API constants, Success/Failure handling.
- `core/errors/`: Failure classes.
- `core/database/`: Local storage services (SharedPref/Hive).
- `core/theme/`: Colors, TextStyles, Theme settings.
- `core/utils/`: Logger, BlocObserver, Extensions.
- `core/widgets/`: Reusable widgets across the app.
- `core/di/`: Service locator (GetIt).
- `core/constants/`: Separate files for each constant type.

---

## 🧩 2. إدارة الحالة (State Management)
- نستخدم **Cubit** للحالات البسيطة و **Bloc** للعمليات المعقدة.
- الالتزام بـ **Freezed** لإنشاء الـ States والـ Events.
  - **لماذا؟**: يوفر Pattern Matching (`when`, `map`) مما يجعل الكود أنظف عند التعامل مع حالات (Loading, Success, Error).
  - يوفر `copyWith` وتدقيق تلقائي للبيانات (Immutability).
- الالتزام بـ `AppBlocObserver` لمتابعة التغييرات في الكونسول.

---

## 🚦 3. التوجيه (Routing)
نستخدم **GoRouter** مع تقسيم الإعدادات إلى 3 ملفات في `core/routes/`:
1. `app_router.dart`: تهيئة الـ Router والمسارات.
2. `routes_constants.dart`: أسماء المسارات كثوابت (Strings).
3. `app_transitions.dart`: جميع تأثيرات الانتقال بين الشاشات.

---

## 📡 4. التعامل مع البيانات (Data & Network)
- **Dio**: هو المحرك الأساسي لعمليات الشبكة.
- **Retrofit**: لكتابة الـ API calls بطريقة نظيفة (Interface based).
- **Talker**: نستخدم `Talker` بدلاً من الـ Logger التقليدي لمراقبة الـ Logs, HTTP Requests, و Bloc changes. يمكن الوصول إليه عبر `AppLogger.talker`.
- **dartz**: نستخدم `Either<Failure, T>` في الـ Repositories للتعامل مع النتائج.
- **Models**: نستخدم `Freezed` و `json_serializable` لإنشاء الـ Models بشكل آلي.
- **Assets**: نستخدم `flutter_gen` لتوليد كلاسات الأصول.
    - **الاستخدام**: بدلاً من المسار اليدوي، نستخدم `Assets.images.logo.path` أو `Assets.svgs.home.svg()`.

---

## 📁 5. الثوابت (Constants)
يتم تقسيم الثوابت في `core/constants/` بشكل تخصصي:
- `api_constants.dart`
- `app_constants.dart`
- `app_strings.dart` (في حال عدم وجود Localization).
- `assets_constants.dart`
- `json_constants.dart`
- `firestore_constants.dart`
- `remote_config_constants.dart`

---

## 🎨 6. التصميم والواجهات (UI & Theming)
- الالتزام بـ `AppColors` و `AppTextStyles` الموجودة في الـ Core.
- الويدجت المشتركة توضع في `core/widgets`.
- الويدجت الخاصة بالميزة توضع داخل `presentation/widgets` الخاص بالميزة.
- استخدام `Skeletonizer` لإظهار حالة التحميل (Loading).
- استخدام `Toastification` للإشعارات المنبثقة.

---

## 🛠️ 7. أدوات المطور (Dev Tools & Analysis)
- الالتزام بقواعد `very_good_analysis`.
- تشغيل `build_runner` دورياً لتوليد الكود.
- **التسمية**: نستخدم `snake_case` للملفات و `PascalCase` للأصناف. مِثال: `home_cubit.dart`.

---

## 📝 8. الكود المرجعي (Snippets)

### AppTransitions (GoRouter)
```dart
// موجود في core/routes/app_transitions.dart
// يحتوي على slideFromRight, slideFromLeft, fade, etc.
```

### SharedPref Service
```dart
// موجود في core/database/shared_pref.dart
// يُستخدم كـ Singleton عبر GetIt.
```

### AppLogger (Talker)
```dart
// للاستخدام العادي
AppLogger.info('My message');

// لربط Dio (Interceptor)
dio.interceptors.add(TalkerDioLogger(talker: AppLogger.talker));
```

### FlutterGen (Assets)
```dart
// Image
Image.asset(Assets.images.logo.path)

// SVG
Assets.svgs.icon.svg(width: 20)
```

---

## 🚩 القاعدة الذهبية:
"أي ميزة جديدة يجب أن تبدأ بإنشاء المجلدات المناسبة، تعريف الثوابت، ثم بناء الطبقات من الأسفل للأعلى (Data -> Presentation)."
