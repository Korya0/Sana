import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/widgets/overlays/app_bottom_sheet.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings_entity.dart';
import 'package:sana/features/azkar/domain/repositories/reading_settings_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/get_reading_settings_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/update_reading_settings_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_categories/azkar_category_actions_bottom_sheet.dart';

void main() {
  testWidgets(
    'category actions sheet wraps its content instead of filling the screen',
    (tester) async {
      final cubit = _buildCubit();
      await cubit.loadSettings();
      addTearDown(cubit.close);

      await tester.pumpWidget(_app(cubit));

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      final screenHeight =
          tester.view.physicalSize.height / tester.view.devicePixelRatio;
      final sheetHeight = tester
          .getSize(find.byType(AzkarCategoryActionsBottomSheet))
          .height;

      expect(sheetHeight, lessThan(screenHeight));
    },
  );
}

ReadingSettingsCubit _buildCubit() {
  final repository = _FakeReadingSettingsRepository();
  return ReadingSettingsCubit(
    GetReadingSettingsUseCase(repository),
    UpdateReadingSettingsUseCase(repository),
  );
}

Widget _app(ReadingSettingsCubit cubit) => MaterialApp(
  theme: AppTheme.light,
  builder: (context, child) {
    AppSize.init(context);
    return Directionality(textDirection: TextDirection.rtl, child: child!);
  },
  home: Scaffold(
    body: Builder(
      builder: (context) => Center(
        child: TextButton(
          onPressed: () => AppBottomSheet.show<AzkarCategoryAction>(
            context: context,
            child: AzkarCategoryActionsBottomSheet(
              isCustom: true,
              readingSettingsCubit: cubit,
            ),
          ),
          child: const Text('open'),
        ),
      ),
    ),
  ),
);

class _FakeReadingSettingsRepository implements ReadingSettingsRepository {
  @override
  Future<Result<ReadingSettingsEntity>> getReadingSettings() async =>
      Result.success(ReadingSettingsEntity(fontSize: 20));

  @override
  Future<Result<void>> updateReadingSettings(
    ReadingSettingsEntity settings,
  ) async => const Result.success(null);
}
