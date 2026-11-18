import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/buttons/app_button.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_bead_arc.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_bead_counter.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_preset_grid.dart';

void main() {
  testWidgets('shows the start gauge and both actions', (tester) async {
    String? selectedPreset;
    var customPressed = false;
    await _pumpGrid(
      tester,
      onSelect: (text) => selectedPreset = text,
      onCustomTap: () => customPressed = true,
    );

    expect(find.byType(TasbeehBeadArc), findsOneWidget);
    expect(find.text(AppStrings.counterValue(0)), findsOneWidget);
    expect(find.text(AppStrings.chooseTasbeehToStart), findsOneWidget);
    expect(find.text(AppStrings.tasbeehPresetIstighfar), findsOneWidget);
    expect(find.text(AppStrings.customTasbeeh), findsOneWidget);
    expect(find.byIcon(AppIcons.play), findsOneWidget);
    expect(find.byIcon(AppIcons.add), findsOneWidget);

    final buttons = find.byType(AppButton);
    expect(buttons, findsNWidgets(2));
    expect(tester.getSize(buttons.at(0)).height, AppSize.h48);
    expect(tester.getSize(buttons.at(1)).height, AppSize.h48);

    // One gauge target and two action buttons.
    expect(find.byType(AppPressable), findsNWidgets(3));
    expect(tester.getSize(find.byType(TasbeehBeadCounter)).height, AppSize.h135);

    await tester.tap(find.text(AppStrings.tasbeehPresetIstighfar));
    await tester.pump(const Duration(milliseconds: 120));
    await tester.tap(find.text(AppStrings.customTasbeeh));
    await tester.pump(const Duration(milliseconds: 120));

    expect(selectedPreset, AppStrings.tasbeehPresetIstighfar);
    expect(customPressed, isTrue);
  });

  testWidgets('the gauge starts the preset tasbeeh', (tester) async {
    String? selectedPreset;
    await _pumpGrid(tester, onSelect: (text) => selectedPreset = text);

    await tester.tap(find.byType(TasbeehBeadCounter));
    await tester.pump(const Duration(milliseconds: 120));

    expect(selectedPreset, AppStrings.tasbeehPresetIstighfar);
  });

  testWidgets('the start subtitle is a one-line secondary label', (
    tester,
  ) async {
    await _pumpGrid(tester);

    final subtitle = tester.widget<Text>(
      find.text(AppStrings.chooseTasbeehToStart),
    );
    expect(subtitle.maxLines, 1);
    expect(subtitle.overflow, TextOverflow.ellipsis);
    expect(subtitle.style?.fontSize, AppSize.f14);
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
