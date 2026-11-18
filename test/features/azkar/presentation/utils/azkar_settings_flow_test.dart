import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/utils/azkar_settings_flow.dart';

import '../widgets/azkar_widget_test_harness.dart';

void main() {
  group('AzkarSettingsFlow', () {
    testWidgets('reopens options when the settings sheet reports go back', (
      tester,
    ) async {
      final cubit = await createLoadedSettingsCubit();
      var reopened = 0;

      await _pumpHost(tester, cubit: cubit);
      final context = tester.element(find.byType(_FlowHost));

      final future = AzkarSettingsFlow.openWithGoBack(
        context,
        reopenOptions: () async {
          reopened++;
        },
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip(AppStrings.back));
      await tester.pumpAndSettle();
      await future;

      expect(reopened, 1);
    });

    testWidgets('does not reopen options when the sheet is dismissed', (
      tester,
    ) async {
      final cubit = await createLoadedSettingsCubit();
      var reopened = 0;

      await _pumpHost(tester, cubit: cubit);
      final context = tester.element(find.byType(_FlowHost));

      final future = AzkarSettingsFlow.openWithGoBack(
        context,
        reopenOptions: () async {
          reopened++;
        },
      );
      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      await future;

      expect(reopened, 0);
    });
  });
}

Future<void> _pumpHost(
  WidgetTester tester, {
  required AzkarTasbeehSettingsCubit cubit,
}) async {
  await pumpAzkarWidget(
    tester,
    BlocProvider<AzkarTasbeehSettingsCubit>.value(
      value: cubit,
      child: const _FlowHost(),
    ),
    settle: true,
  );
}

class _FlowHost extends StatelessWidget {
  const _FlowHost();

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
