import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/common/haptic_feedback_toggle_tile.dart';
import 'package:sana/features/azkar/presentation/widgets/common/option_tile.dart';
import 'package:sana/features/azkar/presentation/widgets/common/reading_settings_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/common/volume_button_count_toggle_tile.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  group('ReadingSettingsBottomSheet', () {
    testWidgets('renders the title and all three settings entries', (
      tester,
    ) async {
      await _open(tester);

      expect(find.text(AppStrings.azkarTasbeehSettingsTitle), findsOneWidget);
      expect(find.byType(OptionTile), findsOneWidget);
      expect(find.text(AppStrings.fontSize), findsOneWidget);
      expect(find.byType(HapticFeedbackToggleTile), findsOneWidget);
      expect(find.byType(VolumeButtonCountToggleTile), findsOneWidget);
    });

    testWidgets('font size option returns true so the caller can switch sheets', (
      tester,
    ) async {
      bool? result;
      await _open(tester, onResult: (value) => result = value);

      await tester.tap(find.text(AppStrings.fontSize));
      await tester.pumpAndSettle();

      expect(result, isTrue);
    });

    testWidgets('close icon returns null when the sheet is not nested', (
      tester,
    ) async {
      bool? result;
      await _open(tester, onResult: (value) => result = value);

      await tester.tap(find.byIcon(AppIcons.close));
      await tester.pumpAndSettle();

      expect(result, isNull);
    });

    testWidgets('back icon returns true when the sheet is nested', (
      tester,
    ) async {
      bool? result;
      await _open(tester, isNested: true, onResult: (value) => result = value);

      await tester.tap(find.byIcon(AppIcons.back));
      await tester.pumpAndSettle();

      expect(result, isTrue);
    });
  });
}

Future<void> _open(
  WidgetTester tester, {
  bool isNested = false,
  void Function(bool?)? onResult,
}) async {
  final cubit = await createLoadedSettingsCubit();

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      builder: (context, child) {
        AppSize.init(context);
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: TextButton(
              onPressed: () async {
                final result = await showModalBottomSheet<bool>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => BlocProvider<AzkarTasbeehSettingsCubit>.value(
                    value: cubit,
                    child: ReadingSettingsBottomSheet(isNested: isNested),
                  ),
                );
                onResult?.call(result);
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}
