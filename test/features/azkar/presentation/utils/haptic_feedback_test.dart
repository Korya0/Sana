import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/azkar_tasbeeh_settings_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_tasbeeh_settings_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_tasbeeh_settings_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/update_azkar_tasbeeh_settings_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/common/counter_increment_result.dart';
import 'package:sana/features/azkar/presentation/utils/haptic_feedback.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('playIncrementHapticFeedback', () {
    late List<MethodCall> hapticCalls;
    late TestDefaultBinaryMessenger messenger;

    setUp(() {
      hapticCalls = [];
      messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
        if (call.method == 'HapticFeedback.vibrate') {
          hapticCalls.add(call);
        }
        return null;
      });
    });

    tearDown(() {
      messenger.setMockMethodCallHandler(SystemChannels.platform, null);
    });

    testWidgets('does nothing when the result is ignored', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
      final context = tester.element(find.byType(SizedBox));

      playIncrementHapticFeedback(context, const CounterIgnored());
      await tester.pump();

      expect(hapticCalls, isEmpty);
    });

    testWidgets('does nothing when haptic feedback is disabled', (
      tester,
    ) async {
      final cubit = await _settingsCubit(hapticFeedbackEnabled: false);
      addTearDown(cubit.close);

      await tester.pumpWidget(
        BlocProvider<AzkarTasbeehSettingsCubit>.value(
          value: cubit,
          child: const MaterialApp(home: SizedBox.shrink()),
        ),
      );
      final context = tester.element(find.byType(SizedBox));

      playIncrementHapticFeedback(context, const CounterIncremented());
      await tester.pump();

      expect(hapticCalls, isEmpty);
    });

    testWidgets('plays a light impact when incremented', (tester) async {
      final cubit = await _settingsCubit(hapticFeedbackEnabled: true);
      addTearDown(cubit.close);

      await tester.pumpWidget(
        BlocProvider<AzkarTasbeehSettingsCubit>.value(
          value: cubit,
          child: const MaterialApp(home: SizedBox.shrink()),
        ),
      );
      final context = tester.element(find.byType(SizedBox));

      playIncrementHapticFeedback(context, const CounterIncremented());
      await tester.pump();

      expect(hapticCalls, hasLength(1));
      expect(hapticCalls.single.arguments, 'HapticFeedbackType.mediumImpact');
    });

    testWidgets('plays light and double-tap haptics when completed', (
      tester,
    ) async {
      final cubit = await _settingsCubit(hapticFeedbackEnabled: true);
      addTearDown(cubit.close);

      await tester.pumpWidget(
        BlocProvider<AzkarTasbeehSettingsCubit>.value(
          value: cubit,
          child: const MaterialApp(home: SizedBox.shrink()),
        ),
      );
      final context = tester.element(find.byType(SizedBox));

      playIncrementHapticFeedback(context, const CounterCompleted());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(hapticCalls.length, 3);
      expect(hapticCalls[0].arguments, 'HapticFeedbackType.mediumImpact');
      expect(hapticCalls[1].arguments, 'HapticFeedbackType.heavyImpact');
      expect(hapticCalls[2].arguments, 'HapticFeedbackType.heavyImpact');
    });

    testWidgets(
      'uses default settings when cubit state has no saved settings',
      (
        tester,
      ) async {
        final cubit = _initialSettingsCubit();
        addTearDown(cubit.close);

        await tester.pumpWidget(
          BlocProvider<AzkarTasbeehSettingsCubit>.value(
            value: cubit,
            child: const MaterialApp(home: SizedBox.shrink()),
          ),
        );
        final context = tester.element(find.byType(SizedBox));

        playIncrementHapticFeedback(context, const CounterIncremented());
        await tester.pump();

        expect(hapticCalls, hasLength(1));
        expect(hapticCalls.single.arguments, 'HapticFeedbackType.mediumImpact');
      },
    );
  });
}

Future<AzkarTasbeehSettingsCubit> _settingsCubit({
  required bool hapticFeedbackEnabled,
}) async {
  final repository = _FakeAzkarTasbeehSettingsRepository(
    AzkarTasbeehSettingsEntity(
      fontSize: AzkarTasbeehSettingsEntity.defaultFontSize,
      hapticFeedbackEnabled: hapticFeedbackEnabled,
    ),
  );
  final cubit = AzkarTasbeehSettingsCubit(
    GetAzkarTasbeehSettingsUseCase(repository),
    UpdateAzkarTasbeehSettingsUseCase(repository),
  );
  await cubit.loadSettings();
  return cubit;
}

AzkarTasbeehSettingsCubit _initialSettingsCubit() {
  final repository = _FakeAzkarTasbeehSettingsRepository(
    AzkarTasbeehSettingsEntity(fontSize: 20),
  );
  return AzkarTasbeehSettingsCubit(
    GetAzkarTasbeehSettingsUseCase(repository),
    UpdateAzkarTasbeehSettingsUseCase(repository),
  );
}

class _FakeAzkarTasbeehSettingsRepository
    implements AzkarTasbeehSettingsRepository {
  _FakeAzkarTasbeehSettingsRepository(this.settings);

  final AzkarTasbeehSettingsEntity settings;

  @override
  Future<Result<AzkarTasbeehSettingsEntity>> getAzkarTasbeehSettings() async =>
      Result.success(settings);

  @override
  Future<Result<void>> updateAzkarTasbeehSettings(
    AzkarTasbeehSettingsEntity settings,
  ) async => const Result.success(null);
}
