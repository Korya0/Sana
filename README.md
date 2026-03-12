<div align="center">

<img src="assets/images/app_logo.png" alt="سَـنَـا" width="180"/>

# سَـنَـا | Sana
### المفهوم العصري للتطبيقات الإسلامية

**تطبيق إسلامي رائد يدمج بين الفن الهندسي (Software Architecture) والجمال البصري، صُمم ليكون رفيقك الدائم في العبادة والذكر.**

---

<a href="https://sana0.vercel.app/">
  <img src="https://img.shields.io/badge/🌐 Website-D4AF37?style=for-the-badge" alt="Website"/>
</a>
<a href="https://play.google.com/store/apps/details?id=com.sana.muslim.app">
  <img src="https://img.shields.io/badge/📱_Google_Play-00C853?style=for-the-badge" alt="Google Play"/>
</a>
<a href="https://www.facebook.com/profile.php?id=61585568923187">
  <img src="https://img.shields.io/badge/📘 Facebook-1877F2?style=for-the-badge" alt="Facebook"/>
</a>

</div>

---

## 🌟 لماذا "سَـنَـا"؟

تتوفر العديد من التطبيقات الإسلامية، لكن "سنا" يأتي ليعالج فجوة الجمال والأداء. نحن نؤمن أن الأدوات التي نستخدمها للعبادة يجب أن تكون الأفضل تقنياً والأجمل بصرياً.

### 🕌 أهم المميزات:
- **نظام مواقيت متطور**: يعتمد على مكتبة `Adhan` العالمية مع تحديث تلقائي للموقع الجغرافي.
- **مصحف المدينة الرقمي**: قراءة بالرسم العثماني الأصيل مع دعم كامل للوضع الليلي المريح للعين.
- **محرك بحث للسنة**: ابحث في ملايين الأحاديث عبر تكامل مباشر مع موسوعة الدرر السنية.
- **ذكاء التذكير**: نظام تذكير بالصلاة على النبي ﷺ يعمل بمهام الخلفية (Background Tasks) لضمان استمرارية العمل حتى والتطبيق مغلق.
- **بوصلة تفاعلية**: تقنية تعتمد على حساسات الجهاز لضمان دقة اتجاه القبلة بنظام Low-pass Filter.
- **محتوى يومي متجدد**: "سنة مهجورة"، "اسم من أسماء الله"، و"حديث اليوم" لتغذية روحك يومياً.

---

## 📸 لقطات من التطبيق (Screenshots)

<div align="center">

| | | |
|:---:|:---:|:---:|
| <img src=".github/screenshots/Android Medium - 19 (1).png" width="220"/> | <img src=".github/screenshots/Android Medium - 19.png" width="220"/> | <img src=".github/screenshots/Android Medium - 14.png" width="220"/> |
| <img src=".github/screenshots/Group 1.png" width="220"/> | <img src=".github/screenshots/Group 2.png" width="220"/> | <img src=".github/screenshots/Group 3.png" width="220"/> |

<br/>

<img src=".github/screenshots/Group 4.png" width="370"/> <img src=".github/screenshots/Group 5.png" width="370"/>

</div>

---

## 🛠️ الجانب التقني (For Developers)

تطبيق "سنا" ليس مجرد واجهة جميلة، بل هو نموذج تطبيقي لأحدث ممارسات هندسة البرمجيات في عالم Flutter:

- **Architecture**: [Clean Architecture](PROJECT_CONTEXT.md#1-clean-architecture-modified) (Data, Logic, Presentation).
- **State Management**: نظام `Bloc/Cubit` مع تطبيق نمط `Sealed States` يدوياً لضمان التوافق مع **Shorebird Patches**.
- **Dependency Injection**: إدارة كاملة للتبعيات عبر `GetIt` مع الالتزام الصارم بـ Constructor Injection.
- **UI Performance**: استخدام مكثف للانتقالات (Slivers) و نظام الـ Skeletonizer لضمان Zero-Jank UX.
- **Hot Updates**: دعم تقنية **Shorebird** لإطلاق التحديثات والتحسينات اللحظية دون الحاجة لتحميل إصدار جديد.

---

## 📂 خريطة المشروع

للمزيد من التفاصيل حول الهيكلية البرمجية، يرجى مراجعة الملفات التالية:
- 📑 **[دليل البنية المعمارية](ARCHITECTURE_GUIDELINES.md)**: القوانين الصارمة لكتابة الكود.
- 🌐 **[سياق المشروع الكامل](PROJECT_CONTEXT.md)**: شرح تقني مفصل لكل وحدة (Module).

---

## 🤝 المساهمة
إذا كنت ترغب في المساهمة في تطوير "سنا" أو الإبلاغ عن مشكلة، نرحب بك عبر قسم Issues في GitHub.

---

<div align="center">
تم التطوير بكل حب لخدمة أمة الإسلام 🌙
</div>
