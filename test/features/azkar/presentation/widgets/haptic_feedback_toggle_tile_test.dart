import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/common/haptic_feedback_toggle_tile.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets('shows the saved state and persists a toggle', (tester) async {
    final cubit = await createLoadedSettingsCubit(hapticFeedbackEnabled: true);

    await pumpAzkarWidget(
      tester,
      BlocProvider<AzkarTasbeehSettingsCubit>.value(
        value: cubit,
        child: const HapticFeedbackToggleTile(),
      ),
    );

    expect(find.text(AppStrings.hapticFeedback), findsOneWidget);
    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
    expect(cubit.state.settingsOrDefault.hapticFeedbackEnabled, isFalse);
  });
}
