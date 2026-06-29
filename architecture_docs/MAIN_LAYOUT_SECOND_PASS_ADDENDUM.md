# ملحق جولة ثانية — مخالفات main_layout
**يُكمل: MAIN_LAYOUT_VIOLATIONS.md**

---

## 🔍 ملخص ما تم اكتشافه في الجولة الثانية لـ `main_layout`

| # | المخالفة | التصنيف | الخطورة |
|---|----------|---------|---------|
| ML1 | **ثبات شكل الأيقونة النشطة وغير النشطة (Static Bold Icons for all states)** | UI/Aesthetics 🔴 | متوسط |

---

## 🔍 التفاصيل الفنية للمخالفة الإضافية

### 🔴 مخالفة ML1 — UI: ثبات شكل الأيقونات المحددة وغير المحددة
**الملف:** [main_layout_view.dart](file:///d:/flutter/flutter_Projects/muslim_app/lib/features/main_layout/presentation/views/main_layout_view.dart#L57-L90)

```dart
BottomNavigationBarItem(
  icon: Padding(
    padding: EdgeInsets.only(bottom: 4),
    child: Icon(SolarIconsBold.home),
  ),
  activeIcon: Padding(
    padding: EdgeInsets.only(bottom: 4),
    child: Icon(SolarIconsBold.home), // ⚠️ نفس الأيقونة الممتلئة!
  ),
  label: AppStrings.home,
),
```

**المشكلة:** في جميع التبويبات، يتم استخدام نفس الأيقونات الممتلئة (`SolarIconsBold`) للتمثيل البصري في الحالتين النشطة وغير النشطة. في واجهات المستخدم الفاخرة والممتازة (Premium UI)، يجب تغيير نمط الأيقونة غير النشطة لتكون مفرغة (`Outline`) لتنبيه المستخدم بالفرق ولتحسين المظهر البصري العام للتطبيق.

**الحل:**
استبدال الأيقونات غير النشطة بـ `SolarIconsOutline` وحذف الـ `activeIcon` المكرر لجعل الأيقونة النشطة `SolarIconsBold` تلقائياً:
```dart
BottomNavigationBarItem(
  icon: Icon(SolarIconsOutline.home), // مفرغ للحالة العادية
  activeIcon: Icon(SolarIconsBold.home), // ممتلئ للحالة النشطة
  label: AppStrings.home,
)
```
