import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_text_button.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_bead_arc.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_bead_counter.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_preset_grid.dart';

void main() {
  testWidgets('shows the start gauge, prompt action and three presets', (
    tester,
  ) async {
    var customPressed = false;
    await _pumpGrid(
      tester,
      onCustomTap: () => customPressed = true,
    );

    expect(find.byType(TasbeehBeadArc), findsOneWidget);
    expect(find.text(AppStrings.counterValue(0)), findsNothing);
    expect(find.text(AppStrings.chooseOrAddCustomTasbeeh), findsOneWidget);
    expect(find.byIcon(AppIcons.add), findsOneWidget);
    expect(find.text(AppStrings.tasbeehPresetIstighfar), findsOneWidget);
    expect(find.text(AppStrings.tasbeehPresetAlhamdulillah), findsOneWidget);
    expect(find.text(AppStrings.tasbeehPresetSubhanAllah), findsOneWidget);

    // Prompt + three chips are the only pressables; the gauge is not.
    expect(find.byType(AppPressable), findsNWidgets(4));
    expect(tester.getSize(find.byType(TasbeehBeadCounter)).height, AppSize.h135);

    await tester.tap(find.text(AppStrings.chooseOrAddCustomTasbeeh));
    await tester.pump(const Duration(milliseconds: 120));
    expect(customPressed, isTrue);
  });

  testWidgets('each preset chip selects its tasbeeh', (tester) async {
    String? selectedPreset;
    await _pumpGrid(tester, onSelect: (text) => selectedPreset = text);

    for (final preset in [
      AppStrings.tasbeehPresetIstighfar,
      AppStrings.tasbeehPresetAlhamdulillah,
      AppStrings.tasbeehPresetSubhanAllah,
    ]) {
      await tester.tap(find.text(preset));
      await tester.pump(const Duration(milliseconds: 120));
      expect(selectedPreset, preset);
    }
  });

  testWidgets('the start gauge is not tappable', (tester) async {
    String? selectedPreset;
    var customPressed = false;
    await _pumpGrid(
      tester,
      onSelect: (text) => selectedPreset = text,
      onCustomTap: () => customPressed = true,
    );

    final gauge = tester.getRect(find.byType(TasbeehBeadCounter));
    await tester.tapAt(Offset(gauge.center.dx, gauge.top + AppSize.p8));
    await tester.pump(const Duration(milliseconds: 120));

    expect(selectedPreset, isNull);
    expect(customPressed, isFalse);
  });

  testWidgets('the prompt is a text button with no gap before the chips', (
    tester,
  ) async {
    await _pumpGrid(tester);

    final prompt = tester.widget<AppTextButton>(
      find.ancestor(
        of: find.text(AppStrings.chooseOrAddCustomTasbeeh),
        matching: find.byType(AppTextButton),
      ),
    );
    expect(prompt.onPressed, isNotNull);

    // The gauge and chips are direct children of the column: no spacer between.
    final grid = tester.widget<TasbeehPresetGrid>(
      find.byType(TasbeehPresetGrid),
    );
    expect(grid, isNotNull);
    expect(
      find.descendant(
        of: find.byType(TasbeehPresetGrid),
        matching: find.byType(AppGap),
      ),
      findsNWidgets(3),
    );
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
