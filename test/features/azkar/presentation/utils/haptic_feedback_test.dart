import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/utils/haptic_feedback.dart';

import '../widgets/azkar_widget_test_harness.dart';

void main() {
  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          calls.add(call);
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  testWidgets('decrement haptics respect the settings toggle', (tester) async {
    final disabledCubit = await createLoadedSettingsCubit(
      hapticFeedbackEnabled: false,
    );
    late BuildContext disabledContext;

    await pumpAzkarWidget(
      tester,
      BlocProvider<AzkarTasbeehSettingsCubit>.value(
        value: disabledCubit,
        child: Builder(
          builder: (context) {
            disabledContext = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    playDecrementHapticFeedback(disabledContext);
    await tester.pump();
    expect(_vibrations(calls), 0);

    final enabledCubit = await createLoadedSettingsCubit(
      hapticFeedbackEnabled: true,
    );
    late BuildContext enabledContext;

    await pumpAzkarWidget(
      tester,
      BlocProvider<AzkarTasbeehSettingsCubit>.value(
        value: enabledCubit,
        child: Builder(
          builder: (context) {
            enabledContext = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    playDecrementHapticFeedback(enabledContext);
    await tester.pump();
    expect(_vibrations(calls), 1);
  });
}

int _vibrations(List<MethodCall> calls) =>
    calls.where((call) => call.method == 'HapticFeedback.vibrate').length;
