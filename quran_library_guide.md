# دليل تخصيص مكتبة Quran Library (v3.2.0)

هذا الدليل مخصص لمساعدتك في تخصيص المكتبة بالكامل (الألوان، الأيقونات، والوصول للبيانات) بناءً على فحص كود المصدر الفعلي للمكتبة.

---   

## 1. الإعدادات العامة والتخصيص الأساسي
يتم التحكم في هذه المتغيرات مباشرة عند استدعاء `QuranLibraryScreen`.

### المتغيرات العامة (General)
- `isDark` (bool): تفعيل الوضع المظلم.
- `appLanguageCode` (String): لغة الأرقام (مثلاً 'ar' للأرقام العربية).
- `pageIndex` / `surahNumber`: تحديد نقطة البداية.

### الألوان الأساسية (Main Colors)
- `backgroundColor`: لون خلفية صفحة المصحف.
- `textColor`: لون نص القرآن الأساسي.
- `ayahIconColor`: لون أيقونة رقم الآية.
- `ayahSelectedBackgroundColor`: لون تظليل الآية عند الضغط عليها.
- `ayahSelectedFontColor`: لون الخط للآية المختارة.
- `bookmarksColor`: لون علامة الفاصل (Bookmark).

---

## 2. التحكم العميق في الألوان (Detailed Colors)
تستخدم المكتبة كائنات `Style` لتخصيص الأجزاء التفصيلية:

### ألوان شريط الصوت (`AyahAudioStyle` / `SurahAudioStyle`)
- `seekBarThumbColor`: لون دائرة التحكم في الوقت.
- `seekBarActiveTrackColor`: لون الجزء المكتمل من شريط التقدم.
- `seekBarInactiveTrackColor`: لون الجزء المتبقي.
- `dialogBackgroundColor`: خلفية نافذة اختيار القارئ.
- `dialogSelectedReaderColor`: لون القارئ المختار.
- `readerNameInItemColor`: لون اسم القارئ في القائمة.
- `timeContainerColor`: لون خلفية مربعات الوقت.

### ألوان قائمة الآية (عند الضغط المطول) (`AyahMenuStyle`)
- `backgroundColor`: خلفية القائمة المنبثقة.
- `borderColor` & `borderWidth`: لون وسمك إطار القائمة.
- `dividerColor`: لون الفواصل بين الأيقونات (النسخ، التفسير، إلخ).
- `copyIconColor` / `tafsirIconColor` / `playIconColor`: ألوان الأيقونات الفردية.

---

## 3. تخصيص الأيقونات والأشكال (Icons & Assets)
يمكنك استبدال أيقونات المكتبة بأيقونات مخصصة (Paths) أو تغيير شكلها:

### أيقونات الصوت
- `playIconPath` (String): مسار ملف الأيقونة (Asset) للتشغيل.
- `pauseIconPath` (String): مسار ملف الأيقونة للإيقاف.
- `playIconHeight` / `pauseIconHeight`: التحكم في حجم الأيقونة.

### أيقونات قائمة الآية
- `bookmarkIconData`: نوع الأيقونة للفاصل (مثلاً `Icons.bookmark`).
- `copyIconData`: أيقونة النسخ.
- `tafsirIconData`: أيقونة عرض التفسير.
- `playIconData`: أيقونة تشغيل الآية.
- `readerDropdownWidget`: يمكنك تمرير **Widget كامل** مخصص بدلاً من سهم القائمة المنسدلة.

---

## 4. الوصول الحقيقي للبيانات (Data Access)
إذا أردت عرض بيانات في واجهتك الخاصة (مثل "آية اليوم" أو "سورة معينة")، استخدم `QuranCtrl.instance`:

### الحصول على الآيات والسور
- `QuranCtrl.instance.state.allAyahs`: قائمة بجميع الآيات (6236 آية). كل آية تحتوي على:
    - `ayaText`: نص الآية بالتشكيل.
    - `ayaTextEmlaey`: نص الآية بدون تشكيل (للبحث).
    - `surahNumber`: رقم السورة.
    - `ayahNumber`: رقم الآية داخل السورة.
    - `page`: رقم الصفحة.
- `QuranCtrl.instance.surahs`: قائمة بجميع السور (114 سورة).

### دوال الوصول السريع
- `getAyahByUq(int uqNumber)`: الحصول على آية برقمها العالمي.
- `getSingleAyahByAyahAndSurahNumber(int ayah, int surah)`: الحصول على آية معينة بدقة.
- `getSurahNumberFromPage(int page)`: معرفة أي سورة في هذه الصفحة.
- `getJuzByPage(int page)`: معرفة الجزء الخاص بهذه الصفحة.

### الانتقال البرمجي
- `jumpToPage(int page)`: قفز مباشر لصفحة.
- `animateToPage(int page)`: انتقال انسيابي لصفحة.

---

## 5. الأدوات المساعدة (Utilities & Extensions)
توفر المكتبة `Extensions` مفيدة جداً:
- `int.toArabicNumbers`: تحويل `123` إلى `١٢٣`.
- `int.surahName`: تحويل رقم `1` إلى `الفاتحة`.
- `String.convertArabicNumbersToEnglish`: تحويل الأرقام العربية لنص إنجليزي.
- `String.normalizeText`: تطبيع النصوص (تحويل أ، إ، آ إلى ا) لتسهيل البحث.

---

## 6. أوضاع العرض المتوفرة
يمكنك التحكم في وضع العرض عبر `setDisplayMode`:
1. `QuranDisplayMode.defaultMode`: الوضع العادي (صفحة أو صفحتان حسب الشاشة).
2. `QuranDisplayMode.singleScrollable`: تمرير رأسي مستمر.
3. `QuranDisplayMode.quranWithTafsirSide`: قرآن مع التفسير بجانبه.
4. `QuranDisplayMode.ayahWithTafsirInline`: كل آية وتحتها تفسيرها.

---

## 7. أفكار إبداعية للتطوير (Creative Ideas)
يمكنك استغلال إمكانيات المكتبة لبناء ميزات احترافية:

### أ- نظام التحفيظ (Hifz Mode)
- **تكرار الآيات:** استخدم `playSingleAyahOnly` مع مستمع لحالة المشغل لإعادة الآية عدة مرات.
- **تحديد نطاق:** استخدم `isMultiSelectMode` للسماح للمستخدم بتحديد آيات معينة (مثلاً 1-5) وتكرار تشغيلها صوتياً كحلقة واحدة.
- **تسميع الكلمات:** استخدم `enableWordSelection` لعمل وضع اختبار حيث تختفي الكلمات عند الضغط عليها.

### ب- مساعد الختمة (Khatmah Assistant)
- **ختمات متعددة:** بما أنك تستطيع التحكم في الصفحة عبر `jumpToPage` و `lastPage` برمجياً، يمكنك إدارة أكثر من ختمة (ختمة تلاوة، ختمة تدبر، ختمة حفظ) وحفظ تقدم كل منها في قاعدة بياناتك.
- **خطة القراءة:** احسب عدد الصفحات المتبقية (604 - الصفحة الحالية) واقترح على المستخدم عدداً معيناً يومياً للختم في تاريخ محدد.

### ج- العلامات الذكية (Smart Tags)
- **تصنيف العلامات:** استخدم ألوان العلامات المرجعية الثلاثة لتصنيف الآيات (مثلاً: أحمر للآيات التي تحتاج مراجعة، أخضر للآيات المحفوظة، أصفر لآيات التدبر).

### د- آية اليوم (Daily Verse)
- **الوصول العشوائي:** اختر آية عشوائية من `QuranCtrl.instance.state.allAyahs` واعرضها في شاشة التطبيق الرئيسية (Widget) مع إمكانية الانتقال لها مباشرة في المصحف.

---
**ملاحظة:** جميع هذه الميزات تعتمد على البيانات الحقيقية التي يوفرها `QuranCtrl` و `AudioCtrl` بشكل لحظي.
