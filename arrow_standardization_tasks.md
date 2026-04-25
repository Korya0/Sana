# خطة توحيد أيقونات الأسهم (Arrow Standardization Plan)

توضح هذه الوثيقة خطوات استبدال جميع أيقونات الأسهم المختلفة بـ Widget الموحد `AppArrowIcon`. هذا يضمن تناسق التصميم وتجنب مشاكل Shorebird Patches.

## المهام (Tasks)

### المرحلة 1: المميزات الأساسية (Prayer & Home)
- [ ] تحديث `lib/features/prayer/presentation/widgets/prayer_card_content.dart` (altArrowLeft)
- [ ] تحديث `lib/features/prayer/presentation/widgets/prayer_settings/settings_tile_widget.dart` (altArrowLeft)
- [ ] تحديث `lib/features/home/presentation/widgets/sections/home_settings_section.dart` (altArrowLeft & keyboard_arrow_down)
- [ ] تحديث `lib/features/home/presentation/widgets/sections/home_quran_card_section.dart` (arrowRight)

### المرحلة 2: أقسام المحتوى (Azkar & Teaching Prayer)
- [ ] تحديث `lib/features/azkar/presentation/views/all_azkar_categories_view.dart` (altArrowLeft)
- [ ] تحديث `lib/features/teaching_prayer/presentation/widgets/teaching_section_card.dart` (keyboard_arrow_down)
- [ ] تحديث `lib/features/teaching_prayer/presentation/widgets/teaching_topic_card.dart` (keyboard_arrow_up & down)

### المرحلة 3: المكونات المشتركة (Common Components)
- [ ] تحديث `lib/core/common/buttons/custom_arrow_back_button.dart` (altArrowRight)

---

## جدول الاستبدال التفصيلي (Replacement Table)

| المسار (Path) | الأيقونة الحالية | البديل المقترح |
| :--- | :--- | :--- |
| `prayer_card_content.dart` | `altArrowLeft` | `AppArrowIcon(direction: AppArrowDirection.left)` |
| `settings_tile_widget.dart` | `altArrowLeft` | `AppArrowIcon(direction: AppArrowDirection.left)` |
| `home_settings_section.dart` | `altArrowLeft` | `AppArrowIcon(direction: AppArrowDirection.left)` |
| `home_settings_section.dart` | `keyboard_arrow_down` | `AppArrowIcon(direction: AppArrowDirection.down)` |
| `all_azkar_categories_view.dart` | `altArrowLeft` | `AppArrowIcon(direction: AppArrowDirection.left)` |
| `custom_arrow_back_button.dart` | `altArrowRight` | `AppArrowIcon(direction: AppArrowDirection.right)` |
| `home_quran_card_section.dart` | `arrowRight` | `AppArrowIcon(direction: AppArrowDirection.right)` |
| `teaching_section_card.dart` | `keyboard_arrow_down` | `AppArrowIcon(direction: AppArrowDirection.down)` |
| `teaching_topic_card.dart` | `keyboard_arrow_up` | `AppArrowIcon(direction: AppArrowDirection.up)` |
| `teaching_topic_card.dart` | `keyboard_arrow_down` | `AppArrowIcon(direction: AppArrowDirection.down)` |

## ملاحظات هامة:
* يجب إضافة `import 'package:sana/core/common/widgets/app_arrow_icon.dart';` في كل ملف.
* التأكد من تمرير الـ `size` والـ `color` المناسبين لكل أيقونة لضمان عدم تغير الشكل.
