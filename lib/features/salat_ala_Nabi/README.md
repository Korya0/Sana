# 📿 مزية التذكير بالصلاة على النبي (salat_ala_Nabi)

## نظرة عامة

مزية `salat_ala_Nabi` (أو التذكير بالصلاة على النبي) هي رفيق للمسلم ليحافظ على ذكر الله والصلاة على النبي ﷺ طوال يومه. تتيح المزية للمستخدم ضبط تنبيهات دورية (صوتية أو إشعارات) بـ "صلى الله عليه وسلم" بـفواصل زمنية محددة، مع إمكانية تخصيص أوقات العمل لضمان عدم الإزعاج أثناء النوم.

---

## 📁 هيكل الملفات

```
salat_ala_Nabi/
├── data/
│   ├── models/
│   │   └── reminder_settings.dart      ← نموذج إعدادات التذكير
│   ├── services/
│   │   ├── notification_service.dart   ← إدارة الإشعارات المحلية (Singleton)
│   │   ├── work_manager_service.dart    ← جدولة المهام في الخلفية
│   │   └── salawat_background_executor.dart ← المنفذ البرمجي في الخلفية
│   └── salawat_constants.dart           ← الثوابت (أوضاع العمل، معرفات القنوات)
├── presentation/
│   ├── controller/
│   │   ├── reminder_cubit.dart          ← المتحكم في الإعدادات والجدولة
│   │   └── reminder_state.dart          ← حالات المزية (Initial, Loading, Loaded, Error)
│   ├── views/
│   │   ├── salat_ala_nabi_view.dart      ← واجهة الضبط الرئيسية
│   │   └── skeletonizer_salat_ala_nabi_view.dart ← واجهة التحميل
│   └── widgets/
│       ├── interval_counter_widget.dart  ← اختيار الفاصل الزمني (15، 30... دقيقة)
│       └── working_hours_widget.dart     ← اختيار ساعات العمل (من - إلى)
└── ...
```

---

## ⚙️ المنطق التقني (Background Service)

تعتمد هذه المزية على تقنية **المهام الدورية في الخلفية** لضمان استمرار التذكير حتى عند إغلاق التطبيق.

### `WorkManagerService`
تستخدم مكتبة `Workmanager` لجدولة مهمة دورية (`PeriodicTask`).
- **التكرار**: يتم بناءً على اختيار المستخدم (الحد الأدنى 15 دقيقة تقنياً).
- **القيود**: تعمل المهمة بدون الحاجة لاتصال بالإنترنت.

### `NotificationService`
خدمة مركزية (تم حقنها في الـ Cubit) مسؤولة عن:
- تهيئة قنوات الإشعارات (Channels) بصلاحيات صوتية عالية.
- عرض التنبيه الفوري عند الحفظ أو تفعيل الخدمة للتأكد من عمل الصوت.

---

## 🧠 طبقة العرض (Presentation Layer)

### `ReminderCubit` & `ReminderState`
تم تطبيق نمط **Sealed Classes** لإدارة الحالة بشكل متين:
- `ReminderInitial`: الحالة الأولى.
- `ReminderLoading`: أثناء جلب الإعدادات من التخزين المحلي.
- `ReminderLoaded`: تحتوي على `ReminderSettings` الحالية وتسمح بالتعديل.
- `ReminderError`: في حال فشل الوصول للتخزين.

### المميزات المعمارية:
- **DIP (Dependency Inversion)**: يعتمد الـ Cubit على واجهة `IReminderRepo` وليس التطبيق المباشر.
- **DIP (Service Injection)**: يتم حقن `NotificationService` لضمان سهولة الاختبار والعزل.
- **Magic Numbers Avoidance**: استخدام كلاس `WorkingHoursMode` لإدارة الأوضاع بدلاً من الأرقام الصماء.

---

## 📦 المكتبات المستخدمة

| المكتبة | الغرض |
|---------|-------|
| `workmanager` | تنفيذ المهام الدورية في خلفية النظام |
| `flutter_local_notifications` | إظهار الإشعارات وتنبيهات الصوت |
| `dartz` | التعامل مع النتائج باستخدام نمط `Either` |
| `equatable` | مقارنة الحالات والإعدادات بكفاءة |
| `get_it` | إدارة حقن التبعيات (DI) |

---

## ⚠️ ملاحظات هامة لأداء أفضل

- **Battery Optimization**: يجب استثناء التطبيق من تحسين البطارية في أندرويد لضمان دقة المواعيد.
- **Android 13+**: تتطلب المزية إذن الإشعارات (`Permission.notification`) لتعمل.
- **Shorebird Safe**: تم تطبيق Sealed Classes يدوياً لضمان التوافق مع تحديثات Shorebird.
