import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:sana/features/azkar/presentation/widgets/common/font_size_section.dart';

void main() {
  group('FontSizeSection', () {
    testWidgets('shows the section title, preview and slider', (tester) async {
      await _pump(tester, _FakeRepository());

      expect(find.text(AppStrings.fontSize), findsOneWidget);
      expect(find.text(AppStrings.fontSizePreview), findsOneWidget);
      expect(find.text(AppStrings.fontSizePreviewText), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('dragging the slider saves the new size', (tester) async {
      final repository = _FakeRepository();
      await _pump(tester, repository);

      // The slider is mirrored in RTL, so dragging left moves towards the max.
      await tester.drag(find.byType(Slider), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(repository.saved, isNotNull);
      expect(
        repository.saved!.fontSize,
        AzkarTasbeehSettingsEntity.maxFontSize,
      );
    });

    testWidgets('shows the saved size on the slider', (tester) async {
      await _pump(
        tester,
        _FakeRepository(
          settings: AzkarTasbeehSettingsEntity(fontSize: 26),
        ),
      );

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.value, 26);
    });
  });
}

Future<void> _pump(WidgetTester tester, _FakeRepository repository) async {
  final cubit = AzkarTasbeehSettingsCubit(
    GetAzkarTasbeehSettingsUseCase(repository),
    UpdateAzkarTasbeehSettingsUseCase(repository),
  );
  await cubit.loadSettings();

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      builder: (context, child) {
        AppSize.init(context);
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      home: BlocProvider<AzkarTasbeehSettingsCubit>.value(
        value: cubit,
        child: const Scaffold(
          body: SingleChildScrollView(child: FontSizeSection()),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

class _FakeRepository implements AzkarTasbeehSettingsRepository {
  _FakeRepository({this.settings});

  final AzkarTasbeehSettingsEntity? settings;
  AzkarTasbeehSettingsEntity? saved;

  @override
  Future<Result<AzkarTasbeehSettingsEntity>> getAzkarTasbeehSettings() async =>
      Result.success(settings ?? AzkarTasbeehSettingsEntity(fontSize: 20));

  @override
  Future<Result<void>> updateAzkarTasbeehSettings(
    AzkarTasbeehSettingsEntity settings,
  ) async {
    saved = settings;
    return const Result.success(null);
  }
}
