# 🦅 PLUGIN: SHOREBIRD (CODE PUSH) RULES
> **Version:** 1.0.0 | **Author:** Antigravity (Senior Partner)
> **Target:** Seamless Over-The-Air (OTA) Updates, Zero Play Store Delays, Safe Patching.

هذا الملف يحتوي على "دليل التشغيل" الصارم لأوامر وتحديثات Shorebird داخل التطبيق. 
الذكاء الاصطناعي والمبرمج مُلزمان بالعودة لهذه القواعد قبل إصدار أي تحديث جوي (OTA).

---

## 🏛️ CORE PHILOSOPHY
**Shorebird** يسمح لك بتعديل الكود البرمجي بلمح البصر دون انتظار موافقة آبل أو جوجل. لكنه عبارة عن سكين ذو حدين، تحديث واحد يحمل كوداً يمس الـ (Native) قد يعطل التطبيق عند جميع المستخدمين.

---

## 🛠️ SHOREBIRD RULES (قواعد الاستخدام)

### 1. Release vs. Patch (الدستور الأول)
- **`shorebird release`**: يُستخدم **فقط** عندما تقوم بـ:
  - تثبيت بكدج (Package/Plugin) جديدة في `pubspec.yaml` (تحتوي على كود Swift/Kotlin).
  - إضافة أي صور أو خطوط أو ملفات (Assets) جديدة.
  - التعديل على ملفات مثل `AndroidManifest.xml`، `Info.plist`، أو `Podfile`.
  *← هذا سيولد تطبيقاً جديداً يجب رفعه يدوياً لمتجر التطبيقات!*

- **`shorebird patch`**: يُستخدم **فوراً وبحرية** عندما تقوم بـ:
  - إصلاح أخطاء (Bugs) في منطق العمل (Dart UI, Cubits, UseCases).
  - تغيير مسارات الروابط (APIs) للسيرفر.
  - تعديل النصوص أو مقاسات الـ Widgets.
  *← هذا سيصل لهواتف المستخدمين تلقائياً دون متجر التطبيقات!*

---

## 🚫 ANTI-PATTERNS (المحرمات أثناء الـ Patch)

1. إذا طُلب منك إضافة صورة جديدة للـ UI، **ممنوع** استخدام الـ Patch! 
   اقتراحات بديلة للذكاء الاصطناعي: استخدم صورة من الإنترنت (`CachedNetworkImage` - K2) أو استخدم صورة (Asset) متواجدة مسبقاً قبل التحديث.
2. لا تستخدم `flutter build apk` إذا كان التطبيق يعتمد على Shorebird، بل استبدله دائماً بـ `shorebird build apk` في الـ CI/CD.

---

## 🤖 AI INTERACTION TEMPLATE
عند سؤال الذكاء الاصطناعي عن Shorebird، قم بلصق هذا الـ Prompt:
"يا ذكاء اصطناعي، هل الكود الجديد الذي اقترحته مؤهل لنقوم بعمل `shorebird patch` له وتحديثه جواً؟ تأكد من القواعد في @shorebird_rules.md قبل الإجابة، هل مسست ملفاً من الـ Assets أو الـ Packages؟"

---

## 🔗 INTEGRATION CHEATSHEET (ورقة غش الاندماج)

### 1. الاندماج مع DevOps - Github Actions (قسم L5)
داخل ملف الـ `ci.yml` (المشروح في L5)، استبدل أمر فلاتر العادي بأمر شوربيرد، وتأكد من إضافة الشريحة السرية هكذا:
```yaml
      # استبدل flutter action بـ shorebird
      - name: Setup Shorebird
        uses: shorebirdtech/setup-shorebird@v1

      # إطلاق باتش جديد تلقائياً للمستخدمين عند دمج الكود في الـ Main Branch
      - name: Shorebird Patch
        run: shorebird patch android --force
        env:
          SHOREBIRD_TOKEN: ${{ secrets.SHOREBIRD_TOKEN }}
```

### 2. الكود البرمجي (In-App Monitor)
لفحص وجود باتش جديد داخل التطبيق وعرض شاشة "يرجى إعادة التشغيل" بدلاً من التحديث الصامت المفاجئ للمستخدم، ضع هذا الكود في الشاشة الافتتاحية (`Splash Screen`):

```dart
// import 'package:shorebird_code_push/shorebird_code_push.dart';

Future<void> checkForShorebirdUpdates() async {
  /*
  final shorebirdCodePush = ShorebirdCodePush();
  
  // 1. هل نحن على نسخة معدلة من شوربيرد؟
  final isShorebirdAvailable = await shorebirdCodePush.isNewPatchAvailableForDownload();
  
  if (isShorebirdAvailable) {
    // 2. تحميل الباتش الجوي في الخلفية (صامت)
    await shorebirdCodePush.downloadUpdateIfAvailable();
    
    // 3. (اختياري) تنبيه المستخدم
    AppLogger.info('تم تحميل تحديث جوي بنجاح، سيتم تفعيله عند إغلاق التطبيق القادم.');
    
    // أو عرض نافذة تطلب من المستخدم الغلق الفوري:
    // showDialog(.. "يوجد تحديث جديد، أعد تشغيل التطبيق وافتحه");
  }
  */
}
```

### 3. إدارة الإصدارات (Versioning - L9)
إذا كان إصدار تطبيقك الحالي على مَتجر جوجل هو `1.0.0+1`:
1. يمكنك إرسال آلاف الباتشات (`Patch`) للمستخدمين المالكين للنسخة `1.0.0+1` ولن يتغير رقمهم.
2. إذا قمت برفع `1.0.1+2` للمتجر عبر (L9)، فيجب عليك وقتها إنشاء `release` جديد لـ Shorebird ليواكب هو أيضاً الإصدار `1.0.1`. الباتشات القديمة في `1.0.0` لن تتداخل أو تصل بالخطأ لمستخدمي الإصدار `1.0.1`.
