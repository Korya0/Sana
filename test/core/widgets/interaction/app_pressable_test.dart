import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';

const _key = ValueKey('pressable');

void main() {
  testWidgets('ignores taps inside the cooldown window', (tester) async {
    var taps = 0;
    await _pump(
      tester,
      onPressed: () => taps++,
      cooldown: AppConstants.tapCooldown120ms,
    );
    final target = find.byKey(_key);

    await tester.tap(target);
    await tester.pump(const Duration(milliseconds: 110));
    expect(taps, 1);

    await tester.tap(target);
    await tester.pump(const Duration(milliseconds: 110));
    expect(taps, 1);

    await tester.pump(const Duration(milliseconds: 130));
    await tester.tap(target);
    await tester.pump(const Duration(milliseconds: 110));
    expect(taps, 2);
  });

  testWidgets('keeps rapid taps without a cooldown', (tester) async {
    var taps = 0;
    await _pump(tester, onPressed: () => taps++);
    final target = find.byKey(_key);

    await tester.tap(target);
    await tester.pump(const Duration(milliseconds: 110));
    expect(taps, 1);

    await tester.tap(target);
    await tester.pump(const Duration(milliseconds: 110));
    expect(taps, 2);
  });

  testWidgets('ignores a second finger on the same surface', (tester) async {
    var taps = 0;
    await _pump(tester, onPressed: () => taps++);
    final center = tester.getCenter(find.byKey(_key));

    final first = await tester.startGesture(center, pointer: 1);
    final second = await tester.startGesture(center, pointer: 2);
    await tester.pump(const Duration(milliseconds: 60));
    await first.up();
    await second.up();
    await tester.pump(const Duration(milliseconds: 250));

    expect(taps, 0);
  });

  testWidgets('ignores a second finger on a long press', (tester) async {
    var longPresses = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AppPressable(
              key: _key,
              onPressed: () {},
              onLongPress: () => longPresses++,
              child: const SizedBox(width: 120, height: 120),
            ),
          ),
        ),
      ),
    );
    final center = tester.getCenter(find.byKey(_key));

    final first = await tester.startGesture(center, pointer: 1);
    final second = await tester.startGesture(center, pointer: 2);
    await tester.pump(const Duration(milliseconds: 700));
    await first.up();
    await second.up();
    await tester.pump(const Duration(milliseconds: 250));

    expect(longPresses, 0);
  });
}

Future<void> _pump(
  WidgetTester tester, {
  required VoidCallback onPressed,
  Duration cooldown = Duration.zero,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: AppPressable(
            key: _key,
            onPressed: onPressed,
            tapCooldown: cooldown,
            child: const SizedBox(width: 120, height: 120),
          ),
        ),
      ),
    ),
  );
}
