# 📋 Azkar Feature — Test Checklist

> ليستة شاملة لكل الاختبارات المطلوبة لميزة الأذكار بالكامل
> تغطي: Unit Tests · Widget Tests · Integration Tests

---

## 📁 هيكل الميزة

```
azkar/
├── data/
│   ├── constants/azkar_constants.dart
│   ├── datasources/
│   │   ├── i_azkar_local_data_source.dart
│   │   ├── azkar_local_data_source_impl.dart
│   │   ├── reminder_local_data_source.dart
│   │   └── reminder_local_data_source_impl.dart
│   ├── mappers/reminder_mapper.dart
│   ├── models/
│   │   ├── category_model.dart
│   │   ├── reminder_model.dart
│   │   └── zikr_model.dart
│   └── repositories/
│       ├── azkar_repository_impl.dart
│       ├── reading_settings_repository_impl.dart
│       └── reminder_repository_impl.dart
├── di/azkar_di.dart
├── domain/
│   ├── entities/
│   │   ├── category_entity.dart
│   │   ├── notification_template.dart
│   │   ├── reading_settings.dart
│   │   ├── reminder_entity.dart
│   │   ├── repeat_type.dart
│   │   ├── weekday.dart
│   │   └── zikr_entity.dart
│   ├── params/
│   │   ├── create_reminder_params.dart
│   │   └── update_reminder_params.dart
│   ├── repositories/
│   │   ├── i_azkar_repository.dart
│   │   ├── i_reading_settings_repository.dart
│   │   └── reminder_repository.dart
│   ├── usecases/
│   │   ├── create_reminder_use_case.dart
│   │   ├── delete_reminder_use_case.dart
│   │   ├── get_azkar_by_category_usecase.dart
│   │   ├── get_categories_usecase.dart
│   │   ├── get_reading_settings_usecase.dart
│   │   ├── get_reminders_use_case.dart
│   │   ├── reminder_scheduler_helper.dart
│   │   ├── reminder_use_cases.dart
│   │   ├── toggle_reminder_use_case.dart
│   │   ├── update_reading_settings_usecase.dart
│   │   └── update_reminder_use_case.dart
│   └── validators/reminder_validator.dart
└── presentation/
    ├── cubit/
    │   ├── azkar/ (azkar_cubit, azkar_state, zikr_increment_result)
    │   ├── categories/ (azkar_categories_cubit, azkar_categories_state)
    │   ├── reading_settings/ (reading_settings_cubit, reading_settings_state)
    │   └── reminder/ (reminder_cubit, reminder_state)
    ├── routes/azkar_routes.dart
    ├── utils/category_icon_mapper.dart
    ├── views/azkar_list_view.dart
    └── widgets/
        ├── azkar_list_content.dart
        ├── skeletonizer_azkar_list.dart
        ├── reading_settings/ (font_size_section, reading_settings_bottom_sheet)
        ├── reminder/ (reminder_dialog, reminder_empty_view, reminder_section, reminder_tile, repeat_selector)
        ├── share_card/zikr_share_card.dart
        └── zikr_card/ (zikr_actions_row, zikr_content, zikr_counter, zikr_item_card)
```

---

---

# 🧪 Unit Tests

---

## 1. Data Layer

### 1.1 `AzkarConstants`
- [ ] التأكد إن `metadataBoxName` قيمته `'azkar_metadata_box'`
- [ ] التأكد إن `categoriesBoxName` قيمته `'azkar_categories_box'`
- [ ] التأكد إن `azkarCategoryBoxPrefix` قيمته `'azkar_category_'`
- [ ] التأكد إن `defaultFontSize` = `20`
- [ ] التأكد إن `minFontSize` = `12`
- [ ] التأكد إن `maxFontSize` = `28`
- [ ] التأكد إن `minFontSize < defaultFontSize < maxFontSize`

---

### 1.2 `CategoryModel`
- [ ] `fromJson` يرجّع `CategoryModel` صحيح بـ `id` و `title` من JSON سليم
- [ ] `fromJson` يعمل throw لو `id` مش موجود في الـ JSON
- [ ] `fromJson` يعمل throw لو `title` مش موجود في الـ JSON
- [ ] `fromJson` يعمل throw لو الـ type غلط (مثلاً `id` كـ String بدل int)
- [ ] التأكد إن `CategoryModel` بيـ extend `CategoryEntity`

---

### 1.3 `ZikrModel`
- [ ] `fromJson` يرجّع `ZikrModel` صحيح بكل الـ fields (`id`, `text`, `count`, `reference`, `description`)
- [ ] `fromJson` يشتغل لو `reference` = `null`
- [ ] `fromJson` يشتغل لو `description` = `null`
- [ ] `fromJson` يعمل throw لو `id` مفقود
- [ ] `fromJson` يعمل throw لو `text` مفقود
- [ ] `fromJson` يعمل throw لو `count` مفقود
- [ ] التأكد إن `ZikrModel` بيـ extend `ZikrEntity`

---

### 1.4 `ReminderModel`
- [ ] إنشاء `ReminderModel` بكل الـ fields المطلوبة بنجاح
- [ ] التأكد إن `typeId` = `1`
- [ ] التأكد إن كل الـ fields (`id`, `azkarId`, `time`, `repeatType`, `days`, `isEnabled`, `timezone`, `template`) بتتخزن صح

---

### 1.5 `ReminderModelAdapter`
- [ ] `typeId` بتاعه = `1`
- [ ] `read()` بيعمل deserialize لـ `ReminderModel` صحيح من `BinaryReader`
- [ ] `write()` بيعمل serialize لـ `ReminderModel` صحيح لـ `BinaryWriter`
- [ ] Round-trip test: write ثم read ينتج نفس الـ object
- [ ] `hashCode` بترجّع نفس القيمة لنفس الـ `typeId`
- [ ] `==` بترجّع `true` لـ adapters من نفس النوع
- [ ] `==` بترجّع `false` لأنواع مختلفة

---

### 1.6 `ReminderMapper`
- [ ] `toEntity()` يحوّل `ReminderModel` لـ `ReminderEntity` بقيم صحيحة
- [ ] `toEntity()` يحوّل `repeatType` String لـ `RepeatType` enum صح (once, daily, custom)
- [ ] `toEntity()` يرجّع `RepeatType.once` لو `repeatType` قيمة مش موجودة (fallback)
- [ ] `toEntity()` يحوّل `template` String لـ `NotificationTemplate` enum صح
- [ ] `toEntity()` يرجّع `NotificationTemplate.general` لو `template` قيمة مش موجودة (fallback)
- [ ] `toModel()` يحوّل `ReminderEntity` لـ `ReminderModel` بقيم صحيحة
- [ ] `toModel()` يحوّل `RepeatType` enum لـ String صح
- [ ] `toModel()` يحوّل `NotificationTemplate` enum لـ String صح
- [ ] Round-trip test: `toEntity(toModel(entity))` ينتج entity مطابقة

---

### 1.7 `AzkarLocalDataSourceImpl`
> يحتاج Mock لـ `Hive` و `rootBundle`

- [ ] `ensureDatabaseReady()` — لو الـ version الحالي أقل من الـ asset version، يحدّث الـ data
- [ ] `ensureDatabaseReady()` — لو الـ version الحالي يساوي أو أكبر من الـ asset version، ما يعملش حاجة
- [ ] `ensureDatabaseReady()` — يحذف category boxes القديمة لما يحدّث
- [ ] `ensureDatabaseReady()` — يحدّث الـ version key بعد التحديث
- [ ] `ensureDatabaseReady()` — يعمل rethrow في حالة error
- [ ] `ensureDatabaseReady()` — يعمل report لـ Firebase في حالة error
- [ ] `getCategories()` — يرجّع قائمة `CategoryModel` من الـ Hive box
- [ ] `getCategories()` — يرجّع قائمة فاضية لو الـ box فاضي
- [ ] `getAzkarByCategory()` — يرجّع أذكار من الـ box لو موجودة
- [ ] `getAzkarByCategory()` — يحمّل الأذكار من الـ assets لو الـ box فاضي (lazy load)
- [ ] `getAzkarByCategory()` — يتعامل مع category id مش موجود

---

### 1.8 `ReminderLocalDataSourceImpl`
> يحتاج Mock لـ `Box<ReminderModel>`

- [ ] `getReminders(azkarId)` — يرجّع كل الـ reminders لو `azkarId` فاضي
- [ ] `getReminders(azkarId)` — يرجّع reminders مفلترة بالـ `azkarId` المطلوب
- [ ] `getReminders(azkarId)` — يرجّع قائمة فاضية لو مفيش reminders بالـ `azkarId`
- [ ] `getAllReminders()` — يرجّع كل الـ reminders في الـ box
- [ ] `getAllReminders()` — يرجّع قائمة فاضية لو الـ box فاضي
- [ ] `saveReminder()` — يحفظ الـ reminder في الـ box بالـ `id` كـ key
- [ ] `saveReminder()` — يعمل overwrite لـ reminder موجود بنفس الـ `id`
- [ ] `deleteReminder()` — يحذف الـ reminder من الـ box بالـ `id`
- [ ] `deleteReminder()` — ما يعملش error لو الـ `id` مش موجود
- [ ] التأكد إن `boxName` بترجّع `'reminders_box'`

---

### 1.9 `AzkarRepositoryImpl`
> يحتاج Mock لـ `IAzkarLocalDataSource`

- [ ] `getCategories()` — يرجّع `Result.success` بقائمة الـ categories
- [ ] `getCategories()` — يعمل `ensureDatabaseReady()` أول مرة بس (lazy init)
- [ ] `getCategories()` — ما يعملش `ensureDatabaseReady()` تاني لو اتعملت قبل كده
- [ ] `getCategories()` — يرجّع `Result.failure(CacheFailure)` في حالة exception
- [ ] `getCategories()` — يعمل log للـ error
- [ ] `getAzkarByCategory()` — يرجّع `Result.success` بقائمة الأذكار
- [ ] `getAzkarByCategory()` — يعمل `ensureDatabaseReady()` أول مرة بس
- [ ] `getAzkarByCategory()` — يرجّع `Result.failure(CacheFailure)` في حالة exception
- [ ] `getAzkarByCategory()` — يعمل log للـ error

---

### 1.10 `ReadingSettingsRepositoryImpl`
> يحتاج Mock لـ `ILocalStorageService`

- [ ] `getReadingSettings()` — يرجّع `Result.success` بالـ `ReadingSettings` المحفوظة
- [ ] `getReadingSettings()` — يرجّع `defaultFontSize` لو مفيش قيمة محفوظة
- [ ] `getReadingSettings()` — يرجّع `Result.failure(CacheFailure)` في حالة exception
- [ ] `updateReadingSettings()` — يحفظ الـ fontSize في الـ local storage
- [ ] `updateReadingSettings()` — يرجّع `Result.success(null)` في حالة النجاح
- [ ] `updateReadingSettings()` — يرجّع `Result.failure(CacheFailure)` في حالة exception

---

### 1.11 `ReminderRepositoryImpl`
> يحتاج Mock لـ `IReminderLocalDataSource`

- [ ] `getReminders(azkarId)` — يرجّع `Result.success` بقائمة `ReminderEntity` (mapped من Models)
- [ ] `getReminders(azkarId)` — يرجّع `Result.failure(ReminderFailure)` في حالة exception
- [ ] `getAllReminders()` — يرجّع `Result.success` بكل الـ reminders
- [ ] `getAllReminders()` — يرجّع `Result.failure(ReminderFailure)` في حالة exception
- [ ] `createReminder()` — يحفظ الـ reminder (mapped لـ Model) في الـ data source
- [ ] `createReminder()` — يرجّع `Result.success(null)` في حالة النجاح
- [ ] `createReminder()` — يرجّع `Result.failure(ReminderFailure)` في حالة exception
- [ ] `updateReminder()` — يحدّث الـ reminder في الـ data source
- [ ] `updateReminder()` — يرجّع `Result.success(null)` في حالة النجاح
- [ ] `updateReminder()` — يرجّع `Result.failure(ReminderFailure)` في حالة exception
- [ ] `deleteReminder(id)` — يحذف الـ reminder من الـ data source
- [ ] `deleteReminder(id)` — يرجّع `Result.success(null)` في حالة النجاح
- [ ] `deleteReminder(id)` — يرجّع `Result.failure(ReminderFailure)` في حالة exception
- [ ] `toggleReminder(id, isEnabled: true)` — يجيب الـ reminder ويفعّله ويحفظه
- [ ] `toggleReminder(id, isEnabled: false)` — يجيب الـ reminder ويعطّله ويحفظه
- [ ] `toggleReminder()` — يرجّع `Result.failure` لو الـ reminder مش موجود
- [ ] `toggleReminder()` — يرجّع `Result.failure(ReminderFailure)` في حالة exception
- [ ] `rescheduleAllActiveReminders()` — حاليًا فاضية (verify لا تعمل exception)

---

## 2. Domain Layer

### 2.1 Entities

#### `CategoryEntity`
- [ ] إنشاء `CategoryEntity` بـ `id` و `title`
- [ ] التأكد إن الـ fields بتترجّع صح

#### `ZikrEntity`
- [ ] إنشاء `ZikrEntity` بكل الـ fields المطلوبة
- [ ] `reference` و `description` optional ويقبلوا `null`

#### `ReadingSettings`
- [ ] إنشاء `ReadingSettings` بـ `fontSize`
- [ ] `defaultSettings()` يرجّع `fontSize` = `20` (defaultFontSize)
- [ ] `copyWith(fontSize:)` يرجّع نسخة جديدة بالقيمة الجديدة
- [ ] `copyWith()` بدون parameters يرجّع نسخة مطابقة
- [ ] `==` بيشتغل صح (نفس الـ fontSize = equal)
- [ ] `==` بيشتغل صح (fontSize مختلف = not equal)
- [ ] `hashCode` متساوي لـ objects متساوية

#### `ReminderEntity`
- [ ] إنشاء `ReminderEntity` بكل الـ fields المطلوبة
- [ ] `hour` بيرجّع الساعة صح من format `"HH:mm"`
- [ ] `minute` بيرجّع الدقيقة صح من format `"HH:mm"`
- [ ] `hour` يرجّع `0` لو `time` فاضي
- [ ] `hour` يرجّع `0` لو `time` مش فيه `:`
- [ ] `minute` يرجّع `0` لو `time` فاضي
- [ ] `minute` يرجّع `0` لو `time` مش فيه `:`
- [ ] `copyWith()` يرجّع نسخة جديدة بالقيم المحدّثة
- [ ] `copyWith()` بدون parameters يرجّع نسخة مطابقة
- [ ] `==` يشتغل صح بين entities متساوية
- [ ] `==` يشتغل صح بين entities مختلفة
- [ ] `hashCode` متساوي لـ objects متساوية
- [ ] `allowedReminderCategoryIds` يحتوي على `['2', '3', '4', '5']` فقط

#### `RepeatType`
- [ ] يحتوي على `once`, `daily`, `custom`
- [ ] عدد القيم = 3

#### `WeekDay`
- [ ] يحتوي على 7 أيام من Monday (1) لـ Sunday (7)
- [ ] `fromValue(1)` يرجّع `monday`
- [ ] `fromValue(7)` يرجّع `sunday`
- [ ] `fromValue(99)` يرجّع `monday` (fallback)

#### `NotificationTemplate`
- [ ] يحتوي على `morning`, `evening`, `night`, `wakeUp`, `general`
- [ ] كل template فيه `title` و `body`
- [ ] `fromAzkarId()` يرجّع `morning` للـ `morningAzkarId`
- [ ] `fromAzkarId()` يرجّع `evening` للـ `eveningAzkarId`
- [ ] `fromAzkarId()` يرجّع `night` للـ `sleepAzkarId`
- [ ] `fromAzkarId()` يرجّع `wakeUp` للـ `wakeUpAzkarId`
- [ ] `fromAzkarId()` يرجّع `general` لأي id تاني (default)

---

### 2.2 Params

#### `CreateReminderParams`
- [ ] إنشاء `CreateReminderParams` بكل الـ fields المطلوبة
- [ ] `==` يشتغل صح بين params متساوية
- [ ] `==` يشتغل صح بين params مختلفة
- [ ] `hashCode` متساوي لـ params متساوية
- [ ] `==` يقارن `days` List بشكل صحيح (listEquals)

#### `UpdateReminderParams`
- [ ] إنشاء `UpdateReminderParams` بكل الـ fields المطلوبة
- [ ] `==` يشتغل صح بين params متساوية
- [ ] `==` يشتغل صح بين params مختلفة
- [ ] `hashCode` متساوي لـ params متساوية
- [ ] `==` يقارن `days` List بشكل صحيح (listEquals)

---

### 2.3 Validators

#### `ReminderValidator`
- [ ] `validateTime("")` — يرجّع error "الرجاء تحديد وقت التذكير"
- [ ] `validateTime("abc")` — يرجّع error "صيغة الوقت غير صحيحة" (لا يحتوي على `:`)
- [ ] `validateTime("ab:cd")` — يرجّع error "صيغة الوقت غير صحيحة" (مش أرقام)
- [ ] `validateTime("25:00")` — يرجّع error "الساعة يجب أن تكون بين 0 و 23"
- [ ] `validateTime("-1:00")` — يرجّع error "الساعة يجب أن تكون بين 0 و 23"
- [ ] `validateTime("10:60")` — يرجّع error "الدقيقة يجب أن تكون بين 0 و 59"
- [ ] `validateTime("10:-1")` — يرجّع error "الدقيقة يجب أن تكون بين 0 و 59"
- [ ] `validateTime("00:00")` — valid (isValid = true)
- [ ] `validateTime("23:59")` — valid (isValid = true)
- [ ] `validateTime("12:30")` — valid (isValid = true)
- [ ] `validateDays(RepeatType.custom, [])` — يرجّع error "الرجاء اختيار يوم واحد على الأقل"
- [ ] `validateDays(RepeatType.custom, [1, 3])` — valid
- [ ] `validateDays(RepeatType.daily, [])` — valid (مش custom فمش محتاج أيام)
- [ ] `validateDays(RepeatType.once, [])` — valid
- [ ] `validate()` — يفشل لو الوقت غلط
- [ ] `validate()` — يفشل لو الأيام غلط (custom بدون أيام)
- [ ] `validate()` — ينجح لو كل حاجة صح

#### `ReminderValidationResult`
- [ ] `isValid` = `true` لو `errorMessage` = `null`
- [ ] `isValid` = `false` لو `errorMessage` مش `null`

---

### 2.4 Use Cases

#### `GetCategoriesUseCase`
> يحتاج Mock لـ `IAzkarRepository`

- [ ] `call()` — يستدعي `repository.getCategories()` ويرجّع النتيجة
- [ ] `call()` — يرجّع `Result.success` من الـ repository
- [ ] `call()` — يرجّع `Result.failure` من الـ repository

#### `GetAzkarByCategoryUseCase`
> يحتاج Mock لـ `IAzkarRepository`

- [ ] `call(categoryId)` — يستدعي `repository.getAzkarByCategory(categoryId)` ويرجّع النتيجة
- [ ] `call(categoryId)` — يمرّر الـ `categoryId` صح

#### `GetReadingSettingsUseCase`
> يحتاج Mock لـ `IReadingSettingsRepository`

- [ ] `call()` — يستدعي `repository.getReadingSettings()` ويرجّع النتيجة

#### `UpdateReadingSettingsUseCase`
> يحتاج Mock لـ `IReadingSettingsRepository`

- [ ] `call(settings)` — يستدعي `repository.updateReadingSettings(settings)` ويرجّع النتيجة

#### `GetRemindersUseCase`
> يحتاج Mock لـ `IReminderRepository`

- [ ] `call(azkarId)` — يستدعي `repository.getReminders(azkarId)` ويرجّع النتيجة

#### `CreateReminderUseCase`
> يحتاج Mock لـ `IReminderRepository` و `INotificationScheduler`

- [ ] `call(params)` — يتحقق إن مفيش reminder موجود للـ category قبل الإنشاء
- [ ] `call(params)` — يرجّع `Result.failure` لو reminder موجود بالفعل (`reminderAlreadyExists`)
- [ ] `call(params)` — ينشئ `ReminderEntity` بـ id من `DateTime.now().millisecondsSinceEpoch`
- [ ] `call(params)` — يحفظ الـ reminder في الـ repository
- [ ] `call(params)` — يعمل schedule لو الـ reminder enabled وتم الحفظ بنجاح
- [ ] `call(params)` — ما يعملش schedule لو الـ reminder مش enabled
- [ ] `call(params)` — ما يعملش schedule لو الحفظ فشل
- [ ] `call(params)` — يرجّع الـ result من الـ repository

#### `UpdateReminderUseCase`
> يحتاج Mock لـ `IReminderRepository` و `INotificationScheduler`

- [ ] `call(reminder)` — يستدعي `repository.updateReminder(reminder)`
- [ ] `call(reminder)` — يعمل cancel لكل الـ notifications القديمة لو النتيجة success
- [ ] `call(reminder)` — يعمل schedule جديد لو الـ reminder enabled بعد الـ update
- [ ] `call(reminder)` — ما يعملش schedule لو الـ reminder مش enabled
- [ ] `call(reminder)` — ما يعملش cancel/schedule لو الـ update فشل
- [ ] `call(reminder)` — يرجّع الـ result من الـ repository

#### `DeleteReminderUseCase`
> يحتاج Mock لـ `IReminderRepository` و `INotificationScheduler`

- [ ] `call(id)` — يستدعي `repository.deleteReminder(id)`
- [ ] `call(id)` — يعمل cancel لكل الـ notifications لو النتيجة success
- [ ] `call(id)` — ما يعملش cancel لو الحذف فشل
- [ ] `call(id)` — يرجّع الـ result من الـ repository

#### `ToggleReminderUseCase`
> يحتاج Mock لـ `IReminderRepository` و `INotificationScheduler`

- [ ] `call(id, isEnabled: true)` — يستدعي `repository.toggleReminder(id, isEnabled: true)`
- [ ] `call(id, isEnabled: true)` — يعمل cancel ثم schedule لو النتيجة success
- [ ] `call(id, isEnabled: false)` — يعمل cancel بس (بدون schedule) لو النتيجة success
- [ ] `call(id, ...)` — يرجّع `Result.failure` لو الـ toggle فشل في الـ repository
- [ ] `call(id, ...)` — يرجّع `Result.success(null)` في حالة النجاح

#### `ReminderSchedulerHelper`
> يحتاج Mock لـ `INotificationScheduler`

- [ ] `scheduleAll()` — لو `RepeatType.once`: يعمل schedule لنهارده أو بكره
- [ ] `scheduleAll()` — لو الوقت فات النهارده، يعمل schedule لبكره (once)
- [ ] `scheduleAll()` — لو `RepeatType.daily`: يعمل schedule لـ 7 أيام
- [ ] `scheduleAll()` — لو `RepeatType.custom` مع أيام محددة: يعمل schedule للأيام المحددة بس
- [ ] `scheduleAll()` — يستخدم الـ template الصحيح للـ title و body
- [ ] `scheduleAll()` — يستخدم `NotificationPayload` بالـ type و azkarId الصح
- [ ] `scheduleAll()` — الـ notification id لـ once = `reminderId.hashCode`
- [ ] `scheduleAll()` — الـ notification id لـ days = `'${reminderId}_$day'.hashCode`
- [ ] `cancelAll()` — يلغي الـ once notification
- [ ] `cancelAll()` — يلغي الـ per-day notifications (1 لـ 7)
- [ ] `cancelAll()` — عدد calls لـ `scheduler.cancel` = 8 (1 once + 7 days)

#### `ReminderUseCases` (Facade)
- [ ] يمرّر `getReminders` call للـ `GetRemindersUseCase`
- [ ] يمرّر `createReminder` call للـ `CreateReminderUseCase`
- [ ] يمرّر `updateReminder` call للـ `UpdateReminderUseCase`
- [ ] يمرّر `deleteReminder` call للـ `DeleteReminderUseCase`
- [ ] يمرّر `toggleReminder` call للـ `ToggleReminderUseCase`

---

## 3. Presentation Layer — Cubits (Unit Tests)

### 3.1 `AzkarCubit`
> يحتاج Mock لـ `GetAzkarByCategoryUseCase` و `GetCategoriesUseCase`

- [ ] initial state = `AzkarInitial`
- [ ] `loadAzkar()` — يطلع `AzkarLoading` أولاً
- [ ] `loadAzkar()` — يطلع `AzkarLoaded` بالأذكار والعدادات = 0 لو النتيجة success
- [ ] `loadAzkar()` — يحل الـ `resolvedTitle` من الـ categories لو `fallbackTitle` = default
- [ ] `loadAzkar()` — يستخدم `fallbackTitle` لو ما لقاش الـ category
- [ ] `loadAzkar()` — يستخدم عنوان أول category لو الـ categoryId مش موجود بالضبط
- [ ] `loadAzkar()` — يطلع `AzkarEmpty` لو القائمة فاضية
- [ ] `loadAzkar()` — يطلع `AzkarError` بالرسالة لو النتيجة failure
- [ ] `incrementZikr()` — يرجّع `ZikrIncremented` ويزوّد العداد بـ 1
- [ ] `incrementZikr()` — يرجّع `ZikrCompleted` لما العداد يوصل للحد الأقصى
- [ ] `incrementZikr()` — يرجّع `ZikrIgnored` لو الذكر مكتمل بالفعل
- [ ] `incrementZikr()` — يرجّع `ZikrIgnored` لو الـ state مش `AzkarLoaded`
- [ ] `incrementZikr()` — يرجّع `ZikrIgnored` لو الـ zikrId مش موجود
- [ ] `incrementZikr()` — يطلع state جديد بالعدادات المحدّثة
- [ ] `incrementZikr()` — يعمل vibration مع كل increment
- [ ] `incrementZikr()` — يعمل vibration مزدوج لما يكتمل

### 3.2 `AzkarState`
- [ ] `AzkarLoaded.isAllCompleted` — يرجّع `true` لو كل الأذكار مكتملة
- [ ] `AzkarLoaded.isAllCompleted` — يرجّع `false` لو في ذكر ناقص
- [ ] `AzkarLoaded.hasStarted` — يرجّع `true` لو في عداد > 0
- [ ] `AzkarLoaded.hasStarted` — يرجّع `false` لو كل العدادات = 0
- [ ] `AzkarLoaded.nextIncompleteIndex()` — يرجّع index أول ذكر مش مكتمل بعد الـ index المحدد
- [ ] `AzkarLoaded.nextIncompleteIndex()` — يرجّع `null` لو كل الأذكار بعد الـ index مكتملة
- [ ] `AzkarLoaded.copyWith()` — يرجّع نسخة محدّثة صح

---

### 3.3 `AzkarCategoriesCubit`
> يحتاج Mock لـ `GetCategoriesUseCase`

- [ ] initial state = `AzkarCategoriesInitial`
- [ ] `loadCategories()` — يطلع `AzkarCategoriesLoading` أولاً
- [ ] `loadCategories()` — يطلع `AzkarCategoriesLoaded` بالقائمة لو النتيجة success
- [ ] `loadCategories()` — يطلع `AzkarCategoriesEmpty` لو القائمة فاضية
- [ ] `loadCategories()` — يطلع `AzkarCategoriesError` بالرسالة لو النتيجة failure

---

### 3.4 `ReadingSettingsCubit`
> يحتاج Mock لـ `GetReadingSettingsUseCase` و `UpdateReadingSettingsUseCase`

- [ ] initial state = `ReadingSettingsInitial`
- [ ] `loadSettings()` — يطلع `ReadingSettingsLoaded` بالـ settings لو النتيجة success
- [ ] `loadSettings()` — يطلع `ReadingSettingsError` بالرسالة لو النتيجة failure
- [ ] `changeFontSize()` — يطلع `ReadingSettingsLoaded` بالـ fontSize الجديد لو الـ state loaded
- [ ] `changeFontSize()` — يطلع `ReadingSettingsLoaded` بالـ default + fontSize لو الـ state مش loaded
- [ ] `saveSettings()` — يستدعي `updateSettings` بالـ settings الحالية
- [ ] `saveSettings()` — يطلع `ReadingSettingsError` لو الحفظ فشل
- [ ] `saveSettings()` — ما يعملش حاجة لو الـ state مش `ReadingSettingsLoaded`

---

### 3.5 `ReminderCubit`
> يحتاج Mock لـ `ReminderUseCases`, `IAppPermissionsManager`, `INotificationService`

- [ ] initial state = `ReminderInitial`
- [ ] `requestPermissions()` — يطلب notification permission
- [ ] `requestPermissions()` — يرجّع `false` لو notification permission مرفوض
- [ ] `requestPermissions()` — يتحقق من `canScheduleExactAlarms()` لو الـ permission اتوافق عليه
- [ ] `openSettings()` — يستدعي `permissionsManager.openSettings()`
- [ ] `loadReminders(azkarId)` — يطلع `ReminderLoading` أولاً
- [ ] `loadReminders(azkarId)` — يطلع `ReminderLoaded` بقائمة الـ reminders لو success
- [ ] `loadReminders(azkarId)` — يطلع `ReminderError` بالرسالة لو failure
- [ ] `createReminder()` — يحوّل الـ entity لـ `CreateReminderParams` ويستدعي الـ use case
- [ ] `createReminder()` — يعيد تحميل الـ reminders بعد الإنشاء الناجح
- [ ] `createReminder()` — يطلع `ReminderError` لو الإنشاء فشل ولا يعيد التحميل
- [ ] `updateReminder()` — يستدعي الـ update use case
- [ ] `updateReminder()` — يعيد تحميل الـ reminders بعد التحديث الناجح
- [ ] `updateReminder()` — يطلع `ReminderError` لو التحديث فشل
- [ ] `deleteReminder(id, azkarId)` — يستدعي الـ delete use case
- [ ] `deleteReminder()` — يعيد تحميل الـ reminders بعد الحذف الناجح
- [ ] `deleteReminder()` — يطلع `ReminderError` لو الحذف فشل
- [ ] `toggleReminder(id, azkarId, isEnabled)` — يستدعي الـ toggle use case
- [ ] `toggleReminder()` — يعيد تحميل الـ reminders بعد التبديل الناجح
- [ ] `toggleReminder()` — يطلع `ReminderError` لو التبديل فشل

---

### 3.6 `ReminderState`
- [ ] `ReminderInitial` — equality يشتغل صح
- [ ] `ReminderLoading` — equality يشتغل صح
- [ ] `ReminderLoaded` — equality يقارن الـ `reminders` list بـ `DeepCollectionEquality`
- [ ] `ReminderError` — equality يقارن الـ `message`

---

### 3.7 Presentation Utils

#### `CategoryIconMapper`
- [ ] `getIcon(1)` — يرجّع `FlutterIslamicIcons.solidTasbihHand`
- [ ] `getIcon(2)` — يرجّع `SolarIconsBold.sunrise`
- [ ] `getIcon(3)` — يرجّع `SolarIconsBold.sunset`
- [ ] `getIcon(4)` — يرجّع `SolarIconsBold.moonSleep`
- [ ] `getIcon(5)` — يرجّع `SolarIconsBold.alarm`
- [ ] `getIcon(6)` — يرجّع `FlutterIslamicIcons.wudhu`
- [ ] `getIcon(7)` — يرجّع `FlutterIslamicIcons.solidMinaret`
- [ ] `getIcon(8)` — يرجّع `SolarIconsBold.home`
- [ ] `getIcon(9)` — يرجّع `FlutterIslamicIcons.mosque`
- [ ] `getIcon(10)` — يرجّع `SolarIconsBold.bath`
- [ ] `getIcon(11)` — يرجّع `SolarIconsBold.cup`
- [ ] `getIcon(12)` — يرجّع `SolarIconsBold.hanger`
- [ ] `getIcon(13)` — يرجّع `FlutterIslamicIcons.solidIftar`
- [ ] `getIcon(14)` — يرجّع `SolarIconsBold.sadCircle`
- [ ] `getIcon(15)` — يرجّع `FlutterIslamicIcons.solidPrayingPerson`
- [ ] `getIcon(16)` — يرجّع `FlutterIslamicIcons.solidTasbih`
- [ ] `getIcon(17)` — يرجّع `SolarIconsBold.heart`
- [ ] `getIcon(18)` — يرجّع `CupertinoIcons.smiley_fill`
- [ ] `getIcon(19)` — يرجّع `SolarIconsBold.medicalKit`
- [ ] `getIcon(20)` — يرجّع `FlutterIslamicIcons.solidAllah`
- [ ] `getIcon(21)` — يرجّع `SolarIconsBold.heartBroken`
- [ ] `getIcon(22)` — يرجّع `CupertinoIcons.airplane`
- [ ] `getIcon(23)` — يرجّع `FlutterIslamicIcons.solidSajadah`
- [ ] `getIcon(999)` — يرجّع `FlutterIslamicIcons.tasbih` (default)

---

## 4. DI Layer

### 4.1 `setupAzkarDependencies`
- [ ] يسجّل `ReminderModelAdapter` لو مش مسجّل
- [ ] ما يسجّلش `ReminderModelAdapter` لو مسجّل بالفعل
- [ ] يفتح `reminders_box` من Hive
- [ ] يسجّل `IAzkarLocalDataSource` كـ lazySingleton
- [ ] يسجّل `IReminderLocalDataSource` كـ lazySingleton
- [ ] يسجّل `IAzkarRepository` كـ lazySingleton
- [ ] يسجّل `IReadingSettingsRepository` كـ lazySingleton
- [ ] يسجّل `IReminderRepository` كـ lazySingleton
- [ ] يسجّل كل الـ use cases كـ lazySingleton
- [ ] يسجّل `AzkarCategoriesCubit` كـ factory
- [ ] يسجّل `AzkarCubit` كـ factory
- [ ] يسجّل `ReadingSettingsCubit` كـ factory
- [ ] يسجّل `ReminderUseCases` كـ lazySingleton
- [ ] يسجّل `ReminderCubit` كـ factory

---

---

# 🎨 Widget Tests

---

## 1. `AzkarListView`
- [ ] يعرض `CommonSliverAppBar` بالعنوان الصحيح
- [ ] يعرض زر الإعدادات (tuning icon) في الـ app bar
- [ ] يعرض `SkeletonizerAzkarList` أثناء الـ loading
- [ ] يعرض `AzkarListContent` بعد التحميل الناجح
- [ ] يعرض `AppErrorView` في حالة الـ error
- [ ] الضغط على زر الإعدادات يفتح `ReadingSettingsBottomSheet`
- [ ] لما كل الأذكار تكتمل يعرض toast وينتقل للخلف
- [ ] `PopScope` — يعرض `ConfirmationDialog` لو المستخدم بدأ ولم يكمل
- [ ] `PopScope` — يخرج مباشرة لو المستخدم لم يبدأ
- [ ] `PopScope` — يخرج مباشرة لو المستخدم أكمل كل الأذكار
- [ ] `PopScope` — يخرج مباشرة في حالة الـ error
- [ ] `_scrollToNextItem()` — يعمل scroll للعنصر التالي الغير مكتمل

---

## 2. `AzkarListContent`
- [ ] يعرض `SkeletonizerAzkarList` لما الـ state = `AzkarLoading`
- [ ] يعرض `AppErrorView` بالرسالة لما الـ state = `AzkarError`
- [ ] يعرض `AnimatedSliverList` بالأذكار لما الـ state = `AzkarLoaded`
- [ ] يعرض `ZikrItemCard` لكل ذكر في القائمة
- [ ] يعرض `SizedBox.shrink()` للـ states التانية
- [ ] `onItemCompleted` callback بيتنادى لما ذكر يكتمل
- [ ] يربط `onSharePressed` و `onCopyPressed` صح

---

## 3. `SkeletonizerAzkarList`
- [ ] يعرض `Skeletonizer.sliver` بـ 2 items dummy
- [ ] يستخدم `ZikrItemCardContent` بالقيم الافتراضية

---

## 4. Zikr Card Widgets

### 4.1 `ZikrItemCard`
- [ ] يعرض `ZikrContent` بالنص والوصف
- [ ] يعرض `ZikrActionsRow` بالعداد والـ progress
- [ ] الضغط يزوّد العداد بـ 1
- [ ] Long press يزوّد العداد بـ 1
- [ ] ما يستجيبش للضغط لو الذكر مكتمل
- [ ] يطبّق `AnimatedOpacity` (0.5 لو مكتمل)
- [ ] يطبّق `AnimatedScale` (0.98 لو مكتمل)
- [ ] يستخدم الـ fontSize من `ReadingSettingsCubit`
- [ ] يعمل rebuild بس لما العداد بتاعه يتغير (`buildWhen`)
- [ ] يستدعي `onCompleted` لما الذكر يكتمل

### 4.2 `ZikrItemCardContent`
- [ ] يعرض `ZikrContent` بالنص
- [ ] يعرض `ZikrActionsRow`
- [ ] يعرض `CustomAppDivider` بين المحتوى والأزرار
- [ ] يطبّق `RepaintBoundary`
- [ ] يطبّق `Semantics` بالـ label والـ hint والـ value الصحيحين
- [ ] Semantics value بيعرض "مكتمل" لو `isCompleted`
- [ ] Semantics value بيعرض العدد المتبقي لو مش مكتمل

### 4.3 `ZikrContent`
- [ ] يعرض الـ `text` بـ center alignment
- [ ] يعرض الـ `subText` لو مش null ومش فاضي
- [ ] ما يعرضش الـ `subText` لو null
- [ ] ما يعرضش الـ `subText` لو فاضي
- [ ] يطبّق الـ `fontSize` المحدد

### 4.4 `ZikrShareContent`
- [ ] يعرض الـ `text` بـ center alignment بـ Quran font
- [ ] يعرض الـ `subText` لو مش null ومش فاضي
- [ ] ما يعرضش الـ `subText` لو null
- [ ] `maxLines` = 10 للنص الرئيسي
- [ ] `maxLines` = 2 للنص الثانوي

### 4.5 `ZikrActionsRow`
- [ ] يعرض `CombinedShareCopyButton`
- [ ] يعرض `ZikrCounter`
- [ ] يمرّر `onShare` و `onCopy` callbacks صح
- [ ] يطبّق `Semantics` على الأزرار والعداد

### 4.6 `ZikrCounter`
- [ ] يعرض العداد بالرقم لو الذكر مش مكتمل
- [ ] يعرض أيقونة ✓ لو الذكر مكتمل
- [ ] يعرض `CircularProgressIndicator` بالقيمة الصحيحة
- [ ] يعمل animation سلس لما الـ progress يتغير
- [ ] يستخدم `font20` لو `remainingCount > 99`
- [ ] يستخدم `font24` لو `remainingCount <= 99`
- [ ] `AnimatedSwitcher` يعمل transition بين الرقم والأيقونة

---

## 5. Reading Settings Widgets

### 5.1 `ReadingSettingsBottomSheet`
- [ ] يعرض العنوان "إعدادات القراءة"
- [ ] يعرض `FontSizeSection`
- [ ] يعرض `ReminderSection` بالـ `azkarId` الصحيح
- [ ] يوفر `ReadingSettingsCubit` للـ children عبر `BlocProvider.value`

### 5.2 `FontSizeSection`
- [ ] يعرض عنوان "حجم الخط"
- [ ] يعرض القيمة الحالية للـ fontSize
- [ ] يعرض `Slider` بالحد الأدنى 12 والحد الأقصى 28
- [ ] الـ Slider بـ 8 divisions
- [ ] يعرض labels "صغير" و "كبير"
- [ ] يعرض preview text بالحجم الحالي
- [ ] سحب الـ Slider يغيّر الحجم محليًا (بدون cubit update أثناء السحب)
- [ ] إنهاء السحب يحدّث الـ cubit ويحفظ

---

## 6. Reminder Widgets

### 6.1 `ReminderSection`
- [ ] ما يعرضش أي حاجة لو الـ `azkarId` مش في `allowedReminderCategoryIds`
- [ ] يعرض عنوان "التذكير"
- [ ] يعرض زر "إضافة" لو مفيش reminders
- [ ] يخفي زر "إضافة" لو في reminder موجود
- [ ] يعرض `_ReminderSkeleton` أثناء الـ loading
- [ ] يعرض `_ReminderErrorView` في حالة الـ error
- [ ] يعرض `ReminderTile` لكل reminder
- [ ] الضغط على "إضافة" يفتح `ReminderDialog`
- [ ] الضغط على reminder tile يفتح `ReminderDialog` بالـ existing reminder
- [ ] يعرض permission rationale dialog قبل إنشاء reminder
- [ ] يعرض permission denied dialog لو الصلاحية مرفوضة
- [ ] يعرض success toast بعد إنشاء/تحديث reminder ناجح

### 6.2 `ReminderDialog`
- [ ] يعرض عنوان "إضافة تذكير" لـ reminder جديد
- [ ] يعرض عنوان "تعديل التذكير" لـ reminder موجود
- [ ] يعرض الوقت الحالي كافتراضي لـ reminder جديد
- [ ] يعرض الوقت الموجود لـ reminder قائم
- [ ] الضغط على الوقت يفتح `showTimePicker`
- [ ] يعرض `RepeatSelector` بالقيم المبدئية الصحيحة
- [ ] زر "حفظ" يتحقق من الصحة (validation) قبل الحفظ
- [ ] زر "حفظ" يعرض toast خطأ لو validation فشل
- [ ] زر "حفظ" يرجّع `ReminderEntity` لو validation نجح
- [ ] زر "إلغاء" يقفل الـ dialog بدون ما يرجّع حاجة
- [ ] يستخدم `NotificationTemplate.fromAzkarId()` للـ template
- [ ] default `repeatType` = `RepeatType.daily` لـ reminder جديد
- [ ] يحتفظ بنفس `id` و `isEnabled` للـ existing reminder

### 6.3 `ReminderTile`
- [ ] يعرض الوقت بالتنسيق المحلي
- [ ] يعرض "مرة واحدة" لـ `RepeatType.once`
- [ ] يعرض "يوميًا" لـ `RepeatType.daily`
- [ ] يعرض أسماء الأيام المختارة لـ `RepeatType.custom`
- [ ] `Switch` يعكس حالة `isEnabled`
- [ ] الضغط على `Switch` يستدعي `onToggle` بالقيمة الجديدة
- [ ] الضغط على زر الحذف يستدعي `onDelete`
- [ ] الضغط على الـ tile يستدعي `onTap`
- [ ] الألوان تتغير حسب حالة `isEnabled`
- [ ] يطبّق `InkWell` بـ `borderRadius`

### 6.4 `ReminderEmptyView`
- [ ] يعرض أيقونة `notifications_off_outlined`
- [ ] يعرض رسالة "لا يوجد تذكير نشط لهذا الذكر"
- [ ] ملفوف في `AppSectionCard`

### 6.5 `RepeatSelector`
- [ ] يعرض 3 خيارات: "مرة واحدة"، "يوميًا"، "أيام محددة"
- [ ] الخيار المبدئي يكون محدد
- [ ] الضغط على خيار يغيّر الاختيار ويستدعي `onChanged`
- [ ] اختيار "أيام محددة" يعرض أزرار الأيام
- [ ] الضغط على يوم يفعّله/يعطّله ويستدعي `onChanged`
- [ ] التبديل من "أيام محددة" لخيار تاني يمسح قائمة الأيام
- [ ] يعرض كل أيام الأسبوع (7 أيام) في الـ custom mode
- [ ] الأيام المحددة تظهر بلون مختلف (primary)

---

## 7. Share Card Widget

### 7.1 `ZikrShareCard`
- [ ] يعرض `ShareCardContainer`
- [ ] يعرض `ZikrShareContent` بالنص
- [ ] يعرض `AppInfoShare` بالقسم الصحيح
- [ ] يعرض `CustomAppDivider`
- [ ] يعرض الأيقونة الخلفية (book icon) بشفافية منخفضة

---

---

# 🔗 Integration Tests

---

## 1. تدفق عرض الأذكار (Azkar Flow)
- [ ] فتح category → تحميل الأذكار → عرض القائمة بنجاح
- [ ] فتح category فاضية → عرض حالة الفراغ
- [ ] فتح category → فشل التحميل → عرض رسالة الخطأ
- [ ] التنقل من categories screen لـ azkar list screen بالـ categoryId الصحيح
- [ ] الـ app bar يعرض اسم الـ category الصحيح

---

## 2. تدفق عد الأذكار (Counter Flow)
- [ ] الضغط على ذكر يزوّد العداد بـ 1
- [ ] الـ progress ring يتحرك مع كل ضغطة
- [ ] لما ذكر يكتمل: يتحول لشكل مكتمل (opacity 0.5, scale 0.98, ✓)
- [ ] لما ذكر يكتمل: يعمل scroll تلقائي للذكر التالي
- [ ] لما كل الأذكار تكتمل: يعرض toast "اكتملت" وينتقل للخلف
- [ ] الأذكار المكتملة لا تستجيب للضغط

---

## 3. تدفق الخروج (Exit Flow)
- [ ] الرجوع بدون بدء العد → يخرج مباشرة
- [ ] الرجوع بعد البدء وقبل الاكتمال → يعرض dialog تأكيد
- [ ] الموافقة على dialog الخروج → يخرج
- [ ] رفض dialog الخروج → يبقى في الشاشة
- [ ] الرجوع بعد اكتمال كل الأذكار → يخرج مباشرة

---

## 4. تدفق إعدادات القراءة (Reading Settings Flow)
- [ ] فتح bottom sheet → عرض حجم الخط الحالي
- [ ] تغيير حجم الخط → تحديث preview + حجم نصوص الأذكار
- [ ] تغيير حجم الخط → الحفظ تلقائيًا عند إنهاء السحب
- [ ] إغلاق وإعادة فتح → الحجم الجديد لسه محفوظ
- [ ] الـ Slider محدود بين 12 و 28

---

## 5. تدفق التذكيرات (Reminder Flow)
- [ ] التذكيرات تظهر بس لـ categories المسموحة (2, 3, 4, 5)
- [ ] التذكيرات مش ظاهرة لـ categories غير مسموحة
- [ ] إضافة تذكير جديد → permission dialog → time picker → repeat selector → حفظ
- [ ] التذكير الجديد يظهر في القائمة
- [ ] تعديل تذكير موجود → الـ dialog يعرض القيم الحالية
- [ ] حفظ التعديل → التذكير المحدث يظهر
- [ ] حذف تذكير → التذكير يختفي من القائمة
- [ ] تفعيل/تعطيل تذكير بالـ switch → الحالة تتغير
- [ ] زر "إضافة" يختفي لو في reminder موجود بالفعل
- [ ] محاولة إضافة تذكير تاني → رسالة خطأ "تذكير موجود بالفعل"

---

## 6. تدفق الصلاحيات (Permissions Flow)
- [ ] إضافة تذكير → يعرض permission rationale dialog أولاً
- [ ] رفض rationale dialog → لا يحصل حاجة
- [ ] قبول rationale → طلب notification permission
- [ ] رفض permission → عرض denied dialog مع خيار فتح الإعدادات
- [ ] الضغط على "فتح الإعدادات" → يفتح إعدادات التطبيق
- [ ] تفعيل تذكير معطّل → يطلب permission
- [ ] تعطيل تذكير → لا يطلب permission

---

## 7. تدفق المشاركة والنسخ (Share & Copy Flow)
- [ ] الضغط على مشاركة → يولد صورة الذكر ويشاركها
- [ ] الضغط على نسخ → ينسخ نص الذكر في الـ clipboard
- [ ] صورة المشاركة تحتوي على النص والوصف واسم التطبيق

---

## 8. تدفق الـ Routing
- [ ] `/azkar/:categoryId` route يفتح `AzkarListView` بالـ `categoryId` الصحيح
- [ ] الـ extra title يتمرر من الـ route لو موجود
- [ ] الـ transition يستخدم `AppTransitions.fade`

---

## 9. تدفق الـ DI (Dependency Injection)
- [ ] بعد `setupAzkarDependencies()` كل الـ dependencies مسجّلة وقابلة للاستخدام
- [ ] `AzkarCubit` ينشأ بنجاح من الـ service locator
- [ ] `ReminderCubit` ينشأ بنجاح من الـ service locator
- [ ] `ReadingSettingsCubit` ينشأ بنجاح من الـ service locator
- [ ] `AzkarCategoriesCubit` ينشأ بنجاح من الـ service locator

---

## 📊 ملخص العدد

| النوع | العدد التقريبي |
|---|---|
| Unit Tests | ~220 |
| Widget Tests | ~110 |
| Integration Tests | ~55 |
| **الإجمالي** | **~385** |

---

> ⚠️ **ملاحظات مهمة:**
> - كل الـ Unit Tests اللي بتتعامل مع dependencies خارجية محتاجة Mocks (استخدم `mocktail` أو `mockito`)
> - Widget Tests محتاجة `MaterialApp` wrapper + `BlocProvider` مع Mocked Cubits
> - Integration Tests محتاجة setup كامل للـ DI مع in-memory Hive
> - الأولوية: Domain Layer Unit Tests أولاً → Data Layer → Cubits → Widget Tests → Integration Tests
