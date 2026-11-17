import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/features/azkar/domain/entities/azkar_tasbeeh_settings_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_tasbeeh_settings_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_tasbeeh_settings_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/update_azkar_tasbeeh_settings_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/common/font_size_section.dart';
import 'package:sana/features/azkar/presentation/widgets/common/azkar_tasbeeh_settings_bottom_sheet.dart';

void main() {
  group('AzkarTasbeehSettingsBottomSheet', () {
    testWidgets('renders the font size section', (tester) async {
      await _open(tester);

      expect(find.byType(FontSizeSection), findsOneWidget);
    });

    testWidgets('the back button returns true to the caller', (tester) async {
      bool? captured;
      await _open(tester, onResult: (value) => captured = value);

      await tester.tap(find.byIcon(AppIcons.back));
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      expect(captured, isTrue);
    });

    testWidgets('a failed save shows an error toast', (tester) async {
      await _open(tester, saveFailure: true);

      await tester.drag(find.byType(Slider), const Offset(60, 0));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('تعذّر حفظ الإعدادات'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
    });
  });
}

Future<void> _open(
  WidgetTester tester, {
  void Function(bool?)? onResult,
  bool saveFailure = false,
}) async {
  final repository = _FakeRepository(saveFailure: saveFailure);
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
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: TextButton(
              onPressed: () async {
                final result = await showModalBottomSheet<bool>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => AzkarTasbeehSettingsBottomSheet(
                    cubit: cubit,
                    showBackButton: true,
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

class _FakeRepository implements AzkarTasbeehSettingsRepository {
  _FakeRepository({this.saveFailure = false});

  final bool saveFailure;

  @override
  Future<Result<AzkarTasbeehSettingsEntity>> getAzkarTasbeehSettings() async =>
      Result.success(AzkarTasbeehSettingsEntity(fontSize: 20));

  @override
  Future<Result<void>> updateAzkarTasbeehSettings(
    AzkarTasbeehSettingsEntity settings,
  ) async {
    if (saveFailure) {
      return const Result.failure(
        CacheFailure(message: 'تعذّر حفظ الإعدادات'),
      );
    }
    return const Result.success(null);
  }
}
