# 🔄 App Update Feature (نظام تحديث التطبيق)

هذا الموديول مسؤول عن التحقق من وجود تحديثات جديدة للتطبيق عبر **Firebase Remote Config** وإجبار المستخدم على التحديث في حال وجود إصدار حرج أو عرض بنر اختياري.

## 🛠️ كيف تعمل الميزة؟

1.  **عند التشغيل**: يقوم الـ `AppUpdateCubit` بجلب الإعدادات من الكاش (SharedPrefs) لسرعة العرض.
2.  **خلف الكواليس**: يتم جلب القيم الجديدة من Firebase Remote Config وتحديث الكاش.
3.  **المقارنة**: تتم مقارنة رقم الإصدار الحالي (`pubspec.yaml`) بالرقم الموجود في Firebase.
4.  **العرض**: 
    *   إذا كان `is_force_update` = `true`: يظهر قفل كامل للشاشة (**Force Update**).
    *   إذا كان `is_force_update` = `false`: يظهر بنر صغير في أعلى التطبيق (**Optional Update**).

---

## ⚙️ التحكم عبر Firebase (Remote Config Keys)

لكي تتحكم في التحديث، استخدم المفاتيح التالية في لوحة تحكم Firebase:

| المفتاح (Key) | النوع | الوصف | مثال |
| :--- | :--- | :--- | :--- |
| `latest_version` | String | رقم أحدث إصدار متاح على المتجر | `1.1.0` |
| `is_force_update` | Boolean | تفعيل التحديث الإجباري (قفل التطبيق) | `true` |
| `update_url` | String | رابط صفحة التحميل | `https://play.google.com/...` |
| `update_message` | String | الرسالة التي ستظهر للمستخدم في شاشة التحديث | `نوصي بالتحديث للحصول على أداء أفضل.` |

---

## 📂 هيكل الملفات (Clean Architecture)

-   `data/models/app_update_config_keys.dart`: يحتوي على الثوابت (Keys) لضمان عدم الخطأ في الكتابة.
-   `data/services/app_update_service.dart`: التعامل المباشر مع Firebase و SharedPreferences.
-   `presentation/controller/`: إدارة الحالة (Cubit) ومنطق المقارنة بين النسخ.
-   `presentation/widgets/`: واجهات التحديث (Overlay, Banner, Icons).

---

## 📝 ملاحظات للمطور
*   **Web Support**: الميزة معطلة تلقائياً في نسخة الويب لأن التحديث يتم تلقائياً عند إعادة التحميل.
*   **Testing**: لاختبار الميزة برمجياً، قم بتغيير رقم النسخة في `AppUpdateState` يدوياً أو ارفع رقم النسخة في Firebase Remote Config.
