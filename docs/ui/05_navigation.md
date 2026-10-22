# Navigation Rules — One Door, One Screen at a Time

How the app prevents two destinations from opening at the same moment.
Tap behaviour is in [`04_tap.md`](04_tap.md); layout is in
[`01_layout.md`](01_layout.md).

---

## 1. The problem

Every `AppPressable` owns a `GestureDetector`, and Flutter gives each pointer
its own gesture arena. Four fingers on four cards therefore produce four valid
taps, and every `pushNamed` adds a page. The result is a stack of screens that
the user never meant to open.

Routing does not serialize these calls by itself, and route transitions start
after the callbacks are already running. The fix must be an explicit lock.

## 2. One door

All navigation goes through `AppNavigator` (routes) or `AppNavigationGuard`
(overlays and tab switches).

| Action | Entry point |
|---|---|
| Push a named route | `AppNavigator.pushNamed(...)` |
| Replace the location | `AppNavigator.go(...)` |
| Dialog | `AppNavigationGuard.runIfIdle(() => showDialog(...))` |
| Bottom sheet | `AppNavigationGuard.runIfIdle(() => showModalBottomSheet(...))` |
| Bottom-nav tab switch | `AppNavigationGuard.runTransient(() => goBranch(...))` |

**Never** call `context.push`, `context.go`, `showDialog` or
`showModalBottomSheet` directly from a feature widget.

## 3. The lock

```text
acquire() ──► navigation call ──► transition completed ──► release()
    │                                                          ▲
    └── fallback 600 ms ───────────────────────────────────────┘
```

- `acquire()` happens **before** the navigation call, so a second tap in the
  same event batch finds the door closed.
- The second request is dropped silently — no queue, no stacked screens.
- `AppNavigatorObserver` releases on `AnimationStatus.completed` (and
  `dismissed` if the user goes back mid-transition).
- A 600 ms fallback releases the lock when no animation reports completion
  (instant routes, failures, tab swaps). The app can never stay locked.
- `runTransient` is for synchronous switches: it releases on the next frame.

## 4. The files

| File | Role |
|---|---|
| `lib/core/router/app_navigation_guard.dart` | Lock, `run`, `runIfIdle`, `runTransient` |
| `lib/core/router/app_navigator.dart` | `pushNamed` and `go` helpers |
| `lib/core/router/app_navigator_observer.dart` | Releases the lock on transition completion |
| `lib/core/router/app_router.dart` | Registers the observer |

## 5. What is not guarded

- `Navigator.pop` and system back — they remove a screen, they cannot stack one.
- Deep links and initial location — the router owns them.
- Share sheets and external intents — not route navigation.

## 6. Checklist

- [ ] Every `push` / `go` goes through `AppNavigator`.
- [ ] Every dialog / bottom sheet goes through `AppNavigationGuard.runIfIdle`.
- [ ] Tab switches use `runTransient`.
- [ ] No direct `context.push` / `context.go` in feature code.
- [ ] Four simultaneous taps open at most one screen.
- [ ] Normal navigation is not delayed; the lock clears on transition end.
- [ ] Back, scroll, pinch and text selection are unaffected.
