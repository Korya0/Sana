import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/common/volume_button_count_toggle_tile.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets('starts enabled on Android and persists a toggle', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    try {
      final cubit = await createLoadedSettingsCubit();

      await pumpAzkarWidget(
        tester,
        BlocProvider<AzkarTasbeehSettingsCubit>.value(
          value: cubit,
          child: const VolumeButtonCountToggleTile(),
        ),
      );

      expect(find.text(AppStrings.volumeButtonCount), findsOneWidget);
      expect(find.text(AppStrings.volumeButtonCountUnsupported), findsNothing);
      expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      final state = cubit.state;
      expect(state.settingsOrDefault.volumeButtonCountEnabled, isFalse);
      expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('disables the switch outside Android and explains why', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    try {
      final cubit = await createLoadedSettingsCubit(
        volumeButtonCountEnabled: true,
      );

      await pumpAzkarWidget(
        tester,
        BlocProvider<AzkarTasbeehSettingsCubit>.value(
          value: cubit,
          child: const VolumeButtonCountToggleTile(),
        ),
      );

      final toggle = tester.widget<Switch>(find.byType(Switch));
      expect(toggle.value, isFalse);
      expect(toggle.onChanged, isNull);
      expect(
        find.text(AppStrings.volumeButtonCountUnsupported),
        findsOneWidget,
      );

      await tester.tap(find.byType(Switch), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(
        cubit.state.settingsOrDefault.volumeButtonCountEnabled,
        isTrue,
      );
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });
}
