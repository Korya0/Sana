import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/buttons/app_primary_button.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';
import 'package:sana/features/azkar/domain/repositories/custom_azkar_repository.dart';
import 'package:sana/features/azkar/domain/repositories/reading_settings_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_custom_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_by_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_reading_settings_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/update_reading_settings_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_item_card.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_list_content.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_list_skeleton.dart';

void main() {
  group('ZikrListContent', () {
    testWidgets('shows the skeleton before the first load', (tester) async {
      await _pump(tester, _cubit(azkar: const []));

      expect(find.byType(ZikrListSkeleton), findsOneWidget);
    });

    testWidgets('shows the empty message for an empty category', (
      tester,
    ) async {
      final cubit = _cubit(azkar: const []);
      await cubit.loadAzkar('morning', categoryTitle: 'أذكار الصباح');

      await _pump(tester, cubit);

      expect(find.text(AppStrings.azkarEmpty), findsOneWidget);
    });

    testWidgets('shows the error message and retries', (tester) async {
      final cubit = _cubit(azkar: const [], failure: true);
      await cubit.loadAzkar('morning', categoryTitle: 'أذكار الصباح');
      var retries = 0;

      await _pump(tester, cubit, onRetry: () => retries++);

      expect(find.text('تعذّر التحميل'), findsOneWidget);

      final retryButton = find.widgetWithText(
        AppPrimaryButton,
        AppStrings.tryAgain,
      );
      await tester.ensureVisible(retryButton);
      await tester.tap(retryButton);
      await tester.pump(const Duration(milliseconds: 150));

      expect(retries, 1);
    });

    testWidgets('renders a card per zikr', (tester) async {
      final cubit = _cubit(
        azkar: const [
          ZikrEntity(id: 1, text: 'سبحان الله', count: 33),
          ZikrEntity(id: 2, text: 'الحمد لله', count: 33),
        ],
      );
      await cubit.loadAzkar('morning', categoryTitle: 'أذكار الصباح');

      await _pump(tester, cubit);

      expect(find.byType(ZikrItemCard), findsNWidgets(2));
    });

    testWidgets('copies the category, zikr, and virtue as formatted text', (
      tester,
    ) async {
      String? clipboardText;
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      messenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            final arguments = call.arguments as Map<Object?, Object?>;
            clipboardText = arguments['text'] as String?;
          }
          return null;
        },
      );
      addTearDown(
        () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
      );

      final cubit = _cubit(
        azkar: const [
          ZikrEntity(
            id: 1,
            text: 'اللهم بارك لهما',
            count: 1,
            description: 'فضل الذكر',
          ),
        ],
      );
      await cubit.loadAzkar('marriage', categoryTitle: 'أذكار الزواج');
      await _pump(tester, cubit);

      await tester.tap(find.byIcon(AppIcons.copy));
      await tester.pumpAndSettle();

      expect(
        clipboardText,
        AppStrings.zikrCopyText(
          categoryTitle: 'أذكار الزواج',
          zikrText: 'اللهم بارك لهما',
          description: 'فضل الذكر',
        ),
      );
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });
  });
}

Future<void> _pump(
  WidgetTester tester,
  AzkarCubit cubit, {
  VoidCallback? onRetry,
}) => tester.pumpWidget(
  MaterialApp(
    theme: AppTheme.light,
    builder: (context, child) {
      AppSize.init(context);
      return Directionality(textDirection: TextDirection.rtl, child: child!);
    },
    home: MultiBlocProvider(
      providers: [
        BlocProvider.value(value: cubit),
        BlocProvider.value(value: _settingsCubit()),
      ],
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            ZikrListContent(
              categoryKey: 'test-category',
              onRetry: onRetry ?? () {},
            ),
          ],
        ),
      ),
    ),
  ),
);

AzkarCubit _cubit({required List<ZikrEntity> azkar, bool failure = false}) {
  final customRepository = _FakeCustomAzkarRepository();
  final azkarRepository = _FakeAzkarRepository(
    azkar: azkar,
    failure: failure,
  );

  return AzkarCubit(
    GetAzkarByCategoryUseCase(azkarRepository),
    GetAzkarCategoriesUseCase(azkarRepository),
    DeleteCustomCategoryUseCase(customRepository),
    customRepository,
  );
}

ReadingSettingsCubit _settingsCubit() {
  final repository = _FakeReadingSettingsRepository();

  return ReadingSettingsCubit(
    GetReadingSettingsUseCase(repository),
    UpdateReadingSettingsUseCase(repository),
  );
}

class _FakeAzkarRepository implements AzkarRepository {
  _FakeAzkarRepository({required this.azkar, this.failure = false});

  final List<ZikrEntity> azkar;
  final bool failure;

  @override
  Future<Result<List<AzkarCategoryEntity>>> getCategories() async =>
      const Result.success([]);

  @override
  Future<Result<List<ZikrEntity>>> getAzkarByCategory(
    String categoryKey,
  ) async {
    if (failure) {
      return const Result.failure(CacheFailure(message: 'تعذّر التحميل'));
    }
    return Result.success(azkar);
  }
}

class _FakeCustomAzkarRepository implements CustomAzkarRepository {
  @override
  Future<Result<void>> deleteCustomCategory(String id) async =>
      const Result.success(null);

  @override
  Future<Result<CustomCategoryEntity?>> getCustomCategoryById(
    String id,
  ) async => const Result.success(null);

  @override
  Future<Result<List<CustomCategoryEntity>>> getCustomCategories() async =>
      const Result.success([]);

  @override
  Future<Result<void>> saveCustomCategory(
    CustomCategoryEntity category,
  ) async => const Result.success(null);
}

class _FakeReadingSettingsRepository implements ReadingSettingsRepository {
  @override
  Future<Result<ReadingSettingsEntity>> getReadingSettings() async =>
      Result.success(ReadingSettingsEntity(fontSize: 20));

  @override
  Future<Result<void>> updateReadingSettings(
    ReadingSettingsEntity settings,
  ) async => const Result.success(null);
}
