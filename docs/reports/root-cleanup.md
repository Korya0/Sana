# تقرير هيكلة المشروع (Root + Folder Structure)

> **الحالة:** ✅ تم تنفيذ المهمة (دمج الـ yaml + تنظيم الـ docs + توحيد `.agents`). الحذف الاختياري مؤجّل.
> **الفرع:** `refactor/folder-structure`
> **الهدف:** تخفيف فوضى الـ root، دمج الملفات القابلة للدمج، حذف اللي مالوش لازمة، وإعادة تنظيم المستندات — بدون كسر أي وظيفة.

---

## 0) ما تم تنفيذه فعليًا

| # | الإجراء | التفاصيل |
|---|---|---|
| 1 | 🔀 **دمج** | إعدادات `flutter_launcher_icons` + `flutter_native_splash` اتنقلت جوه `pubspec.yaml`، والملفين الأصليين اتحذفوا |
| 2 | 📦 **نقل** | `PROJECT_STRUCTURE.md` → `docs/architecture.md` |
| 3 | 📦 **نقل** | `docs/feature_azkar.md` → `docs/features/azkar.md` |
| 4 | 📦 **نقل** | `WEB_CLEANUP_REPORT.md` → `docs/reports/web-cleanup.md` |
| 5 | 📦 **نقل** | `ROOT_CLEANUP_REPORT.md` → `docs/reports/root-cleanup.md` (ده الملف اللي بتقرأه) |
| 6 | 🔗 **توحيد** | ملفات `.agent/*.md` اتنقلت إلى `.agents/` واتشالت `.agent`، والروابط الداخلية اتحدّثت |
| 7 | 📦 **نقل** | `github_assets/` → `docs/assets/` + تحديث مسارات الصور في `README.md` (10 مراجع) |
| 8 | 🗑️ **حذف** | `docs/assets/sana_vedio.mp4` (32 MB غير مستخدم) + `sana.iml` + `devtools_options.yaml` (واتضاف لـ `.gitignore`) |

> ⚠️ أثناء التنفيذ كان فيه AI تاني شغّال بالتوازي وعمل حذوفات في `test/features/azkar/**` — **ما المسّتهاش** وخرجت برّه الـ commit.

---

## 1) ملخّص

| الفئة | العدد | أمثلة |
|---|---|---|
| ملفات قابلة **للدمج** في `pubspec.yaml` | 2 | `flutter_launcher_icons.yaml`, `flutter_native_splash.yaml` |
| عناصر قابلة **للحذف** (مش مستخدمة) | 2 (+2 اختياري) | `sana.iml`, `github_assets/sana_vedio.mp4` (**32.6 MB**) |
| مستندات تحتاج **إعادة تنظيم** | 4 | `PROJECT_STRUCTURE.md`, `WEB_CLEANUP_REPORT.md`, `docs/feature_azkar.md`, `.agent/PROJECT_CONTEXT.md` |
| فولدرات **مش بتاعتنا / ميلمسهاش** | 1 | `.freebuff/` |
| فولدرات **تُبقى كما هي (أساسية)** | ~14 | `lib`, `android`, `ios`, `web`, `assets`, `.github`, … |

> بعد التنظيف المقترح، الـ root ينزل من **~28 عنصر** إلى **~12 عنصر** أساسي.

---

## 2) جدول عناصر الـ root كامل

| العنصر | النوع | Git | الوظيفة | التوصية |
|---|---|---|---|---|
| `.agent/` | فولدر | ✅ متتبَّع | ملفات `CLAUDE*.md` + `PROJECT_CONTEXT.md` (سياق AI) | **يُبقى** (مع إعادة تسمية — انظر §5) |
| `.agents/skills/` | فولدر | ✅ متتبَّع | مهارات (spec-kit + `code_refactor`) | **يُبقى** |
| `.specify/` | فولدر | ✅ متتبَّع | scaffolding الخاصة بـ spec-kit | **يُبقى** لو بتستخدم spec-kit، وإلا يُحذف |
| `.github/` | فولدر | ✅ متتبَّع | workflows (`android_*`) | **يُبقى** |
| `.dart_tool/` | فولدر | 🚫 ignor | مخرجات `pub` مولّدة | يُبقى (auto) |
| `.freebuff/` | فولدر | 🚫 ignor (`.git/info/exclude`) | **مش بتاع المشروع — تابع لأداة تانية شغّالة بالتوازي** | ⛔ **لا يُلمس** |
| `.idea/` | فولدر | 🚫 ignor | إعداد IntelliJ | يُبقى محليًا / يُحذف (اختياري) |
| `.vscode/` | فولدر | 🚫 ignor | إعداد VS Code | يُبقى محليًا / يُحذف (اختياري) |
| `.gitattributes` | ملف | ✅ | سمات الإحصاء/Diff | **يُبقى** |
| `.gitignore` | ملف | ✅ | قواعد تجاهل | **يُبقى** |
| `analysis_options.yaml` | ملف | ✅ | قواعد الـ lint | **يُبقى** |
| `pubspec.yaml` | ملف | ✅ | الحِزم + إعدادات Flutter | **يُبقى** (هدف الدمج) |
| `pubspec.lock` | ملف | ✅ | تثبيت الإصدارات | **يُبقى** |
| `README.md` | ملف | ✅ | وصف المشروع | **يُبقى** |
| `firebase.json` | ملف | ✅ | إعداد FlutterFire | **يُبقى** |
| `shorebird.yaml` | ملف | ✅ | إعداد OTA — الـ CLI لازمه في الـ root | **يُبقى** (مش قابل للدمج) |
| `flutter_launcher_icons.yaml` | ملف | ✅ | إعداد أيقونة التطبيق | 🔀 **يُدمج في `pubspec.yaml`** |
| `flutter_native_splash.yaml` | ملف | ✅ | إعداد شاشة البداية | 🔀 **يُدمج في `pubspec.yaml`** |
| `PROJECT_STRUCTURE.md` | ملف (67 KB!) | ✅ | توثيق الهيكل — ضخم ومتداخل مع `docs/` و `.agent/` | 📦 **يُنقل إلى `docs/`** |
| `WEB_CLEANUP_REPORT.md` | ملف (12 KB) | ✅ | تقرير تنظيف الويب (اللي عملناه) | 📦 **يُنقل إلى `docs/reports/`** |
| `devtools_options.yaml` | ملف | ✅ | إعداد DevTools (فاضي) | **يُبقى** / حذف (اختياري) |
| `sana.iml` | ملف | 🚫 ignor (`*.iml`) | ملف موديول IntelliJ — يُعاد توليده | 🗑️ **يُحذف** |
| `assets/` | فولدر | ✅ | أصول التطبيق (`audio, fonts, images, json, native, svgs`) | **يُبقى** |
| `github_assets/` | فولدر | ✅ | وسائط الـ README (gif + screenshots + **فيديو 32 MB**) | **يُبقى بشرط** (§4) |
| `lib/` | فولدر | ✅ | كود المشروع (`core/` + `features/` + `main.dart`) | **يُبقى** |
| `test/` | فولدر | ✅ | الاختبارات | **يُبقى** |
| `android/` `ios/` `web/` | فولدرات | ✅ | المنصات | **تُبقى** |

---

## 3) الدمج (Merge) → `pubspec.yaml`

دي بالظبط الفكرة اللي طرحتها. الاتنين دول **بيدعموا** القراءة من `pubspec.yaml` مباشرة، يعني ينفع ننقل محتواهم ونحذف الملفين.

### 3.1 `flutter_launcher_icons.yaml` → قسم `flutter_launcher_icons:` في `pubspec.yaml`

المحتوى الحالي:
```yaml
flutter_launcher_icons:
  android: true
  ios: true
  web:
    generate: true
    image_path: "assets/native/app_icon.png"
    background_color: "#ffffff"
    theme_color: "#ffffff"
  remove_alpha_ios: true
  image_path: "assets/native/app_icon.png"
```
- الأمر بدون تغيير: `dart run flutter_launcher_icons`
- ✅ ملاحظة: `web:` موجود هنا — بما إننا سبنا فولدر `web/` للمعاينة، ممكن نسيب توليد أيقونة الويب.

### 3.2 `flutter_native_splash.yaml` → قسم `flutter_native_splash:` في `pubspec.yaml`

المحتوى الحالي:
```yaml
flutter_native_splash:
  color: "#ffffff"
  image: "assets/native/splash.png"
  color_dark: "#000000"
  image_dark: "assets/native/splash.png"
  android: true
  ios: true
  web: false
  android_gravity: center
  ios_content_mode: center
  android_12:
    image: "assets/native/splash.png"
    icon_background_color: "#ffffff"
    image_dark: "assets/native/splash.png"
    icon_background_color_dark: "#000000"
```
- الأمر بدون تغيير: `dart run flutter_native_splash:create`

**النتيجة:** نحذف الملفين من الـ root، والـ `pubspec.yaml` يبقى المصدر الوحيد للإعدادات. (ملاحظة: `pubspec.yaml` بيضيف `shorebird.yaml` في `assets:` — سطر 119 — وممكن نظّفها لو مش محتاجة تُحزَّم.)

---

## 4) الحذف (Delete)

| العنصر | الحجم | السبب |
|---|---|---|
| `sana.iml` | 859 B | ملف IntelliJ متجاهَل بـ `*.iml` ويُعاد توليده تلقائيًا — مالوش لازمة |
| `github_assets/sana_vedio.mp4` | **32.6 MB** | **مش مستخدَم** — الـ `README.md` بيستعمل `sana_gif.gif` + الصور بس (تأكدت بالبحث) |
| `devtools_options.yaml` *(اختياري)* | 187 B | إعداد DevTools فاضي (`extensions:` بدون محتوى) ويُعاد توليده |
| `.idea/`, `.vscode/` *(اختياري، محلي)* | — | متجاهَلين أصلًا ومش متتبَّعين |

> 💡 حذف الفيديو لوحده بيوفّر **~32 MB** من حجم الريبو. قبل الحذف اتأكد إنه مش مستخدم على صفحة GitHub أو مكان خارج الريبو.

---

## 5) إعادة التنظيم (Reorganize)

| من | إلى | السبب |
|---|---|---|
| `PROJECT_STRUCTURE.md` (root) | `docs/architecture.md` | ملف ضخم (67KB) مكانه الطبيعي في `docs/` |
| `WEB_CLEANUP_REPORT.md` (root) | `docs/reports/web-cleanup.md` | التقارير تجمّع في مكان واحد بدل ما تكرّم الـ root |
| `docs/feature_azkar.md` | `docs/features/azkar.md` | تنظيم مستندات الفيتشرز حسب مجلد |
| `github_assets/` | `docs/assets/` *(أو `assets_readme/`)* | تمييز أصول التوثيق عن `assets/` الخاصة بالتطبيق |
| `.agent/*.md` + `.agents/skills/` | توحيد تحت فولدر واحد (مثلاً `.ai/`) | **`.agent/` و `.agents/` اسمين شبه متطابقين** → لبس وسهل الغلط |

### الشكل المقترح بعد التنظيم
```
muslim_app/
├── .github/            # workflows
├── .ai/                # (اختياري) توحيد .agent + .agents أو الإبقاء على الاتنين المنفصلين
├── .specify/
├── android/  ios/  web/
├── assets/             # أصول التطبيق
├── docs/
│   ├── architecture.md         # ← PROJECT_STRUCTURE.md
│   ├── features/
│   │   └── azkar.md            # ← docs/feature_azkar.md
│   ├── reports/
│   │   └── web-cleanup.md      # ← WEB_CLEANUP_REPORT.md
│   └── assets/                 # ← github_assets/ (gif + screenshots)
├── lib/                # core/ + features/ + main.dart
├── test/
├── analysis_options.yaml
├── pubspec.yaml        # + flutter_launcher_icons + flutter_native_splash
├── firebase.json
├── shorebird.yaml
├── .gitignore
├── .gitattributes
└── README.md
```

---

## 6) ملاحظات وتحذيرات

1. ⛔ **`.freebuff/`**: فولدر ظهر في الـ root ومتسجّل ignor في `.git/info/exclude` — **مش تابع للمشروع** ويبان بتاع الأداة التانية اللي شغّالة معاك. **متلمسوش.**
2. ⚠️ **`.agent/` vs `.agents/`**: الاتنين متتبَّعين والاسمين بيتلخبطوا — أنصح بتوحيدهم أو إعادة تسمية واحد.
3. 🔍 **`analysis_options.yaml`** فيه `exclude` لمسارات ممكن تكون قديمة: `lib/core/networking/firebase/**` و `lib/core/constants/generated/**` — يستحق مراجعة لو المسارات دي مش موجودة.
4. 📦 `pubspec.yaml > assets:` بيحزّم `shorebird.yaml` كأصل — غالبًا مش لازم.
5. 🧹 `lib/` نفسها **مرتبة أصلًا** (`core/` + `features/` + `main.dart`) — مفيش تدخّل مطلوب على مستوى الـ root.

---

## 7) خطة التنفيذ المقترحة (بعد موافقتك)

- [ ] دمج `flutter_launcher_icons.yaml` في `pubspec.yaml` ثم حذف الملف
- [ ] دمج `flutter_native_splash.yaml` في `pubspec.yaml` ثم حذف الملف
- [ ] حذف `sana.iml`
- [ ] حذف `github_assets/sana_vedio.mp4` (بعد تأكيد إنه مش مستخدم خارجيًا)
- [ ] نقل `PROJECT_STRUCTURE.md` → `docs/architecture.md`
- [ ] نقل `WEB_CLEANUP_REPORT.md` → `docs/reports/`
- [ ] تنظيم `docs/` (`features/` + `reports/` + `assets/`)
- [ ] (اختياري) توحيد `.agent/` + `.agents/`
- [ ] (اختياري) حذف `devtools_options.yaml`

> كل خطوة قابلة للرجوع عبر git، والدمج (البنود 1–2) لا يغيّر أوامر التوليد إطلاقًا.
