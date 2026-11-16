import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/features/azkar/data/constants/tasbeeh_constants.dart';
import 'package:sana/features/azkar/presentation/widgets/tasbeeh/tasbeeh_preset_grid.dart';

void main() {
  testWidgets('shows three preset azkar and a matching custom tile', (
    tester,
  ) async {
    String? selectedPreset;
    var customPressed = false;
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
            onSelect: (text) => selectedPreset = text,
            onCustomPressed: () => customPressed = true,
          ),
        ),
      ),
    );

    expect(tasbeehPresets, hasLength(3));
    for (final preset in tasbeehPresets) {
      expect(find.text(preset), findsOneWidget);
    }
    expect(find.text(AppStrings.customTasbeeh), findsOneWidget);

    final tiles = find.byType(AppPressable);
    expect(tiles, findsNWidgets(4));

    final firstTileSize = tester.getSize(tiles.first);
    final firstTileTop = tester.getTopLeft(tiles.first).dy;
    for (var index = 1; index < 4; index++) {
      expect(tester.getSize(tiles.at(index)), firstTileSize);
      expect(tester.getTopLeft(tiles.at(index)).dy, firstTileTop);
    }

    await tester.tap(find.text(tasbeehPresets.first));
    await tester.pump(const Duration(milliseconds: 120));
    await tester.tap(find.text(AppStrings.customTasbeeh));
    await tester.pump(const Duration(milliseconds: 120));

    expect(selectedPreset, tasbeehPresets.first);
    expect(customPressed, isTrue);
  });
}
