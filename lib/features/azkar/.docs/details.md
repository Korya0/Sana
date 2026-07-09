# 🚀 Phase 2 — Reading Experience

> **الهدف:** توفير تجربة قراءة مريحة وقابلة للتخصيص.
>

---

## 🧭 جدول المحتويات والتنقل السريع (Navigation Menu)

| القسم | الرابط | الوصف |
| :--- | :--- | :--- |
| **F01** | [F01 — Requirements](#f01--requirements) | متطلبات تجربة القراءة العامة والـ Edge Cases |
| **F02** | [F02 — Product Spec (PRD)](#f02--product-requirements-document) | مواصفات المنتج وتفاصيل واجهة المستخدم والـ Flows |
| **F03** | [F03 — Architecture](#f03--architecture-design) | التصميم الهندسي وتوزيع الـ Layers وحركة البيانات |
| **F04** | [F04 — Database / API Design](#f04--database--api-design) | تصميم قاعدة البيانات المحلية وهيكل تخزين البيانات |

--- 

### Feature 2.1 — Reading Preferences

- تكبير الخط.
- تصغير الخط.
- حفظ الحالة.

### Feature 2.2 — Reading Session

- منع إطفاء الشاشة أثناء القراءة.

### Feature 2.3 — Reading Session

- دعم قارئ الشاشة. 

- Phase2

    <aside>
    💡

    - [F01 — Requirements](#f01--requirements)

        # F01 — Requirements

        # Feature: Reading Experience

        ## 1) Goal — الهدف

        توفير تجربة قراءة مريحة وقابلة للتخصيص للمستخدم أثناء قراءة الأذكار، بحيث يستطيع المستخدم التحكم في طريقة عرض المحتوى بما يناسب احتياجاته، مع تحسين تجربة القراءة لفترات طويلة ودعم إمكانية الوصول.

        ---

        ## 2) Problem — المشكلة التي تحلها الـ Feature

        المستخدمون يختلفون في طريقة القراءة المناسبة لهم:

        - بعض المستخدمين يحتاجون خطًا أكبر بسبب صعوبة القراءة.
        - بعض المستخدمين يفضلون خطًا أصغر لرؤية محتوى أكثر في الشاشة.
        - المستخدم قد يضبط إعداداته ثم يفقدها عند إعادة فتح التطبيق.
        - القراءة لفترة طويلة قد تسبب إزعاجًا بسبب إطفاء الشاشة تلقائيًا.
        - بعض المستخدمين الذين يعتمدون على أدوات الوصول يحتاجون دعم قارئ الشاشة.

        ---

        # 3) User Story

        ## Reading Preferences

        > As a user reading Azkar,
        > 
        > 
        > I want to customize the text size,
        > 
        > So that I can read the content comfortably.
        > 

        ---

        ## Save Reading Preferences

        > As a user,
        > 
        > 
        > I want my text size preference to be saved,
        > 
        > So that I don't need to adjust it every time I open Azkar.
        > 

        ---

        ## Keep Screen Awake

        > As a user reading Azkar,
        > 
        > 
        > I want to prevent the screen from turning off during reading,
        > 
        > So that I can continue reading without interruption.
        > 

        ---

        ## Screen Reader Support

        > As a user who uses accessibility tools,
        > 
        > 
        > I want Azkar pages to support screen readers,
        > 
        > So that I can access the content easily.
        > 

        ---

        # 4) Business Rules

        ## Font Size Rules

        - يوجد حد أقصى لحجم الخط.
        - يوجد حد أدنى لحجم الخط.
        - المستخدم لا يستطيع تجاوز الحدود المحددة.
        - تغيير حجم الخط يؤثر على صفحات الأذكار فقط.

        ---

        ## Saving Preference Rules

        - يتم حفظ حجم الخط الذي اختاره المستخدم.
        - عند فتح التطبيق مرة أخرى:
        - يتم استرجاع آخر حجم خط اختاره المستخدم.
        - الإعداد محفوظ لقسم الأذكار فقط.
        - لا يؤثر على باقي أجزاء التطبيق.

        مثال:

        ```
        Azkar
        ├── Morning Azkar
        ├── Evening Azkar
        └── Ruqyah

        كلهم يستخدمون نفس إعداد الخط
        ```

        لكن:

        ```
        Quran
        Prayer
        Books

        لهم إعدادات منفصلة
        ```

        ---

        ## Keep Screen Awake Rules

        - منع إطفاء الشاشة يعمل فقط داخل تجربة قراءة الأذكار.
        - عند الخروج من صفحة الأذكار:
        - يعود النظام للسلوك الطبيعي.
        - المستخدم يستطيع تشغيل أو إيقاف الخاصية.

        ---

        ## Screen Reader Rules

        - المحتوى يجب أن يكون قابلًا للقراءة بواسطة أدوات Accessibility.
        - العناصر التفاعلية يجب أن يكون لها وصف واضح.
        - الأزرار يجب أن تحتوي على Labels مناسبة.

        ---

        # 5) Functional Requirements

        ## Feature 2.1 — Reading Preferences

        ### Increase Font Size

        النظام يجب أن يسمح للمستخدم:

        - زيادة حجم الخط.
        - تحديث شكل النص مباشرة.
        - حفظ الاختيار.

        ---

        ### Decrease Font Size

        النظام يجب أن يسمح للمستخدم:

        - تقليل حجم الخط.
        - منع النزول أقل من الحد الأدنى.
        - تحديث النص مباشرة.

        ---

        ### Save Reading State

        النظام يجب أن:

        - يحفظ آخر حجم خط اختاره المستخدم.
        - يستعيد القيمة عند فتح صفحات الأذكار مرة أخرى.

        ---

        # Feature 2.2 — Reading Session

        ## Prevent Screen Sleep

        النظام يجب أن:

        - يسمح للمستخدم بتفعيل منع إطفاء الشاشة.
        - يحافظ على الشاشة مفتوحة أثناء القراءة.
        - يعيد التحكم للنظام بعد مغادرة صفحة الأذكار.

        ---

        # Feature 2.3 — Accessibility

        ## Screen Reader Support

        النظام يجب أن:

        - يدعم قارئ الشاشة.
        - يجعل النص مقروءًا بوضوح.
        - يوفر وصفًا للأزرار.

        ---

        # 6) Non Functional Requirements

        ## Performance

        - تغيير حجم الخط يجب أن يكون سريعًا بدون Lag.
        - لا يسبب إعادة بناء غير ضرورية للصفحة كاملة.

        ---

        ## User Experience

        - الإعدادات يجب أن تكون واضحة وسهلة الوصول.
        - الأزرار في الـ App Bar يجب أن تكون مفهومة للمستخدم.
        - التغيير يجب أن يظهر مباشرة.

        ---

        ## Accessibility

        - التطبيق يجب أن يكون قابلًا للاستخدام مع أدوات الوصول.
        - النصوص والأزرار يجب أن تكون واضحة.

        ---

        ## Maintainability

        - إعدادات القراءة يجب أن تكون منفصلة عن منطق عرض الأذكار.
        - إمكانية إضافة إعدادات قراءة مستقبلية بسهولة.

        ---

        # 7) Edge Cases

        - المستخدم يضغط زيادة الخط حتى يصل للحد الأقصى.
        - المستخدم يضغط تقليل الخط حتى يصل للحد الأدنى.
        - المستخدم يفتح التطبيق بعد تغيير الخط سابقًا.
        - المستخدم يخرج من صفحة الأذكار أثناء تفعيل منع إطفاء الشاشة.
        - المستخدم يقفل التطبيق ويفتحه مرة أخرى.
        - الجهاز لا يحتوي على دعم Screen Reader.
        - المستخدم يستخدم حجم خط كبير جدًا مع شاشة صغيرة.
        - النص طويل جدًا بعد زيادة حجم الخط.

        ---

        # 8) Acceptance Criteria

        ## Font Size

        ✅ User can increase text size.

        ✅ User can decrease text size.

        ✅ Font size cannot exceed maximum limit.

        ✅ Font size cannot go below minimum limit.

        ✅ Changes appear immediately.

        ---

        ## Saving Preference

        ✅ Selected font size is saved.

        ✅ Previous font size is restored when reopening Azkar.

        ✅ Preference affects Azkar section only.

        ---

        ## Screen Awake

        ✅ User can enable screen awake mode.

        ✅ Screen remains active during Azkar reading.

        ✅ Screen behavior returns to normal after leaving the page.

        ---

        ## Screen Reader

        ✅ Azkar content can be read using screen reader.

        ✅ Buttons have meaningful accessibility labels.

    - [F02 — Product Spec (PRD)](#f02--product-requirements-document)

        # F02 — Product Requirements Document

        # Feature: Reading Experience

        ---

        # 1) Overview — نظرة عامة

        ## Feature Description

        تهدف الـ Feature إلى تحسين تجربة قراءة الأذكار من خلال توفير إعدادات قراءة سهلة الوصول داخل صفحة الأذكار.

        بدل أن تكون الصفحة مجرد محتوى نصي، يحصل المستخدم على أدوات تساعده على تخصيص تجربة القراءة حسب احتياجاته:

        - التحكم في حجم الخط.
        - منع إطفاء الشاشة أثناء القراءة.
        - دعم المستخدمين الذين يعتمدون على Screen Reader.

        جميع هذه الإعدادات ستكون متاحة من خلال أيقونة واحدة داخل الـ App Bar، تفتح Bottom Sheet تحتوي على أقسام التحكم المختلفة.

        ---

        # 2) Functional Requirements

        # Reading Settings Entry Point

        ## Settings Button

        داخل صفحة الأذكار:

        - يوجد Icon في الـ App Bar.
        - عند الضغط عليه:
        - يتم فتح Bottom Sheet.
        - يحتوي على 3 Sections منفصلة.

        الشكل:

        ```
        Azkar Screen

        App Bar
        |
        ↓
        Settings Icon
        |
        ↓
        Bottom Sheet

        ------------------
        Font Size
        ------------------
        Keep Screen Awake
        ------------------
        Screen Reader
        ------------------
        ```

        ---

        # Section 1 — Font Size Control

        ## User Interaction

        المستخدم يستطيع:

        - زيادة حجم الخط.
        - تقليل حجم الخط.

        طريقة التحكم:

        - Slider للتحكم في الحجم.
        - يظهر Preview لحجم النص أثناء التعديل.

        مثال:

        ```
        Font Size

        Small --------●------ Large

        Preview:
        اللهم بك أصبحنا...
        ```

        ---

        ## Behavior

        عند تغيير الحجم:

        - يتم تحديث النص مباشرة.
        - يتم حفظ القيمة مباشرة.
        - لا يحتاج المستخدم للضغط على Save.

        ---

        ## Storage

        يتم حفظ الإعداد في:

        ```
        Local Storage
        |
        ↓
        Hive
        ```

        ---

        ## Scope

        الإعداد يكون:

        ```
        Azkar Settings

        Morning Azkar
        Evening Azkar
        Ruqyah

        Same Font Size
        ```

        ولا يؤثر على:

        ```
        Quran
        Books
        Other Features
        ```

        ---

        # Section 2 — Keep Screen Awake

        ## User Interaction

        المستخدم لديه:

        ```
        Toggle Button

        OFF  ○
        ON   ●
        ```

        ---

        ## Behavior

        عند التفعيل:

        - الشاشة لا تدخل Sleep أثناء قراءة الأذكار.

        عند الإيقاف:

        - يعود الجهاز للسلوك الطبيعي.

        ---

        ## Storage

        حالة الـ Toggle يتم حفظها.

        مثال:

        اليوم:

        ```
        Keep Screen Awake = ON
        ```

        غدًا عند فتح التطبيق:

        ```
        Keep Screen Awake = ON
        ```

        ---

        # Section 3 — Screen Reader

        ## User Interaction

        المستخدم يستطيع:

        - تشغيل أو إيقاف دعم Screen Reader.

        عن طريق:

        ```
        Toggle Button
        ```

        ---

        ## Accessibility Requirements

        يجب دعم:

        - قراءة محتوى الأذكار.
        - Accessibility labels للأزرار.
        - وصف حالة الـ Toggle.

        مثال:

        بدل:

        ```
        Button
        ```

        يقرأ:

        ```
        Enable Screen Reader Support
        Currently Enabled
        ```

        ---

        ## Device Compatibility

        إذا الجهاز لا يدعم Screen Reader:

        الحالة:

        ```
        Toggle Disabled
        ```

        وعند الضغط:

        يظهر للمستخدم:

        ```
        Screen Reader is not available on your device.
        ```

        ---

        # 3) Non Functional Requirements

        ## Priority

        ترتيب الأولويات:

        1. User Experience
        2. Performance
        3. Accessibility
        4. Maintainability

        ---

        ## User Experience

        - الإعدادات يجب أن تكون سهلة الوصول.
        - المستخدم يفهم وظيفة كل خيار.
        - التغيير يظهر مباشرة.
        - لا يوجد خطوات إضافية غير ضرورية.

        ---

        ## Performance

        - تغيير حجم الخط يجب أن يكون سريعًا.
        - فتح Bottom Sheet بدون تأخير.
        - عدم إعادة بناء عناصر غير ضرورية.

        ---

        ## Accessibility

        - دعم Screen Reader.
        - توفير وصف واضح للأزرار.
        - دعم التنقل الصحيح.

        ---

        ## Maintainability

        - فصل منطق إعدادات القراءة عن UI.
        - إمكانية إضافة إعدادات مستقبلية مثل:
        - نوع الخط.
        - تباعد الأسطر.
        - الوضع الليلي.

        ---

        # 4) User Flow

        # Flow 1 — Change Font Size

        ```
        User opens Azkar screen

        ↓

        Clicks Settings Icon

        ↓

        Bottom Sheet opens

        ↓

        User adjusts Font Slider

        ↓

        Text size changes immediately

        ↓

        Preference saved in Hive

        ↓

        User continues reading
        ```

        ---

        # Flow 2 — Keep Screen Awake

        ```
        User opens Settings

        ↓

        Enable Keep Screen Awake Toggle

        ↓

        Save preference

        ↓

        Continue reading

        ↓

        Screen remains active
        ```

        ---

        # Flow 3 — Screen Reader

        ```
        User opens Settings

        ↓

        Checks Screen Reader Toggle

        ↓

        System checks device support

        ↓

        If supported:

        Enable feature

        If not supported:

        Disable toggle
        Show message
        ```

        ---

        # 5) Error States

        ## Storage Failure

        إذا فشل حفظ الإعداد:

        Expected behavior:

        - استخدام آخر قيمة محفوظة.
        - عرض رسالة مناسبة للمستخدم.

        مثال:

        ```
        Unable to save reading settings.
        Please try again.
        ```

        ---

        ## Screen Reader Not Supported

        الحالة:

        ```
        Toggle Disabled
        ```

        Message:

        ```
        Your device does not support Screen Reader.
        ```

        ---

        ## Invalid Font Size

        مثال:

        محاولة الوصول لحجم أكبر من الحد:

        Behavior:

        - يبقى عند Maximum Value.
        - لا يسمح بتجاوز الحد.

        ---

        ## Offline

        لا يوجد Error.

        السبب:

        Feature الأذكار تعمل Offline بالكامل.

        ---

        # 6) Acceptance Criteria

        ## Settings Access

        ✅ User can open Reading Settings from Azkar App Bar.

        ✅ Bottom Sheet displays all reading options.

        ---

        ## Font Size

        ✅ User can increase font size.

        ✅ User can decrease font size.

        ✅ Text updates immediately.

        ✅ Font size is saved locally.

        ✅ Setting remains after reopening app.

        ✅ Font size affects Azkar section only.

        ---

        ## Keep Screen Awake

        ✅ User can enable/disable screen awake.

        ✅ Screen remains active while reading.

        ✅ Setting is remembered.

        ---

        ## Screen Reader

        ✅ User can enable screen reader support.

        ✅ Buttons provide accessibility descriptions.

        ✅ Toggle state is readable.

        ✅ Unsupported devices disable the option.

    - [F03 — Architecture](#f03--architecture-design)

        # F03 — Architecture Design

        ## Feature: Reading Experience

        ## Project Stack

        ```
        Flutter
        Clean Architecture
        Cubit
        Feature First
        Repository Pattern
        Hive (Local Storage)
        ```

        ---

        # 1) Architecture Decision

        ## Feature Placement

        Reading Experience ليست Feature مستقلة.

        هي جزء من:

        ```
        Azkar Feature
        ```

        لأن:

        - إعدادات القراءة ليس لها معنى خارج قراءة الأذكار.
        - حجم الخط مرتبط بعرض محتوى الأذكار.
        - Screen Reader و Keep Screen Awake خاصين بتجربة قراءة الأذكار.

        إذن تكون داخل:

        ```
        features/
        └── azkar/
        ```

        ---

        # 2) Folder Structure

        ```
        features/
        └── azkar/
            │
            ├── data/
            │   │
            │   ├── datasources/
            │   │   └── reading_settings_local_datasource.dart
            │   │
            │   ├── models/
            │   │   └── reading_settings_model.dart
            │   │
            │   └── repositories/
            │       └── reading_settings_repository_impl.dart
            │
            ├── domain/
            │   │
            │   ├── entities/
            │   │   └── reading_settings.dart
            │   │
            │   ├── repositories/
            │   │   └── reading_settings_repository.dart
            │   │
            │   └── usecases/
            │       ├── get_reading_settings.dart
            │       └── update_reading_settings.dart
            │
            └── presentation/
                │
                ├── cubit/
                │   ├── reading_settings_cubit.dart
                │   └── reading_settings_state.dart
                │
                ├── views/
                │   └── reading_settings/
                │       ├── reading_settings_bottom_sheet.dart
                │       ├── font_size_section.dart
                │       ├── screen_awake_section.dart
                │       └── screen_reader_section.dart
                │
                └── pages/
        ```

        ---

        # 3) Layer Responsibilities

        # Presentation Layer

        مسؤول عن:

        - عرض Bottom Sheet.
        - استقبال تفاعل المستخدم.
        - عرض حالة الإعدادات.
        - تحديث الـ UI.

        لا يعرف:

        - Hive.
        - طريقة التخزين.
        - تفاصيل Data Source.

        ---

        ## Reading Settings View

        المكان:

        ```
        presentation/views/reading_settings/
        ```

        مسؤول عن UI فقط.

        يحتوي:

        ### reading_settings_bottom_sheet.dart

        الـ Container الرئيسي:

        ```
        Bottom Sheet

         |
         ├── Font Size Section
         |
         ├── Keep Screen Awake Section
         |
         └── Screen Reader Section
        ```

        ---

        ### font_size_section.dart

        مسؤول عن:

        - Slider.
        - عرض Preview.
        - التحكم في حجم الخط.

        ---

        ### screen_awake_section.dart

        مسؤول عن:

        - Toggle منع إطفاء الشاشة.
        - عرض الحالة الحالية.

        ---

        ### screen_reader_section.dart

        مسؤول عن:

        - Toggle الخاص بالـ Accessibility.
        - عرض حالة الدعم.

        ---

        # Cubit

        ## ReadingSettingsCubit

        مسؤول عن:

        - إدارة حالة Settings.
        - استقبال أحداث المستخدم.
        - التواصل مع UseCases.

        مثال:

        ```
        changeFontSize()

        toggleScreenAwake()

        toggleScreenReader()
        ```

        ---

        # Domain Layer

        هذه أهم Layer لأنها تحتوي على Business Rules.

        ---

        # Entity

        ## ReadingSettings

        يمثل مفهوم إعدادات القراءة داخل النظام.

        يحتوي:

        ```
        ReadingSettings

        - fontSize
        - keepScreenAwake
        - screenReaderEnabled
        ```

        مثال:

        ```
        ReadingSettings(fontSize:20,keepScreenAwake:true,screenReaderEnabled:false)
        ```

        ---

        # Repository Interface

        المكان:

        ```
        domain/repositories/
        ```

        ```
        abstract class ReadingSettingsRepository
        ```

        مسؤول عن تعريف العمليات المطلوبة:

        ```
        getSettings()

        updateSettings()
        ```

        ولا يعرف:

        - Hive.
        - Shared Preferences.
        - Database.

        ---

        # Use Cases

        ## GetReadingSettings

        المسؤول عن:

        جلب إعدادات المستخدم.

        Flow:

        ```
        Cubit

        ↓

        GetReadingSettings

        ↓

        Repository
        ```

        ---

        ## UpdateReadingSettings

        المسؤول عن:

        حفظ التعديلات.

        Flow:

        ```
        Cubit

        ↓

        UpdateReadingSettings

        ↓

        Repository
        ```

        ---

        # Data Layer

        مسؤولة عن تنفيذ التفاصيل.

        ---

        # ReadingSettingsModel

        يمثل البيانات في التخزين.

        مثال:

        ```
        ReadingSettingsModel

        font_size

        keep_screen_awake

        screen_reader_enabled
        ```

        وظيفته:

        تحويل:

        ```
        Hive Data
              ↓
        Model
              ↓
        Entity
        ```

        ---

        # Local Data Source

        ## ReadingSettingsLocalDataSource

        مسؤول عن التعامل مع Hive فقط.

        مثال:

        ```
        getSettings()

        saveSettings()
        ```

        لا يعرف:

        - UI.
        - Cubit.
        - Business Rules.

        ---

        # Repository Implementation

        ## ReadingSettingsRepositoryImpl

        يربط بين:

        ```
        Domain
          ↑
          |
        Repository Impl
          |
          ↓
        Data Source
        ```

        مسؤول عن:

        - استدعاء Data Source.
        - تحويل Model إلى Entity.
        - معالجة الأخطاء.

        ---

        # 4) Data Flow

        ## فتح صفحة الأذكار

        ```
        User opens Azkar

                ↓

        ReadingSettingsCubit

                ↓

        GetReadingSettingsUseCase

                ↓

        Repository Interface

                ↓

        Repository Implementation

                ↓

        Hive Data Source

                ↓

        Reading Settings

                ↓

        Cubit State

                ↓

        UI Updated
        ```

        ---

        # 5) Changing Font Size Flow

        مهم: لا نحفظ كل حركة Slider.

        مثال:

        المستخدم يحرك:

        ```
        14 → 15 → 16 → 17 → 18
        ```

        لا نريد:

        ```
        Hive Save
        Hive Save
        Hive Save
        Hive Save
        Hive Save
        ```

        الأفضل:

        ```
        Slider Change

                ↓

        Cubit updates state

                ↓

        UI Preview changes

                ↓

        User finishes selection

                ↓

        UpdateReadingSettings

                ↓

        Hive Save
        ```

        ---

        # 6) Interfaces

        نحتاج:

        ```
        abstract class ReadingSettingsRepository
        ```

        السبب:

        تقليل الاعتماد على طريقة التخزين.

        اليوم:

        ```
        Hive
        ```

        مستقبلًا:

        ```
        SQLite

        Shared Preferences

        Cloud Sync
        ```

        بدون تغيير الـ Domain.

        ---

        # 7) Dependency Direction

        القاعدة:

        ```
                      Presentation
                           |
                           ↓
                        Domain
                           ↑
                           |
                         Data
        ```

        يعني:

        ## Presentation

        يعتمد على:

        ```
        Domain
        ```

        ---

        ## Data

        يعتمد على:

        ```
        Domain
        ```

        ---

        ## Domain

        لا يعتمد على:

        ```
        Flutter
        Hive
        Cubit
        ```

        ---

        # 8) Accessibility Decision

        مهم:

        التطبيق لا يقوم بتشغيل Screen Reader.

        النظام هو المسؤول عن:

        - TalkBack في Android.
        - VoiceOver في iOS.

        دور التطبيق:

        - توفير Semantics صحيحة.
        - وصف الأزرار.
        - وصف حالة Toggle.
        - جعل النص قابلًا للقراءة.

        ---

        # Final Architecture

        ```
        Azkar Feature

                Presentation
                      |
                      ↓
                  Domain
                      ↑
                      |
                    Data

        Presentation:
        - Cubit
        - States
        - Reading Settings View

        Domain:
        - Entity
        - UseCases
        - Repository Contract

        Data:
        - Hive
        - Model
        - Repository Implementation
        ```

        ---

        ## قرارات F03 النهائية

        ✅ Reading Experience داخل Azkar Feature

        ✅ استخدام Clean Architecture

        ✅ Hive في Data Layer فقط

        ✅ Repository Interface في Domain

        ✅ Bottom Sheet داخل View

        ✅ Sections منفصلة داخل Reading Settings View

        ✅ عدم حفظ كل حركة Slider

        ✅ Screen Reader = Accessibility Support وليس تشغيل القارئ نفسه

    - [F04 — Database / API Design](#f04--database--api-design)

        # F04 — Database / API Design

        # Feature: Reading Experience

        ---

        # 1) Data Strategy Decision

        ## Overview

        Feature **Reading Experience** لا تحتاج إلى Backend API.

        السبب:

        الـ Feature مسؤولة عن:

        - User Reading Preferences.
        - Device Reading Behavior.
        - Local User Customization.

        ولا تحتوي على:

        - Shared Data.
        - User Account Data.
        - Cloud Data.
        - Synchronization.

        لذلك التصميم:

        ```
        Local First Design
        ```

        ---

        # 2) API Design

        ## API Requirement

        لا يوجد API في هذه النسخة.

        ```
        API = Not Required
        ```

        ---

        ## Why No API?

        لأن البيانات:

        ```
        Reading Settings

                |
                ↓

        User Device Preference
        ```

        وليست:

        ```
        Server Data
        ```

        مثال:

        ```
        fontSize = 20

        keepScreenAwake = true

        screenReaderEnabled = false
        ```

        هذه إعدادات خاصة بالجهاز والمستخدم.

        ---

        # 3) API Contracts

        ## Endpoints

        لا يوجد:

        ```
        GET /reading-settings

        POST /reading-settings

        PUT /reading-settings
        ```

        ---

        ## Future Consideration

        لا يوجد Cloud Sync في الخطة الحالية.

        لذلك لا يتم إنشاء:

        - Remote Data Source.
        - DTO Layer.
        - Sync Service.
        - API Client.

        ---

        # 4) Storage Decision

        ## Local Storage

        نستخدم:

        ```
        Hive
        ```

        لأنه مناسب لـ:

        - User Preferences.
        - Small Local Data.
        - Fast Read/Write.
        - Offline Usage.

        ---

        # Storage Structure

        نستخدم Box واحد:

        ```
        Hive

        reading_settings_box

                |
                ↓

        ReadingSettingsModel
        ```

        ---

        # 5) Data Model Design

        ## ReadingSettingsModel

        ## Responsibility

        يمثل البيانات كما يتم تخزينها داخل Hive.

        مكانه:

        ```
        data/
         └── models/
              └── reading_settings_model.dart
        ```

        ---

        ## Model Structure

        ```dart
        ReadingSettingsModel

        - fontSize
        - keepScreenAwake
        - screenReaderEnabled
        ```

        ---

        ## Hive Schema

        ```dart
        @HiveType(typeId: 1)
        class ReadingSettingsModel {

         @HiveField(0)
         final double fontSize;

         @HiveField(1)
         final bool keepScreenAwake;

         @HiveField(2)
         final bool screenReaderEnabled;

        }
        ```

        ---

        # Stored Data Example

        داخل Hive:

        ```json
        {
         "fontSize": 20,
         "keepScreenAwake": true,
         "screenReaderEnabled": false
        }
        ```

        ---

        # 6) Domain Entity Design

        ## ReadingSettings Entity

        المكان:

        ```
        domain/
         └── entities/
              └── reading_settings.dart
        ```

        ---

        ## Responsibility

        يمثل مفهوم إعدادات القراءة داخل الـ Business Layer.

        ولا يعرف:

        - Hive.
        - Flutter.
        - Storage.

        ---

        ## Entity Structure

        ```dart
        ReadingSettings

        - fontSize
        - keepScreenAwake
        - screenReaderEnabled
        ```

        ---

        ## Example

        ```dart
        ReadingSettings(
         fontSize: 20,
         keepScreenAwake: true,
         screenReaderEnabled: false,
        )
        ```

        ---

        # 7) Model ↔ Entity Mapping

        ## Direction

        ```
        Hive Data

            ↓

        ReadingSettingsModel

            ↓

        ReadingSettings Entity

            ↓

        Business Logic
        ```

        ---

        ## Why Separate Model and Entity?

        لأن:

        Model مسؤول عن:

        ```
        Storage Representation
        ```

        Entity مسؤول عن:

        ```
        Business Representation
        ```

        إذا تغير Hive structure:

        مثلاً:

        ```
        font_size

        بدل

        fontSize
        ```

        لن يتأثر Domain.

        ---

        # 8) Repository Interface

        المكان:

        ```
        domain/

         └── repositories/

              └── reading_settings_repository.dart
        ```

        ---

        ## Responsibility

        تعريف العمليات المطلوبة بدون معرفة مصدر البيانات.

        لا يعرف:

        - Hive.
        - Shared Preferences.
        - Database.

        ---

        ## Contract

        ```dart
        abstract class ReadingSettingsRepository {

         Future<Either<Failure, ReadingSettings>>
         getReadingSettings();

         Future<Either<Failure, void>>
         updateReadingSettings(
            ReadingSettings settings
         );

        }
        ```

        ---

        # 9) Local Data Source Contract

        المكان:

        ```
        data/

         └── datasources/

              └── reading_settings_local_datasource.dart
        ```

        ---

        ## Responsibility

        التعامل مع Hive فقط.

        ---

        ## Contract

        ```dart
        abstract class ReadingSettingsLocalDataSource {

         Future<ReadingSettingsModel?>
         getSettings();

         Future<void> saveSettings(
            ReadingSettingsModel settings
         );

        }
        ```

        ---

        # 10) Repository Implementation Flow

        المكان:

        ```
        data/

         └── repositories/

              └── reading_settings_repository_impl.dart
        ```

        ---

        ## Responsibility

        يربط:

        ```
        Domain

           ↑

        Repository Implementation

           ↓

        Data Source
        ```

        ---

        ## Success Flow

        ```
        Cubit

         ↓

        UseCase

         ↓

        Repository Interface

         ↓

        Repository Implementation

         ↓

        Local Data Source

         ↓

        Hive

         ↓

        Model

         ↓

        Entity
        ```

        ---

        # 11) Error Handling Design

        حتى مع Local Storage قد يحدث Error.

        مثال:

        - Hive corrupted data.
        - Serialization error.
        - Storage failure.

        ---

        # Data Layer Exceptions

        المكان:

        ```
        data/

         └── exceptions/
        ```

        ---

        ## CacheException

        مثال:

        ```dart
        class CacheException implements Exception {

         final String message;

         CacheException(this.message);

        }
        ```

        ---

        # Failure Layer

        المكان:

        ```
        domain/

         └── failures/
        ```

        ---

        ## CacheFailure

        ```dart
        class CacheFailure extends Failure {

         final String message;

        }
        ```

        ---

        # Error Mapping

        ```
        Hive Exception

                ↓

        CacheException

                ↓

        Repository

                ↓

        CacheFailure

                ↓

        Cubit

                ↓

        UI Error State
        ```

        ---

        # 12) Reading Settings Operations

        ## Get Settings

        Flow:

        ```
        User opens Azkar

                ↓

        Cubit

                ↓

        GetReadingSettingsUseCase

                ↓

        Repository

                ↓

        Hive

                ↓

        Return Settings

                ↓

        Update UI
        ```

        ---

        ## Update Settings

        Flow:

        ```
        User changes setting

                ↓

        Cubit State Update

                ↓

        UpdateReadingSettingsUseCase

                ↓

        Repository

                ↓

        Hive Save
        ```

        ---

        # 13) Special Decision — Keep Screen Awake

        ## Storage

        يتم حفظ القيمة:

        ```
        keepScreenAwake = true
        ```

        بشكل دائم.

        ---

        ## Runtime Behavior

        لكن التفعيل يحدث فقط داخل صفحة قراءة الأذكار.

        ```
        Enter Azkar Reading Screen

                ↓

        Read Preference

                ↓

        Enable Screen Awake

        Leave Screen

                ↓

        Disable Screen Awake

                ↓

        System Normal Behavior
        ```

        ---

        # 14) Complete Data Architecture

        ```
                        Presentation

                            |
                            ↓

                         Domain

                            ↑

                            |

                          Data

        Presentation:

        - Cubit
        - States
        - UI

        Domain:

        - Entity
        - UseCases
        - Repository Contract
        - Failures

        Data:

        - Hive
        - Model
        - Local Data Source
        - Repository Implementation
        - Exceptions
        ```

        ---

        # 15) Final F04 Decisions

        ✅ No API required

        ✅ No Remote Data Source

        ✅ No DTO Layer

        ✅ Hive Local Storage

        ✅ ReadingSettingsModel for persistence

        ✅ ReadingSettings Entity for business logic

        ✅ Repository abstraction

        ✅ Local Data Source abstraction

        ✅ Exception → Failure mapping

        ✅ Keep Screen Awake saved permanently

        ✅ Keep Screen Awake behavior limited to Azkar Reading Session

        ---

        # F04 Status

        ✅ Completed

    </aside>