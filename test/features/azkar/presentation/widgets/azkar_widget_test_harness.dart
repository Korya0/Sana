import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/features/azkar/domain/entities/azkar_tasbeeh_settings_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_tasbeeh_settings_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_tasbeeh_settings_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/update_azkar_tasbeeh_settings_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';

Future<void> pumpAzkarWidget(
  WidgetTester tester,
  Widget child, {
  Size size = const Size(400, 900),
  bool settle = true,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      builder: (context, child) {
        AppSize.init(context);
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      home: Scaffold(body: child),
    ),
  );

  if (settle) await tester.pumpAndSettle();
}

Future<void> pumpAzkarSliver(
  WidgetTester tester,
  Widget sliver, {
  Size size = const Size(400, 900),
  bool settle = true,
}) => pumpAzkarWidget(
  tester,
  CustomScrollView(slivers: [sliver]),
  size: size,
  settle: settle,
);

Future<AzkarTasbeehSettingsCubit> createLoadedSettingsCubit({
  double fontSize = AzkarTasbeehSettingsEntity.defaultFontSize,
  bool hapticFeedbackEnabled =
      AzkarTasbeehSettingsEntity.defaultHapticFeedbackEnabled,
  bool volumeButtonCountEnabled =
      AzkarTasbeehSettingsEntity.defaultVolumeButtonCountEnabled,
}) async {
  final repository = FakeAzkarTasbeehSettingsRepository(
    AzkarTasbeehSettingsEntity(
      fontSize: fontSize,
      hapticFeedbackEnabled: hapticFeedbackEnabled,
      volumeButtonCountEnabled: volumeButtonCountEnabled,
    ),
  );
  final cubit = AzkarTasbeehSettingsCubit(
    GetAzkarTasbeehSettingsUseCase(repository),
    UpdateAzkarTasbeehSettingsUseCase(repository),
  );
  await cubit.loadSettings();
  addTearDown(cubit.close);
  return cubit;
}

class FakeAzkarTasbeehSettingsRepository
    implements AzkarTasbeehSettingsRepository {
  FakeAzkarTasbeehSettingsRepository(this.settings);

  AzkarTasbeehSettingsEntity settings;

  @override
  Future<Result<AzkarTasbeehSettingsEntity>> getAzkarTasbeehSettings() async =>
      Result.success(settings);

  @override
  Future<Result<void>> updateAzkarTasbeehSettings(
    AzkarTasbeehSettingsEntity settings,
  ) async {
    this.settings = settings;
    return const Result.success(null);
  }
}
