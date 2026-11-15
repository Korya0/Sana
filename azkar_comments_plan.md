# خطة تطبيق قواعد التعليقات (Comments) على ميزة الأذكار بالكامل

> **النطاق:** `lib/features/azkar/**` (كل ملفات `.dart` بدون استثناء، وكل جزء داخل كل ملف).
> **مرجع القواعد:** `docs/architecture/03_code_conventions.md` — قسم **Comments**.
> **مبدأ التنفيذ:** تعديل/إضافة/حذف التعليقات فقط بما يحقق القواعد دون تغيير منطق الكود، مع مراجعة كل ملف يدويًا (لا يُترك ملف أو جزء).

---

## 1) القواعد المطلوب تطبيقها (ملخص دقيق)

1. **تعليقات قصيرة جدًا ومتسقة:** تسمية أو 1–4 كلمات.
2. **لا تعليقات فوق إعلانات الأصناف (class declarations) بما فيها أصناف `View`.**
   - يُزال أي `//` أو `///` مباشرة فوق `class`/`mixin`/`enum`/`extension`/`typedef` (وأيضًا فوق الأصناف المتداخلة إن وُجدت).
3. **في أشجار واجهة المستخدم (UI trees):** تسمية `Header` و`Body` والأقسام الرئيسية.
4. **في الويدجتس:** تعليقات هرمية لتحديد الويدجت ومحتوياته الرئيسية عند الإفادة، مثل:
   - `// Info (title + subtitle + price)` ثم `// Title`, `// Subtitle`, `// Price` للعناصر المتداخلة عند الحاجة.
5. **في data و domain:** تعليق قصير يوضح الغرض **فوق كل دالة/ميثود**.
   - يشمل: الدوال المجردة في العقود (interfaces/abstract repositories & data sources)، التنفيذات، دوال التحويل (`fromJson`, `toJson`, `fromEntity`, `toEntity`)، الدوال المساعدة الخاصة، `call` في use cases، المصانع (`factory`) وأي دوال/منشئات ذات منطق تستفيد من توضيح الغرض (يُراعى الإيجاز والاتساق).
6. **التعليقات الأطول مسموحة فقط** عند الضرورة لشرح سلوك معقّد أو قرار غير بديهي.
7. **ممنوع:** اللافتات، الفواصل، الكتل الزخرفية، أو التعليقات التي تعيد صياغة الكود حرفيًا.

> **ملاحظة:** لا تُضاف تعليقات لمجرّد الملء. الهدف وضوح/اتساق حسب القواعد.

---

## 2) منهجية العمل (لكل ملف)

لكل ملف في القائمة (القسم 4):
1. **مسح عام:** إزالة لافتات/فواصل/زخارف وتعليقات مُعادة للصياغة.
2. **الأصناف:** التأكد من عدم وجود تعليق فوق أي إعلان صنف.
3. **حسب الطبقة:**
   - **Data/Domain:** التأكد من وجود تعليق غرض قصير (1–4 كلمات أو تسمية غرض مختصرة متسقة) فوق **كل** ميثود/دالة، وتنقيح التعليقات الحالية لتتوافق مع القاعدة (قصيرة، غير مُعادة للكود).
   - **Presentation (Views/Widgets):** داخل `build` وأي شجرة ويدجت: تسمية `Header`, `Body`, والأقسام الرئيسية؛ إضافة تعليقات هرمية للمكوّنات ومحتوياتها الرئيسية عند الإفادة. مراجعة الدوال المساعدة الخاصة بالعرض (إن وُجدت) واستخدام تعليقات ضرورية فقط للسلوك غير البديهي.
   - **Cubits/States/Extensions:** تطبيق قواعد العموم (لا تعليق فوق صنف، لا تزيين). تعليقات الدوال تتبع ما يلائم (دوال منطقية/تحميل/حفظ/تحويل تستفيد من تعليق غرض قصير؛ مع الحفاظ على الإيجاز وعدم إعادة صياغة الكود).
4. **مراجعة نهائية للملف:** التأكد من تغطية كل جزء (حقول/منشئات/دوال/أقسام UI/الفروع المهمة) وفق القواعد.

---

## 3) ترتيب التنفيذ المقترح (على دفعات قابلة للمراجعة)

1. **Data — constants, models, data sources, repositories** (عقود + تنفيذ + تحويل/تخزين).
2. **Domain — entities, repositories, use cases** (كيانات وعقود وحالات استخدام).
3. **Presentation — cubits/states/extensions**.
4. **Presentation — views** (أكبر تأثير على Header/Body/الأقسام).
5. **Presentation — widgets** (شاشات فرعية، قوائم، بطاقات، شيتات، إعدادات القراءة…).
6. **مراجعة شاملة:** إعادة مسح كل الملفات للتأكد من عدم بقاء أي مخالفة أو جزء غير مغطّى.

> يمكن تنفيذ كل دفعة ثم تشغيل `dart format` و`flutter analyze` (والاختبارات عند الحاجة) لضمان عدم كسر الكود.

---

## 4) جرد كامل للملفات وإجراءات التطبيق (لا يُستثنى أي ملف)

### 4.1 Data (11 ملف)

| # | الملف | نوع/دور | إجراءات مطلوبة (تُطبّق على كامل الملف) |
|---|---|---|---|
| 1 | `lib/features/azkar/data/constants/azkar_constants.dart` | ثوابت/مفاتيح | لا أصناف؛ مراجعة التعليقات الحالية (تسميات أقسام قصيرة) للتوافق مع القاعدة (قصيرة، غير زخرفية، غير مُعادة للكود). |
| 2 | `lib/features/azkar/data/data_sources/azkar_local_data_source.dart` | عقد DataSource | لا تعليق فوق الصنف؛ تعليق غرض قصير فوق **كل** دالة مجردة. |
| 3 | `lib/features/azkar/data/data_sources/azkar_local_data_source_impl.dart` | تنفيذ DataSource | لا تعليق فوق الصنف؛ تعليق غرض قصير فوق المنشئ (إن لزم) و**كل** دالة/override؛ إزالة أي إعادة صياغة. |
| 4 | `lib/features/azkar/data/data_sources/custom_azkar_local_data_source.dart` | عقد DataSource | لا تعليق فوق الصنف؛ تعليق غرض قصير فوق **كل** دالة مجردة. |
| 5 | `lib/features/azkar/data/data_sources/custom_azkar_local_data_source_impl.dart` | تنفيذ DataSource (تخزين/كاش/طابور/نسخ احتياطي) | لا تعليق فوق الصنف؛ تعليق غرض قصير فوق **كل** دالة (عامة وخاصة)؛ الإبقاء فقط على التعليقات الطويلة الضرورية لسلوك/قرار غير بديهي (إن وُجدت) بصياغة مبررة. |
| 6 | `lib/features/azkar/data/models/azkar_category_model.dart` | Model | لا تعليق فوق الصنف؛ تعليق غرض قصير فوق المنشئ/المصانع/`fromJson`/`toEntity` وأي دوال أخرى. |
| 7 | `lib/features/azkar/data/models/custom_category_model.dart` | Model | لا تعليق فوق الصنف؛ تعليق غرض قصير فوق **كل** دالة/مصنع/تحويل. |
| 8 | `lib/features/azkar/data/models/zikr_model.dart` | Model | لا تعليق فوق الصنف؛ تعليق غرض قصير فوق **كل** دالة/مصنع/تحويل. |
| 9 | `lib/features/azkar/data/repositories/azkar_repository_impl.dart` | Repository Impl | لا تعليق فوق الصنف؛ تعليق غرض قصير فوق المنشئ (إن لزم) و**كل** دالة. |
| 10 | `lib/features/azkar/data/repositories/custom_azkar_repository_impl.dart` | Repository Impl | لا تعليق فوق الصنف؛ تعليق غرض قصير فوق **كل** دالة. |
| 11 | `lib/features/azkar/data/repositories/reading_settings_repository_impl.dart` | Repository Impl | لا تعليق فوق الصنف؛ تعليق غرض قصير فوق **كل** دالة. |

### 4.2 Domain (15 ملف)

| # | الملف | نوع/دور | إجراءات مطلوبة (تُطبّق على كامل الملف) |
|---|---|---|---|
| 12 | `lib/features/azkar/domain/entities/azkar_category_entity.dart` | Entity | لا تعليق فوق الصنف؛ مراجعة/إضافة تعليقات غرض قصيرة للدوال/المنشئات المهمة (مثل `copyWith`) مع الإيجاز. |
| 13 | `lib/features/azkar/domain/entities/azkar_category_type.dart` | Enum/Entity مساعد | لا تعليق فوق الصنف؛ تعليق غرض قصير لكل دالة/عضو دالي (مثل `fromKey`) وأي منطق مرافق؛ الحفاظ على وضوح القيم دون تعليقات مُعادِة. |
| 14 | `lib/features/azkar/domain/entities/custom_category_entity.dart` | Entity | لا تعليق فوق الصنف؛ تعليقات غرض قصيرة للدوال/التحويلات (`toCategoryEntity`, `copyWith`… إلخ). |
| 15 | `lib/features/azkar/domain/entities/reading_settings_entity.dart` | Entity | لا تعليق فوق الصنف؛ تعليقات غرض قصيرة للدوال (مثل clamp/copy/مصانع إن وجدت). |
| 16 | `lib/features/azkar/domain/entities/zikr_entity.dart` | Entity | لا تعليق فوق الصنف؛ تعليقات غرض قصيرة للدوال/الخصائص المحسوبة الدالية إن وُجدت و`copyWith`/المساواة إن كانت دوال. |
| 17 | `lib/features/azkar/domain/repositories/azkar_repository.dart` | عقد Repository | لا تعليق فوق الصنف؛ تعليق غرض قصير فوق **كل** دالة مجردة. |
| 18 | `lib/features/azkar/domain/repositories/custom_azkar_repository.dart` | عقد Repository | لا تعليق فوق الصنف؛ تعليق غرض قصير فوق **كل** دالة مجردة. |
| 19 | `lib/features/azkar/domain/repositories/reading_settings_repository.dart` | عقد Repository | لا تعليق فوق الصنف؛ تعليق غرض قصير فوق **كل** دالة مجردة. |
| 20 | `lib/features/azkar/domain/use_cases/delete_custom_category_use_case.dart` | UseCase | لا تعليق فوق الصنف؛ تعليق غرض قصير فوق المنشئ (إن لزم) و`call`/الدوال. |
| 21 | `lib/features/azkar/domain/use_cases/get_azkar_by_category_use_case.dart` | UseCase | نفس ما سبق لكل دالة. |
| 22 | `lib/features/azkar/domain/use_cases/get_azkar_categories_use_case.dart` | UseCase | نفس ما سبق لكل دالة. |
| 23 | `lib/features/azkar/domain/use_cases/get_custom_categories_use_case.dart` | UseCase | نفس ما سبق لكل دالة. |
| 24 | `lib/features/azkar/domain/use_cases/get_reading_settings_use_case.dart` | UseCase | نفس ما سبق لكل دالة. |
| 25 | `lib/features/azkar/domain/use_cases/save_custom_category_use_case.dart` | UseCase | نفس ما سبق لكل دالة. |
| 26 | `lib/features/azkar/domain/use_cases/update_reading_settings_use_case.dart` | UseCase | نفس ما سبق لكل دالة. |

### 4.3 Presentation — Cubits, States, Extensions (10 ملفات)

| # | الملف | نوع/دور | إجراءات مطلوبة (تُطبّق على كامل الملف) |
|---|---|---|---|
| 27 | `lib/features/azkar/presentation/cubits/azkar/azkar_cubit.dart` | Cubit | لا تعليق فوق الصنف؛ تعليقات غرض قصيرة فوق الدوال العامة/الخاصة (تحميل، زيادة، إعادة ضبط، تطبيق تحديث، حذف/استعادة، حل عنوان… إلخ)؛ تعليقات أطول فقط للسلوك غير البديهي إن لزم. |
| 28 | `lib/features/azkar/presentation/cubits/azkar/azkar_state.dart` | States | لا تعليق فوق أي صنف حالة؛ تعليقات غرض قصيرة للدوال/المحسوبات الدالية المهمة (مثل `isAllCompleted`, `hasStarted`, `firstIncompleteIndex`, `copyWith`) مع الإيجاز. |
| 29 | `lib/features/azkar/presentation/cubits/azkar/zikr_increment_result.dart` | نتيجة/نوع | لا تعليق فوق الصنف/القيم؛ تعليقات فقط عند ضرورة غير بديهية. |
| 30 | `lib/features/azkar/presentation/cubits/categories/azkar_categories_cubit.dart` | Cubit | لا تعليق فوق الصنف؛ تعليق غرض قصير فوق **كل** دالة. |
| 31 | `lib/features/azkar/presentation/cubits/categories/azkar_categories_state.dart` | States | لا تعليق فوق الأصناف؛ تعليقات غرض قصيرة للدوال إن وُجدت. |
| 32 | `lib/features/azkar/presentation/cubits/custom_azkar/custom_azkar_cubit.dart` | Cubit | لا تعليق فوق الصنف؛ تعليق غرض قصير فوق **كل** دالة (تحميل/حفظ/حذف/تطبيع…). |
| 33 | `lib/features/azkar/presentation/cubits/custom_azkar/custom_azkar_state.dart` | States | لا تعليق فوق الأصناف؛ تعليقات غرض قصيرة للدوال إن وُجدت. |
| 34 | `lib/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart` | Cubit | لا تعليق فوق الصنف؛ تعليق غرض قصير فوق **كل** دالة. |
| 35 | `lib/features/azkar/presentation/cubits/reading_settings/reading_settings_state.dart` | States | لا تعليق فوق الأصناف؛ تعليقات غرض قصيرة للدوال إن وُجدت. |
| 36 | `lib/features/azkar/presentation/extensions/azkar_category_type_icon.dart` | Extension | لا تعليق فوق الامتداد؛ تعليق غرض قصير للأعضاء الدالية (getter/دوال) إن وُجدت. |

### 4.4 Presentation — Views (4 ملفات)

| # | الملف | إجراءات مطلوبة (تُطبّق على كامل الملف) |
|---|---|---|
| 37 | `lib/features/azkar/presentation/views/azkar_tasbeeh_home_view.dart` | لا تعليق فوق `View`؛ في `build`: تسمية `Header`/`Body` والأقسام الرئيسية؛ تعليقات هرمية للأقسام/المحتويات عند الإفادة؛ مراجعة كل دوال المساعدة (فتح خيارات/إعدادات…) — تعليقات غرض قصيرة متسقة حيث مناسب دون مخالفة القواعد. |
| 38 | `lib/features/azkar/presentation/views/custom_azkar_list_view.dart` | لا تعليق فوق `View`؛ تسمية `Header`/`Body`/الأقسام الرئيسية في شجرة الواجهة؛ تغطية حالات العرض (تحميل/فارغ/خطأ/قائمة) بتسميات واضحة. |
| 39 | `lib/features/azkar/presentation/views/custom_zikr_form_view.dart` | لا تعليق فوق `View`؛ `Header`/`Body`/أقسام النموذج الرئيسية (حقول، قائمة العناصر، إجراءات، FAB…)؛ تعليقات هرمية للمكوّنات المركبة؛ مراجعة جميع دوال المنطق/المساعدة في الملف. |
| 40 | `lib/features/azkar/presentation/views/zikr_list_view.dart` | لا تعليق فوق `View`؛ `Header`/`Body`/أقسام القراءة (شريط، قائمة، حالات، تفاعل/تمرير/إكمال)؛ تغطية أجزاء السلوك المعقد بتعليقات ضرورية فقط عند اللزوم. |

### 4.5 Presentation — Widgets (26 ملف)

> لكل ملف: لا تعليق فوق إعلان الصنف؛ في `build` تسمية الأقسام الرئيسية (وHeader/Body عند وجودهما) + تعليقات هرمية للمكوّن ومحتوياته الرئيسية عند الإفادة؛ تغطية كل جزء من الشجرة.

| # | الملف | ملاحظات تركيز |
|---|---|---|
| 41 | `lib/features/azkar/presentation/widgets/azkar_categories/azkar_categories_grid.dart` | شبكة/عناصر/حالات؛ أقسام رئيسية وإجراءات. |
| 42 | `lib/features/azkar/presentation/widgets/azkar_categories/azkar_categories_skeleton.dart` | هيكل التحميل؛ أقسام رئيسية. |
| 43 | `lib/features/azkar/presentation/widgets/azkar_categories/azkar_category_actions_bottom_sheet.dart` | شيت إجراءات؛ عنوان/خيارات/أقسام. |
| 44 | `lib/features/azkar/presentation/widgets/azkar_categories/azkar_category_card.dart` | بطاقة؛ تعليقات هرمية (سطح/محتوى، أيقونة، عنوان…) مع الحفاظ على الضروري فقط. |
| 45 | `lib/features/azkar/presentation/widgets/azkar_section/azkar_home_options_bottom_sheet.dart` | شيت خيارات؛ أقسام/عناصر. |
| 46 | `lib/features/azkar/presentation/widgets/azkar_section/azkar_section_widget.dart` | قسم رئيسي يضم الشبكة/الحالات. |
| 47 | `lib/features/azkar/presentation/widgets/common/azkar_option_section.dart` | قسم خيارات مشترك. |
| 48 | `lib/features/azkar/presentation/widgets/common/azkar_option_tile.dart` | عنصر خيار. |
| 49 | `lib/features/azkar/presentation/widgets/custom_azkar/add_zikr_bottom_sheet.dart` | شيت إضافة/تعديل ذكر؛ حقول/إجراءات. |
| 50 | `lib/features/azkar/presentation/widgets/custom_azkar/add_zikr_fab.dart` | زر عائم؛ محتوى بسيط. |
| 51 | `lib/features/azkar/presentation/widgets/custom_azkar/custom_azkar_category_list_tile.dart` | عنصر قائمة؛ محتويات (أيقونة/نص/إجراءات). |
| 52 | `lib/features/azkar/presentation/widgets/custom_azkar/custom_azkar_list_section.dart` | قسم قائمة + إجراءات. |
| 53 | `lib/features/azkar/presentation/widgets/custom_azkar/custom_zikr_form_item_tile.dart` | عنصر نموذج؛ محتوى/عداد/إجراءات/شارة. |
| 54 | `lib/features/azkar/presentation/widgets/reading_settings/font_size_section.dart` | قسم حجم الخط؛ معاينة/سلايدر/تسميات. |
| 55 | `lib/features/azkar/presentation/widgets/reading_settings/font_size_thumb_shape.dart` | شكل مخصص (رسام/شكل)؛ تعليقات ضرورية فقط للمنطق غير البديهي. |
| 56 | `lib/features/azkar/presentation/widgets/reading_settings/reading_settings_bottom_sheet.dart` | شيت إعدادات القراءة. |
| 57 | `lib/features/azkar/presentation/widgets/zikr_list/zikr_card/custom_zikr_badge.dart` | شارة. |
| 58 | `lib/features/azkar/presentation/widgets/zikr_list/zikr_card/edit_target_count_bottom_sheet.dart` | شيت تعديل الهدف؛ حقول/إجراءات. |
| 59 | `lib/features/azkar/presentation/widgets/zikr_list/zikr_card/rolling_number_text.dart` | حركة/رقم متدحرج؛ تعليقات ضرورية فقط للسلوك المعقد. |
| 60 | `lib/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_actions_row.dart` | صف إجراءات. |
| 61 | `lib/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_content.dart` | محتوى النص/الوصف. |
| 62 | `lib/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_counter.dart` | عداد/حلقة/حالة؛ تعليقات هرمية للأجزاء. |
| 63 | `lib/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_item_card.dart` | بطاقة كاملة؛ هيكل هرمي واضح (محتوى/فاصل/إجراءات/عداد/شارة…). |
| 64 | `lib/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_progress_ring.dart` | حلقة تقدم. |
| 65 | `lib/features/azkar/presentation/widgets/zikr_list/zikr_list_content.dart` | محتوى القائمة/الحالات. |
| 66 | `lib/features/azkar/presentation/widgets/zikr_list/zikr_list_skeleton.dart` | هيكل تحميل القائمة. |

---

## 5) قائمة تحقق خاصة (أثناء التنفيذ)

- [ ] لا يوجد أي تعليق مباشرة فوق أي `class`/`enum`/`mixin`/`extension`/`typedef` في أي ملف من الـ 66.
- [ ] كل دالة/ميثود في طبقتي `data` و`domain` (العقود والتنفيذات والنماذج والكيانات وحالات الاستخدام) يسبقها تعليق غرض قصير.
- [ ] كل `View` وكل ويدجت شاشة/قسم رئيسي يحتوي في شجرة `build` على تسميات `Header`/`Body` و/أو الأقسام الرئيسية المناسبة.
- [ ] الويدجتات المركبة تحتوي تعليقات هرمية للمحتويات الرئيسية عند الإفادة.
- [ ] لا لافتات/فواصل/كتل زخرفية ولا تعليقات تعيد صياغة الكود.
- [ ] التعليقات الطويلة (إن وُجدت) مبررة لسلوك/قرار غير بديهي فقط.
- [ ] تمت مراجعة **كل** ملف و**كل** جزء داخله (لا استثناءات).

---

## 6) التحقق بعد الانتهاء

1. `dart format lib/features/azkar`
2. `flutter analyze` (التأكد من عدم وجود مشاكل جديدة)
3. `flutter test` (اختبارات المشروع/الميزة ذات الصلة)
4. مراجعة diff للتأكد من أن التغييرات مقتصرة على التعليقات (مع أي تعديلات تنسيق ناتجة عن format فقط).

---

## 7) مخرجات التنفيذ المتوقعة

- تحديث تعليقات جميع ملفات `lib/features/azkar/**` (66 ملفًا) لتتوافق بالكامل مع قواعد `docs/architecture/03_code_conventions.md`.
- جاهزية الميزة لإغلاقها من ناحية معايير التعليقات دون ترك ملفات أو أجزاء.