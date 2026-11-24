import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Asserts that no attached scroll position has extra scrollable extent.
///
/// A screen whose content fits must have `extentAfter == 0` for every
/// `Scrollable` in the tree. Used by the Qibla and Azkar scroll regressions.
void expectNoExtraScroll(WidgetTester tester, {String reason = ''}) {
  var checked = 0;
  for (final element in find.byType(Scrollable).evaluate()) {
    final position = (element.widget as Scrollable).controller?.position;
    if (position == null) continue;
    checked++;
    expect(
      position.extentAfter,
      0.0,
      reason: reason.isEmpty
          ? 'screen must not scroll when all content fits'
          : reason,
    );
  }
  expect(checked, greaterThan(0));
}
