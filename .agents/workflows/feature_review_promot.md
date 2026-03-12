---
description: 
---

"بصفتك Senior Flutter/Dart Architect، قم بإجراء مراجعة معمارية شاملة وعميقة للميزة الموجودة في المسار: [أدخل مسار الميزة هنا].

⚠️ قيود العمل الحالية (Shorebird-Safe Evolution): يجب تنفيذ التحسينات باستخدام المكتبات الحالية فقط (dartz, equatable, get_it). يُمنع إضافة أي مكتبات جديدة (مثل freezed أو json_serializable) في هذه المرحلة. يتم تطبيق الأنماط المعمارية (Sealed Classes & Models) يدوياً لضمان التوافق مع Shorebird Patches، مع مراعاة سهولة تحويلها لتوليد الكود مستقبلاً.

يجب أن يلتزم الفحص حرفياً بالقواعد المذكورة في ملف ARCHITECTURE_GUIDELINES.md مع التركيز على:

Data Layer (SOLID Check):

هل المستودع (Repository) يتبع مبدأ DIP (واجهة Interface + تطبيق Implementation)؟
هل يتم استخدام Either<Failure, T> (النمط المعتمد حالياً) في الردود؟
هل الـ Models نظيفة ومفصولة عن المنطق؟
Logic Layer (Cubit Audit):

هل الـ Cubit يعتمد على الـ Interfaces فقط في الـ Constructor؟
هل يتم تنظيم الـ States يدوياً بنمط الـ Sealed Classes لضمان تغطية حالات (Loading/Success/Error)؟
هل تم عزل المنطق الحسابي أو التوقيتات في 

Services
 مستقلة؟
Presentation & UI Audit:

هل الواجهة تستخدم مكونات الـ core/common والـ 

AppSpacing
 والـ AppColors/AppTextStyles؟
هل هناك أي "قيم سحرية" (Magic Numbers) للألوان أو المسافات أو الحواف (Radius)؟
هل التصميم يدعم الـ Responsiveness والـ Premium Aesthetics؟
Dependency Injection (DI):

هل يتم تسجيل الميزة في ملف الـ 

_di.dart
 المناسب (LazySingleton للدوام، Factory للتكرار)؟
هل ترتيب التهيئة (Initialization) صحيح؟
المطلوب: تقديم تقرير مفصل بالتحسينات المقترحة بناءً على هذه القيود، ثم الانتظار لموافقتي قبل البدء في أي تعديل كود."