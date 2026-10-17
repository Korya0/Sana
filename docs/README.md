# Sana — Engineering Docs

Every rule for this project lives in this folder, and nowhere else. Each file
below is the single source of truth for one concern. If a rule is not in one of
them, it does not exist — and if you find the same rule written twice, one of
the two copies is wrong.

Read the one file that matches what you are doing. You do not need to read them
all.

---

## 1. Read by task

| I am… | Read |
|---|---|
| sharing code between features, or writing comments | [`architecture/03_code_conventions.md`](architecture/03_code_conventions.md) |
| naming a file, folder, class, variable, route or storage key | [`architecture/01_naming.md`](architecture/01_naming.md) |
| building a new feature | [`workflow/01_features.md`](workflow/01_features.md) |
| fixing a bug or a crash | [`workflow/02_bugs.md`](workflow/02_bugs.md) |
| handling errors or logging | [`architecture/02_logging_and_errors.md`](architecture/02_logging_and_errors.md) |
| styling — colors, typography, decorations or theme-aware assets | [`design_system/01_theme.md`](design_system/01_theme.md) |
| sizes, spacing, constants, validators, dates or formatters | [`design_system/02_tokens.md`](design_system/02_tokens.md) |
| laying out a screen — alignment, RTL, hit testing | [`ui/01_layout.md`](ui/01_layout.md) |
| building a screen or a widget | [`ui/02_widgets.md`](ui/02_widgets.md) |
| writing user-facing text | [`ui/03_text.md`](ui/03_text.md) |
| enabling or disabling the Quran feature | [`quran_feature_toggle.md`](quran_feature_toggle.md) |

---

## 2. The files

### `workflow/` — the step-by-step processes

| File | Owns |
|---|---|
| [`01_features.md`](workflow/01_features.md) | The new-feature workflow and its pause gates |
| [`02_bugs.md`](workflow/02_bugs.md) | The bug-fix workflow and its pause gates |

### `architecture/` — how the app is built

| File | Owns |
|---|---|
| [`01_naming.md`](architecture/01_naming.md) | File, folder, class, variable, route and storage-key naming, plus the private-constructor pattern |
| [`02_logging_and_errors.md`](architecture/02_logging_and_errors.md) | Where errors are logged, the error types and the `Result<T>` contract |
| [`03_code_conventions.md`](architecture/03_code_conventions.md) | Shared-code rules and the comment style |

### `design_system/` — the values themselves

| File | Owns |
|---|---|
| [`01_theme.md`](design_system/01_theme.md) | Colors, typography, theme-aware assets and shared decorations |
| [`02_tokens.md`](design_system/02_tokens.md) | Pixel tokens (`AppSize`), constants, validators, date formatters and `BuildContext` sugar |

### `ui/` — how it is put together

| File | Owns |
|---|---|
| [`01_layout.md`](ui/01_layout.md) | Screen shell, alignment and direction rules, directional spacing, hit testing |
| [`02_widgets.md`](ui/02_widgets.md) | Widget reuse, decomposition, UI states, overflow, build discipline and performance |
| [`03_text.md`](ui/03_text.md) | Arabic strings in `AppStrings`, wording, shape and hygiene |

---

## 3. Universal gates

Before any task is marked done:

```bash
flutter analyze          # must report: No issues found!
flutter test             # domain and data logic must pass
```

- **Before marking any task done → run the `/code-review` skill.**
- **After the task is approved → run the `/create-pr` skill** for branch, commit
  and PR output.
- **PR descriptions are always Markdown (`.md`).**

---

## 4. Keeping this folder honest

- **One fact, one file.** A rule belongs to exactly one file. If you find the
  same rule in a second file, delete it there and link instead.
- **Link, don't restate.** A cross-reference survives a rename; a copied table
  rots. Point at the file that owns the rule.
- **The code is the authority.** When a doc and the code disagree, the code wins
  and the doc is fixed in the same change.

---

## 5. Layout

```
docs/
├── README.md                        ← this file
├── workflow/
│   ├── 01_features.md
│   └── 02_bugs.md
├── architecture/
│   ├── 01_naming.md
│   ├── 02_logging_and_errors.md
│   └── 03_code_conventions.md
├── design_system/
│   ├── 01_theme.md
│   └── 02_tokens.md
├── ui/
│   ├── 01_layout.md
│   ├── 02_widgets.md
│   └── 03_text.md
└── quran_feature_toggle.md          ← feature-toggle runbook (kept as-is)
```
