# 🕌 ميزة مواقيت الصلاة (Prayer Times Feature)

ميزة معمارية جبارة مبنية بالكامل وفقًا لمبادئ **الهندسة النظيفة (Clean Architecture)** ومبادئ **التصميم الموجه للمجال (Domain-Driven Design - DDD)** لضمان قابلية الاختبار، وفصل الاهتمامات، وخفض درجة الارتباط.

## 📂 الهيكل الدليلي (Directory Structure)

```
lib/features/prayer/
│
├── constants/               # الثوابت ومزودات الأسماء لمواقيت الصلاة
├── di/                      # حقن الاعتماديات الخاص بالميزة (Service Locator)
│
├── domain/                  # طبقة المجال (المنطق الجوهري المستقل)
│   ├── entities/            # الكيانات النقية (Manual Equality & Immutable)
│   ├── repos/               # واجهات مستودعات البيانات (Interfaces)
│   └── use_cases/           # حالات الاستخدام المستخلصة (Business Logic)
│
├── data/                    # طبقة البيانات (التنفيذ الفعلي وجلب البيانات)
│   ├── repos/               # تطبيق مستودعات البيانات (Fetching Coords internally)
│   └── services/            # خدمات معالجة مواقيت الصلاة والشبكة والحدث الديني
│
└── presentation/            # طبقة العرض (UI & State Management)
    ├── cubit/               # إدارة الحالة بواسطة Cubit (خالٍ من منطق المنصات ومستمعي الكيوبيتات الأخرى)
    ├── models/              # نماذج العرض الخاصة بالـ UI (PrayerDisplayModel)
    └── widgets/             # الواجهات والعناصر الرسومية (خالية من كود معالجة المنصات)
```

## 🛠️ القرارات المعمارية والتقنية (Architectural & Technical Decisions)

### 1. الكيانات النقية والمطابقة اليدوية (Domain Entities & Manual Equality)
* تم نقل جميع الكيانات إلى مجلد `domain/entities/` وفصلها تماماً عن نماذج البيانات.
* تم استبعاد استخدام حزم خارجية مثل `Equatable` وتطبيق المطابقة يدوياً عبر تجاوز المعاملين `==` و `hashCode` في جميع الكيانات:
  * `PrayerTimesEntity`
  * `SunnahTimesEntity`
  * `ReligiousEventEntity`
  * `PrayerStateResult`
  * `PrayerSunnah`
  * `SunnahHadith`
* تم استخدام الوسم `@immutable` لضمان ثبات الكيانات وتلافي مشاكل الفحص البرمجي (lint warnings).

### 2. فصل منطق العمل عن النماذج (Extracting Business Logic to Use Cases)
* تم استخلاص المنطق الحسابي الخاص بالمناسبات الدينية (الذي كان سابقاً مدمجاً بداخل النموذج `ReligiousEventModel` مثل `isOccurring` و `isAfter`) ونقله إلى حالات استخدام منفصلة ونقية داخل `domain/use_cases/`:
  * `IsReligiousEventOccurringUseCase`
  * `IsReligiousEventAfterUseCase`
* هذا يضمن فصل الاهتمامات (Separation of Concerns) ويسهل كتابة اختبارات الوحدة (Unit Tests).

### 3. إزالة تسريبات المنصة والموقع من الـ UI والـ Cubit
* **الإحداثيات**: تم تفويض عملية جلب الإحداثيات الجغرافية (Latitude/Longitude) بالكامل لمستودع البيانات `PrayerRepoImpl` داخلياً من التخزين المحلي، مما يريح الكيوبيت من اعتمادية الموقع المباشرة ويمنع تسريب تفاصيل معالجة المنصة.
* **إدارة دورة الحياة والتحديث**: تم التخلص من `WidgetsBindingObserver` من الـ Cubit وتحويلها إلى مسؤولية طبقة العرض (View) لتفادي الكراشات الناتجة عن تحديث الحالة بعد إغلاق الكيوبيت، مع إضافة فحص `isClosed` قبل كل `emit` وتثبيت الجدولة الزمنية للتحديث عند دخول وقت الصلاة التالية بأمان.
