# Feedback Feature (ميزة الاقتراحات والشكاوى)

تتيح هذه الميزة للمستخدمين إرسال شكاوى عن المشكلات التقنية أو تقديم اقتراحات لتحسين التطبيق مباشرة إلى قاعدة بيانات Firebase Firestore.

## المميزات التقنية
- **نموذج موحد**: واجهة واحدة مبسطة لاستقبال أفكار المستخدمين واقتراحاتهم أو شكاواهم.
- **التكامل مع Firestore**: تخزين البلاغات في مجموعة `feedbacks` مع طابع زمني (Timestamp) ومعلومات الجهاز (Metadata) وتفاصيل التواصل المرفقة (اختياري).
- **إرسال في الخلفية (Offline Support)**: الاعتماد على ميزة الـ Offline Persistence في Firestore لإرسال البلاغ بصمت (Fire and Forget) حتى لو لم يكن هناك اتصال بالإنترنت لحظة الإرسال، بحيث يظهر نجاح الإرسال فوراً للمستخدم.
- **إدارة الحالة**: استخدام `FeedbackCubit` لإدارة عملية الإرسال وعرض التغذية الراجعة للمستخدم بطريقة سريعة الاستجابة.

## هيكل المجلدات
- `constant/`:
    - `feedback_firestore_keys.dart`: المفاتيح المستخدمة في تشكيل قاموس البيانات المرفوع لـ Firestore ورموز الأخطاء الانقطاعية.
- `data/datasources/`:
    - `feedback_remote_data_source.dart`: المسؤول عن إضافة البلاغ مباشرة لـ Firebase Firestore.
- `data/models/`:
    - `feedback_model.dart`: هيكل وشكل البيانات المرسلة ليتم حفظها كـ Document.
- `data/repositories/`:
    - `feedback_repository.dart`: واجهة `IFeedbackRepository` تنظم إرسال البيانات وتقوم بدمج معلومات نظام وبيئة التشغيل عبر `DeviceInfoService` قبل الرفع الفعلي.
- `presentation/controller/`:
    - `feedback_cubit.dart` و `feedback_state.dart`: إدارة التفاعل بين الواجهة (UI) والبيانات (Data) وحالات الإرسال (Sending, Success, Failure).
- `presentation/views/`:
    - `feedback_issue_view.dart`: الشاشة الرئيسية النظيفة كلياً (Stateless) والتي تحتوي على مخطط العرض الأساسي عبر `CustomScrollView`.
- `presentation/widgets/`:
    - `feedback_header.dart`: الترويسة الأيقونية والوصفية في أعلى الشاشة.
    - `feedback_form.dart`: يحمل حالة البيانات (Stateful) ويضم الحقول وزر الإرسال ومنطق التحقق من صحة المدخلات.
    - `feedback_text_field.dart`: مكون الحقل النصي المخصص والموحد.

## ملاحظات للمطورين
- تم إلغاء الفصل بين نوع البلاغ (مشكلة/اقتراح)، حيث يقدم المستخدم رسالته بحرية تامة في حقل "التفاصيل".
- يتم جمع معلومات هاتف المستخدم وإصدار التطبيق بصمت عبر `DeviceInfoService` لتسهيل تشخيص الأخطاء من قبل المطور.
- عملية الإدخال في הـ Data Source غير مُنتظرة `unawaited` لكي يغلق المستخدم الشاشة ويكمل تصفحه وتقوم الخلفية بمحاولة إرسال البيانات عند توفر إنترنت لاحقاً.
