import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/core/widgets/text/app_marquee_text.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_preset_grid.dart';

void main() {
  testWidgets('shows two preset azkar and a matching custom tile', (
    tester,
  ) async {
    String? selectedPreset;
    var customPressed = false;
    await _pumpGrid(
      tester,
      onSelect: (text) => selectedPreset = text,
      onCustomTap: () => customPressed = true,
    );

    expect(AppStrings.tasbeehPresets, hasLength(2));
    for (final preset in AppStrings.tasbeehPresets) {
      expect(find.text(preset), findsOneWidget);
    }
    expect(find.text(AppStrings.customTasbeeh), findsOneWidget);

    final tiles = find.byType(AppPressable);
    expect(tiles, findsNWidgets(3));

    final firstTileSize = tester.getSize(tiles.first);
    final firstTileTop = tester.getTopLeft(tiles.first).dy;
    for (var index = 1; index < 3; index++) {
      expect(tester.getSize(tiles.at(index)), firstTileSize);
      expect(tester.getTopLeft(tiles.at(index)).dy, firstTileTop);
    }

    await tester.tap(find.text(AppStrings.tasbeehPresets.first));
    await tester.pump(const Duration(milliseconds: 120));
    await tester.tap(find.text(AppStrings.customTasbeeh));
    await tester.pump(const Duration(milliseconds: 120));

    expect(selectedPreset, AppStrings.tasbeehPresets.first);
    expect(customPressed, isTrue);
  });

  testWidgets('shows the preset icons and one-line moving labels', (
    tester,
  ) async {
    await _pumpGrid(tester);

    expect(find.byIcon(AppIcons.tasbih), findsOneWidget);
    expect(find.byIcon(AppIcons.repentance), findsOneWidget);
    expect(find.byIcon(AppIcons.add), findsOneWidget);
    expect(find.byType(AppMarqueeText), findsNWidgets(3));

    final label = tester.widget<Text>(
      find.text(AppStrings.tasbeehPresets.first),
    );
    expect(label.style?.fontSize, AppSize.f12);
    expect(label.maxLines, 1);
  });
}

Future<void> _pumpGrid(
  WidgetTester tester, {
  ValueChanged<String>? onSelect,
  VoidCallback? onCustomTap,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      builder: (context, child) {
        AppSize.init(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: Scaffold(
        body: TasbeehPresetGrid(
          onSelect: onSelect ?? (_) {},
          onCustomTap: onCustomTap ?? () {},
        ),
      ),
    ),
  );
  await tester.pump();
}
