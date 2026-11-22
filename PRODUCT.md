# Product

<!-- impeccable:product-schema 1 -->

## Platform

adaptive

## Users

- **Primary (user-stated):** a Muslim tracking Quran memorization (hifz) who uses a mobile companion around recitation practice. This is a stated direction: the hifz/khatma/recitation-correction modules are listed as *Coming Soon* in `README.md`, not delivered in the current build.
- **Current workflow audience:** people building a daily remembrance habit who browse azkar, count zikr and tasbeeh, and customize their own collections on a phone.
- **Secondary audiences:** not established. Do not invent learner, teacher, or community roles.

## Product Purpose

Sana (سَـنَـا) is intended as a single Islamic companion app that supports daily practice across remembrance, Quran, hadith, ruqyah, seerah, and hifz. The user selected "all-in-one companion" as the promise future work must preserve.

What exists today is the azkar/tasbeeh slice: bundled azkar categories, a reader with per-zikr counters, a tasbeeh counter, local customization, and reading settings. Success today is a quick, distraction-free reading and counting session that works offline, with no account and no cloud dependency.

## Positioning

**Declared direction:** one companion that grows to cover the full range of Islamic practice rather than a single-purpose azkar app. Repository evidence marks Quran, hadith, ruqyah, seerah, and hifz/khatma/AI recitation as *Coming Soon*; they are not shipped and must not be described as available.

**Truthful differentiator in the shipped product:** offline-first, account-free azkar/tasbeeh counting with bundled content, resilient local overrides/custom categories, and an Android-native volume-key bridge so counting works without looking at the screen. A neighboring app could not copy that combination without building the same local storage and native integration.

## Operating Context

- Mobile app used in short, repeated moments — after prayer, at home, on the move — where the user opens a category or counter and starts counting immediately.
- Arabic-first, right-to-left interface with light and dark themes; reading font size, haptics, and (on Android) volume-button counting are user-configurable.
- Content comes from bundled JSON (`assets/json/azkar/`); user edits and tasbeeh items are persisted locally. Firebase is wired for Analytics, Crashlytics, and Remote Config, but the user-facing workflows do not require an account or network.
- The app already has Android and iOS build targets sharing one Flutter design language; the volume-key bridge exists only on Android. The user recorded the platform as `adaptive`, so later work should treat OS-specific treatment as a direction to resolve, not as an already-implemented split.
- **Current work scope (user directive, 2026-11-22):** azkar/tasbeeh screens only. Do not build out the planned Quran, hifz, hadith, ruqyah, or seerah modules in this work.

## Capabilities and Constraints

- **Implemented:** azkar categories and reader, per-zikr counters with target completion, reset/decrement gestures, exit confirmation, adjustable reading font size, haptics, Android volume-key counting (default on, explicit opt-out respected), custom categories and built-in overrides with restore, tasbeeh items and counter, skeleton loading, error views with retry, and scoped toast feedback.
- **Explicitly out of scope:** cloud sync, accounts, and persistent reader-counter progress (counters are in-memory per session). Tasbeeh counts and targets are saved locally.
- **Platform constraint:** volume-key counting is Android-only; on other platforms the setting is visible but disabled. iPhone support is deferred.
- **Undecided:** how the two OS targets should differ visually under the recorded `adaptive` platform choice; the repository currently uses one shared design language.
- **Engineering constraints to preserve:** the documented design-system rules in `docs/design_system/01_theme.md` and `02_tokens.md` (approved color values require explicit approval; no raw colors, inline text styles, raw icons, or hard-coded numbers in UI code; token-driven sizing) and the architecture conventions in `docs/architecture/`. Feature slices may import only `core/`.
- **Cap limits:** custom tasbeeh text is bounded at 200 characters; targets and free counts cap at 9999.

## Brand Commitments

- Name: **Sana (سَـنَـا)**. README subtitle: "A simple and clear modern Islamic companion." `pubspec.yaml` describes it as "a premium Islamic companion application built with Flutter."
- Arabic-first product voice; README closes with "Developed with passion for the Ummah" and "© 2026 Sana Team".
- Public surfaces referenced in `README.md`: website (`sana0.vercel.app`), Google Play listing, a separate landing page, and a Facebook page. These are external links, not in-repo assets.
- Open-source project under the MIT License per README. No LICENSE file is present in the checkout — treat the license text as unverified until the file is added.
- No binding aesthetic direction, palette, typography, or imagery was given during init; none is recorded here.

## Evidence on Hand

- `README.md`: feature status, tech stack, public links, screenshot (`docs/assets/screenshots/azkar_view.jpg`), and *Coming Soon* module list.
- `docs/features/azkar/README.md` and `docs/features/azkar/spec.md`: confirmed decisions D-001–D-027, flows, storage format, edge cases, and feedback rules.
- `assets/json/azkar/categories.json` and category JSON files: bundled azkar source content.
- `docs/design_system/`, `docs/ui/`, and `docs/architecture/`: enforced implementation and interaction conventions.
- No testimonials, customer logos, benchmarks, pricing, or case studies exist in the repository. Do not fabricate them in future work.

## Product Principles

1. **One companion, complete slices.** Grow toward the all-in-one direction only through finished, working features; today's complete slice is azkar/tasbeeh.
2. **Offline-first and private.** Bundled content and local storage; no account, no cloud sync, no network requirement for the core workflows.
3. **Fast, quiet counting.** Minimize steps between opening the app and counting; use Android volume keys where available; never interrupt with success messages for self-evident actions.
4. **Resilient local customization.** User edits survive corrupted or legacy data, writes are serialized, and restoring built-ins is a single deliberate action.
5. **Preserve approved conventions.** Respect the documented design tokens, RTL behavior, and recorded feature decisions; changing an approved color or an established behavior requires explicit approval.

## Accessibility & Inclusion

- No formal accessibility standard was claimed. Do not assert WCAG conformance.
- Already-enforced behaviors to preserve: Arabic RTL layout, scaled type and spacing through `AppSize` tokens, and reduced-motion support through `context.reduceMotion`.
