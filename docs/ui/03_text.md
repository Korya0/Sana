# Text Rules — `AppStrings`, Wording, Hygiene

**Single source of truth** for every user-facing string. Read it before writing
any Arabic text into a widget.

How text is placed in a layout is in [`01_layout.md`](01_layout.md) §7. Naming
rules are in [`../architecture/01_naming.md`](../architecture/01_naming.md).

---

## 1. The mental model

```
widget  ──►  AppStrings.*          ← the only place Arabic text lives
             core/constants/app_strings.dart
```

- **Arabic is the only language.** There is no translation layer — no ARB, no
  `context.l10n`, no second locale.
- The app was designed in Arabic, so the wording is written directly in Arabic
  and its length defines the layout.
- Strings are `static const` where possible; a `static String` factory method is
  used only when interpolation or a conditional is needed.

---

## 2. 🚨 The rule

> **Every user-facing string lives in `AppStrings`, in Modern Simplified Fusha —
> clear, correct Arabic any speaker understands. No inline text. No dialect.**

```dart
// ✅
Text(AppStrings.prayerTimes)

// ❌ FORBIDDEN
Text('مواقيت الصلاة')            // inline
Text('عايز أعرف مواقيت الصلاة')   // dialect
```

- Use Arabic punctuation (، ؟ " ") consistently.
- Prefer a complete, natural phrase over a staccato fragment.
- Error messages are user-friendly and never expose technical details.

---

## 3. How to choose and shorten a string

Take the shortest wording that keeps the meaning. Shorten the wording before
reaching for `maxLines` + ellipsis.

| Technique | Before | After |
|---|---|---|
| Drop the polite filler | `من فضلك أدخل بياناتك` | `أدخل بياناتك` |
| One word for a phrase | `الرجاء الانتظار قليلاً` | `جارٍ التنزيل` |
| Drop the pronoun when it is clear | `اضغط هنا لرؤية المزيد` | `تصفح المزيد` |
| Passive → direct | `لم يتم العثور على نتائج` | `لا نتائج` |
| Reuse an existing string | `حفظ التعديلات` | `حفظ` |
| Active → terse | `فشل في حفظ البيانات` | `تعذّر الحفظ` |

- Standard terms with no shorter correct form (proper nouns, brand names,
  numbers, codes) need no shortening.
- `maxLines` + `TextOverflow.ellipsis` is a safety net, **not** the fix — see
  [`02_widgets.md`](02_widgets.md) §5.

---

## 4. Shape of a string

| Need | Form |
|---|---|
| Fixed text | `static const String name = '...';` |
| Interpolated text | `static String name(String value) => '... $value ...';` |
| Conditional text | `static String name(bool flag) => flag ? '...' : '...';` |

```dart
static const String copiedToClipboard = 'تم النسخ بنجاح';
static String itemCopied(String item) => 'تم نسخ $item بنجاح';
```

- Multi-line wording uses `\n` inside the string, not a second widget:

```dart
static const String note = '\n\n(تنبيه: يمكنك التعديل لاحقاً...)';
```

---

## 5. Hygiene

- **No aliases.** Never `static const String a = b;`. If a string must be renamed
  or merged, update **every** call site.
- **Reuse before adding.** Prefer an existing string over a near-duplicate.
- **No dead strings.** Never add a string that no widget reads — search for
  `AppStrings.<name>` before removing one.
- **Name after meaning**, in camelCase, matching the feature or screen.
- **Group** related strings under a `//` section comment.

---

## 6. Gates

```bash
flutter analyze   # must print: No issues found!
```

### Pre-submit checklist

- [ ] No inline Arabic (or English) text in any widget
- [ ] New text lives in `AppStrings`, in Modern Simplified Fusha (no dialect)
- [ ] Arabic punctuation used consistently (، ؟ " ")
- [ ] Error messages are friendly and free of technical detail
- [ ] No alias string
- [ ] No string without a reader
- [ ] Every renamed or merged string is updated at every call site
