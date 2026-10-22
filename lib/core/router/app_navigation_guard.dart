import 'dart:async';

import 'package:flutter/widgets.dart';

/// One door for navigation: the first request wins, the rest are dropped
/// until the current route transition completes.
///
/// The lock is acquired *before* the navigation call, so a second tap that
/// arrives in the same event batch cannot start another push.
abstract final class AppNavigationGuard {
  static bool _locked = false;
  static Timer? _fallback;

  /// Extra time after the longest standard transition, used only when the
  /// observer never reports completion (instant routes, failures, tab swaps).
  static const Duration _fallbackTimeout = Duration(milliseconds: 600);

  static bool get isLocked => _locked;

  /// Returns `false` when another navigation is already in flight.
  static bool acquire() {
    if (_locked) return false;

    _locked = true;
    _fallback = Timer(_fallbackTimeout, release);
    return true;
  }

  static void release() {
    _fallback?.cancel();
    _fallback = null;
    _locked = false;
  }

  /// Runs a navigation that returns a value; returns `null` when locked.
  static T? runIfIdle<T>(T Function() action) {
    if (!acquire()) return null;

    try {
      return action();
    } catch (_) {
      release();
      rethrow;
    }
  }

  /// Runs a navigation with no return value.
  static bool run(VoidCallback action) {
    if (!acquire()) return false;

    try {
      action();
      return true;
    } catch (_) {
      release();
      rethrow;
    }
  }

  /// Runs a synchronous switch (tabs) and releases on the next frame.
  static bool runTransient(VoidCallback action) {
    if (!acquire()) return false;

    try {
      action();
    } catch (_) {
      release();
      rethrow;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => release());
    return true;
  }
}
