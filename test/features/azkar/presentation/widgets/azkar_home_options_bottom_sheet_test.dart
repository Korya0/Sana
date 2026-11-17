import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/features/azkar/domain/entities/azkar_tasbeeh_settings_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_tasbeeh_settings_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_tasbeeh_settings_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/update_azkar_tasbeeh_settings_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_home_options_bottom_sheet.dart';

void main() {
  group('AzkarHomeOptionsBottomSheet', () {
    testWidgets('groups the options under section titles', (tester) async {
      await _open(tester);

      expect(find.text(AppStrings.azkarTasbeehSettingsTitle), findsOneWidget);
      expect(find.text(AppStrings.customAzkar), findsOneWidget);
      expect(find.text(AppStrings.fontSize), findsOneWidget);
      expect(find.text(AppStrings.createCustomAzkar), findsOneWidget);
      expect(find.text(AppStrings.manageCustomAzkar), findsOneWidget);
    });

    testWidgets('returns the tapped option', (tester) async {
      AzkarHomeOption? captured;
      await _open(tester, onResult: (value) => captured = value);

      await tester.tap(find.text(AppStrings.fontSize));
      await tester.pumpAndSettle();

      expect(captured, AzkarHomeOption.fontSize);
    });
  });
}

Future<void> _open(
  WidgetTester tester, {
  void Function(AzkarHomeOption?)? onResult,
}) async {
  tester.view.physicalSize = const Size(400, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final cubit = _buildCubit();
  await cubit.loadSettings();
  addTearDown(cubit.close);

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
                final result = await showModalBottomSheet<AzkarHomeOption>(
                  context: context,
                  builder: (_) => AzkarHomeOptionsBottomSheet(
                    azkarTasbeehSettingsCubit: cubit,
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

AzkarTasbeehSettingsCubit _buildCubit() {
  final repository = _FakeAzkarTasbeehSettingsRepository();
  return AzkarTasbeehSettingsCubit(
    GetAzkarTasbeehSettingsUseCase(repository),
    UpdateAzkarTasbeehSettingsUseCase(repository),
  );
}

class _FakeAzkarTasbeehSettingsRepository
    implements AzkarTasbeehSettingsRepository {
  @override
  Future<Result<AzkarTasbeehSettingsEntity>> getAzkarTasbeehSettings() async =>
      Result.success(AzkarTasbeehSettingsEntity(fontSize: 20));

  @override
  Future<Result<void>> updateAzkarTasbeehSettings(
    AzkarTasbeehSettingsEntity settings,
  ) async => const Result.success(null);
}
