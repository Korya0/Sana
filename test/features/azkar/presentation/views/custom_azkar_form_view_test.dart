import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/buttons/app_text_button.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/azkar_tasbeeh_settings_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';
import 'package:sana/features/azkar/domain/repositories/custom_category_repository.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_tasbeeh_settings_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_custom_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_custom_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_tasbeeh_settings_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/save_custom_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/update_azkar_tasbeeh_settings_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/views/custom_azkar_form_view.dart';
import 'package:sana/features/azkar/presentation/widgets/common/reading_text_content.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_form/custom_azkar_form_items_section.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_form/edit_target_count_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_form/zikr_form_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_form/zikr_form_item_tile.dart';
import 'package:toastification/toastification.dart';

void main() {
  late _FakeCustomCategoryRepository customRepository;
  late _FakeAzkarRepository azkarRepository;

  setUp(() {
    customRepository = _FakeCustomCategoryRepository();
    azkarRepository = _FakeAzkarRepository();
    sl.registerFactory<CustomAzkarCubit>(
      () => _buildCubit(customRepository, azkarRepository),
    );
    sl.registerFactory<AzkarTasbeehSettingsCubit>(
      _buildAzkarTasbeehSettingsCubit,
    );
    sl.registerFactory<GetCustomCategoriesUseCase>(
      () => GetCustomCategoriesUseCase(customRepository),
    );
    sl.registerFactory<GetAzkarCategoriesUseCase>(
      () => GetAzkarCategoriesUseCase(azkarRepository),
    );
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets(
    'save stays disabled until a name and at least one zikr exist',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_app(const CustomAzkarFormView()));

      // Initially the name is empty and there are no azkar.
      expect(_saveButton(tester).onPressed, isNull);

      // A name alone is not enough.
      await tester.enterText(find.byType(TextField).first, 'قسمي');
      await tester.pump();
      expect(_saveButton(tester).onPressed, isNull);

      // Add a zikr through the floating button.
      await tester.tap(find.byIcon(AppIcons.add));
      await tester.pumpAndSettle();

      final sheetFields = find.descendant(
        of: find.byType(ZikrFormBottomSheet),
        matching: find.byType(TextField),
      );
      expect(sheetFields, findsNWidgets(3));

      await tester.enterText(sheetFields.at(0), 'سبحان الله');
      await tester.enterText(sheetFields.at(2), '33');
      final sheetSave = find.descendant(
        of: find.byType(ZikrFormBottomSheet),
        matching: find.widgetWithText(AppTextButton, AppStrings.save),
      );
      await tester.ensureVisible(sheetSave);
      await tester.pumpAndSettle();
      await tester.tap(sheetSave);
      await tester.pumpAndSettle();

      // Name + one zikr enables save.
      expect(_saveButton(tester).onPressed, isNotNull);
    },
  );

  testWidgets(
    'save stays disabled in edit mode until a value changes',
    (tester) async {
      const category = CustomCategoryEntity(
        id: 'custom_1',
        name: 'قسمي',
        azkar: [
          ZikrEntity(id: 1, text: 'سبحان الله', count: 33, isUserAdded: true),
        ],
      );

      await tester.pumpWidget(
        _app(const CustomAzkarFormView(initialCategory: category)),
      );

      // Nothing changed yet.
      expect(_saveButton(tester).onPressed, isNull);

      // Changing the name enables save.
      await tester.enterText(find.byType(TextField).first, 'قسمي جديد');
      await tester.pump();
      expect(_saveButton(tester).onPressed, isNotNull);

      // Reverting the change disables save again.
      await tester.enterText(find.byType(TextField).first, 'قسمي');
      await tester.pump();
      expect(_saveButton(tester).onPressed, isNull);
    },
  );

  testWidgets('the zikr preview uses the saved font size', (tester) async {
    const category = CustomCategoryEntity(
      id: 'custom_1',
      name: 'قسمي',
      azkar: [
        ZikrEntity(id: 1, text: 'سبحان الله', count: 33, isUserAdded: true),
      ],
    );

    await tester.pumpWidget(
      _app(const CustomAzkarFormView(initialCategory: category)),
    );
    await tester.pumpAndSettle();

    final content = tester.widget<ReadingTextContent>(
      find.byType(ReadingTextContent),
    );
    expect(content.fontSize, 26);
  });

  testWidgets('names from custom and built-in categories are treated as '
      'duplicates', (tester) async {
    customRepository.categories = const [
      CustomCategoryEntity(id: 'custom_other', name: 'أذكار الصباح', azkar: []),
    ];
    azkarRepository.categories = const [
      AzkarCategoryEntity(
        key: 'builtin',
        title: 'أذكار المساء',
        cardTitle: 'أذكار المساء',
      ),
    ];

    await _pumpForm(tester, const CustomAzkarFormView());
    await _addZikr(tester);

    for (final duplicate in ['أذكار المساء', 'أذكار الصباح']) {
      await tester.enterText(_nameField(tester), duplicate);
      await tester.pump();
      await tester.tap(_saveFinder(tester));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.categoryNameDuplicate), findsOneWidget);
    }
    expect(customRepository.saves, isEmpty);
  });

  testWidgets('editing an existing zikr replaces it and marks the form dirty', (
    tester,
  ) async {
    const category = CustomCategoryEntity(
      id: 'custom_1',
      name: 'قسمي',
      azkar: [
        ZikrEntity(id: 1, text: 'سبحان الله', count: 33, isUserAdded: true),
      ],
    );
    await _pumpForm(
      tester,
      const CustomAzkarFormView(initialCategory: category),
    );
    expect(_saveButton(tester).onPressed, isNull);

    await _openTileAction(tester, 0, AppStrings.editZikr);
    expect(find.byType(ZikrFormBottomSheet), findsOneWidget);

    final sheetFields = find.descendant(
      of: find.byType(ZikrFormBottomSheet),
      matching: find.byType(TextField),
    );
    await tester.enterText(sheetFields.at(0), 'الحمد لله');
    await _tapSheetSave(tester, find.byType(ZikrFormBottomSheet));

    expect(find.text('الحمد لله'), findsOneWidget);
    expect(find.text('سبحان الله'), findsNothing);
    expect(_saveButton(tester).onPressed, isNotNull);
  });

  testWidgets('a built-in category locks its name and only edits the target '
      'count of its original zikrs', (tester) async {
    const category = CustomCategoryEntity(
      id: 'builtin_1',
      name: 'قسمي',
      azkar: [ZikrEntity(id: 1, text: 'سبحان الله', count: 33)],
    );
    await _pumpForm(
      tester,
      const CustomAzkarFormView(initialCategory: category),
    );

    expect(find.byIcon(AppIcons.lock), findsOneWidget);
    expect(tester.widget<TextField>(_nameField(tester)).readOnly, isTrue);

    // Saving the same count leaves the form untouched.
    await _openTileAction(tester, 0, AppStrings.editZikr);
    expect(find.byType(EditTargetCountBottomSheet), findsOneWidget);
    await _tapSheetSave(tester, find.byType(EditTargetCountBottomSheet));
    expect(_saveButton(tester).onPressed, isNull);

    // A new count is written back to the zikr.
    await _openTileAction(tester, 0, AppStrings.editZikr);
    final countField = find.descendant(
      of: find.byType(EditTargetCountBottomSheet),
      matching: find.byType(TextField),
    );
    await tester.enterText(countField, '15');
    await _tapSheetSave(tester, find.byType(EditTargetCountBottomSheet));

    expect(_saveButton(tester).onPressed, isNotNull);
    final item = tester
        .widget<CustomAzkarFormItemsSection>(
          find.byType(CustomAzkarFormItemsSection),
        )
        .items
        .single;
    expect(item.count, 15);
  });

  testWidgets('deleting a built-in user-added zikr asks for confirmation', (
    tester,
  ) async {
    const category = CustomCategoryEntity(
      id: 'builtin_1',
      name: 'قسمي',
      azkar: [
        ZikrEntity(id: 1, text: 'مضاف', count: 1, isUserAdded: true),
      ],
    );
    await _pumpForm(
      tester,
      const CustomAzkarFormView(initialCategory: category),
    );

    // Cancelling keeps the item.
    await _openTileAction(tester, 0, AppStrings.deleteZikr);
    await tester.tap(find.text(AppStrings.cancel));
    await tester.pumpAndSettle();
    expect(find.text('مضاف'), findsOneWidget);
    expect(_saveButton(tester).onPressed, isNull);

    // Confirming removes it.
    await _openTileAction(tester, 0, AppStrings.deleteZikr);
    await tester.tap(find.text(AppStrings.delete));
    await tester.pumpAndSettle();
    expect(find.text('مضاف'), findsNothing);
    expect(_saveButton(tester).onPressed, isNotNull);
  });

  testWidgets('a locked built-in zikr cannot be deleted', (tester) async {
    const category = CustomCategoryEntity(
      id: 'builtin_1',
      name: 'قسمي',
      azkar: [ZikrEntity(id: 1, text: 'أصلي', count: 3)],
    );
    await _pumpForm(
      tester,
      const CustomAzkarFormView(initialCategory: category),
    );

    await tester.tap(_tileInfo(tester, 0));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.deleteZikr), findsNothing);

    // Even when the items-section delete callback is invoked directly the
    // view must refuse to remove a locked built-in zikr.
    final section = tester.widget<CustomAzkarFormItemsSection>(
      find.byType(CustomAzkarFormItemsSection),
    );
    section.onDelete(0);
    await tester.pumpAndSettle();

    expect(find.text('أصلي'), findsOneWidget);
    expect(_saveButton(tester).onPressed, isNull);
  });

  testWidgets('reordering zikrs changes their order and enables save', (
    tester,
  ) async {
    const category = CustomCategoryEntity(
      id: 'custom_1',
      name: 'قسمي',
      azkar: [
        ZikrEntity(id: 1, text: 'الأول', count: 3, isUserAdded: true),
        ZikrEntity(id: 2, text: 'الثاني', count: 3, isUserAdded: true),
        ZikrEntity(id: 3, text: 'الثالث', count: 3, isUserAdded: true),
      ],
    );
    await _pumpForm(
      tester,
      const CustomAzkarFormView(initialCategory: category),
    );

    final start = tester.getCenter(find.text('الأول'));
    final end = tester.getCenter(find.text('الثالث'));
    final gesture = await tester.startGesture(start);
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump();
    await gesture.moveTo(end);
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    await gesture.up();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    final items = tester
        .widget<CustomAzkarFormItemsSection>(
          find.byType(CustomAzkarFormItemsSection),
        )
        .items;
    expect(
      items.map((zikr) => zikr.text).toList(),
      isNot(['الأول', 'الثاني', 'الثالث']),
    );
    expect(_saveButton(tester).onPressed, isNotNull);
  });

  testWidgets('a failed save shows an error toast and keeps the form usable', (
    tester,
  ) async {
    const failureMessage = 'تعذّر الحفظ التجريبي';
    customRepository
      ..failSave = true
      ..failureMessage = failureMessage;
    var didPop = false;

    await _pumpForm(
      tester,
      const CustomAzkarFormView(),
      onPopped: (_) => didPop = true,
    );
    await tester.enterText(_nameField(tester), 'قسمي');
    await _addZikr(tester);

    await tester.tap(_saveFinder(tester));
    await tester.pumpAndSettle();

    expect(find.text(failureMessage), findsOneWidget);
    expect(_saveButton(tester).onPressed, isNotNull);
    expect(didPop, isFalse);
    expect(customRepository.saves, isEmpty);

    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('saving an unchanged edit pops without saving', (tester) async {
    const category = CustomCategoryEntity(
      id: 'custom_1',
      name: 'قسمي',
      azkar: [
        ZikrEntity(id: 1, text: 'سبحان الله', count: 33, isUserAdded: true),
      ],
    );
    var didPop = false;
    await _pumpForm(
      tester,
      const CustomAzkarFormView(initialCategory: category),
      onPopped: (_) => didPop = true,
    );

    // Capture the enabled save action while the form is dirty.
    await tester.enterText(_nameField(tester), 'قسمي جديد');
    await tester.pump();
    final enabledSave = _saveButton(tester).onPressed!;

    // Revert the name, then invoke the still-live callback: the form must
    // short-circuit because it is no longer dirty.
    await tester.enterText(_nameField(tester), 'قسمي');
    await tester.pump();
    enabledSave();
    await tester.pumpAndSettle();

    expect(didPop, isTrue);
    expect(customRepository.saves, isEmpty);
  });

  testWidgets('the back button pops a clean form immediately', (tester) async {
    const category = CustomCategoryEntity(
      id: 'custom_1',
      name: 'قسمي',
      azkar: [
        ZikrEntity(id: 1, text: 'سبحان الله', count: 33, isUserAdded: true),
      ],
    );
    var didPop = false;
    await _pumpForm(
      tester,
      const CustomAzkarFormView(initialCategory: category),
      onPopped: (_) => didPop = true,
    );

    await tester.tap(find.byTooltip(AppStrings.back));
    await tester.pumpAndSettle();

    expect(didPop, isTrue);
    expect(find.byType(CustomAzkarFormView), findsNothing);
  });

  testWidgets('the back button and system pop guard unsaved changes', (
    tester,
  ) async {
    const category = CustomCategoryEntity(
      id: 'custom_1',
      name: 'قسمي',
      azkar: [
        ZikrEntity(id: 1, text: 'سبحان الله', count: 33, isUserAdded: true),
      ],
    );
    var didPop = false;
    await _pumpForm(
      tester,
      const CustomAzkarFormView(initialCategory: category),
      onPopped: (_) => didPop = true,
    );

    await tester.enterText(_nameField(tester), 'قسمي جديد');
    await tester.tap(find.byTooltip(AppStrings.back));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.unsavedChangesDialogTitle), findsOneWidget);

    await tester.tap(find.text(AppStrings.unsavedChangesCancel));
    await tester.pumpAndSettle();
    expect(didPop, isFalse);
    expect(find.byType(CustomAzkarFormView), findsOneWidget);

    // PopScope routes system back through the same guard.
    final formContext = tester.element(find.byType(CustomAzkarFormView));
    Navigator.of(formContext).maybePop();
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.unsavedChangesDialogTitle), findsOneWidget);

    await tester.tap(find.text(AppStrings.unsavedChangesConfirm));
    await tester.pumpAndSettle();
    expect(didPop, isTrue);
  });
}

Widget _app(Widget home) => MaterialApp(
  theme: AppTheme.light,
  builder: (context, child) {
    AppSize.init(context);
    return Directionality(textDirection: TextDirection.rtl, child: child!);
  },
  home: home,
);

Future<void> _pumpForm(
  WidgetTester tester,
  Widget form, {
  void Function(Object?)? onPopped,
}) async {
  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ToastificationWrapper(
      child: _app(
        Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: TextButton(
                onPressed: () async {
                  final result = await Navigator.of(context).push<Object?>(
                    MaterialPageRoute<Object?>(builder: (_) => form),
                  );
                  onPopped?.call(result);
                },
                child: const Text('open form'),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.text('open form'));
  await tester.pumpAndSettle();
}

Finder _nameField(WidgetTester tester) => find.byType(TextField).first;

Finder _tileInfo(WidgetTester tester, int index) => find
    .descendant(
      of: find.byType(ZikrFormItemTile),
      matching: find.byIcon(AppIcons.info),
    )
    .at(index);

Future<void> _openTileAction(
  WidgetTester tester,
  int index,
  String label,
) async {
  await tester.tap(_tileInfo(tester, index));
  await tester.pumpAndSettle();
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}

Future<void> _tapSheetSave(WidgetTester tester, Finder sheet) async {
  final save = find.descendant(
    of: sheet,
    matching: find.widgetWithText(AppTextButton, AppStrings.save),
  );
  await tester.ensureVisible(save);
  await tester.pumpAndSettle();
  await tester.tap(save);
  await tester.pumpAndSettle();
}

Future<void> _addZikr(
  WidgetTester tester, {
  String text = 'سبحان الله',
  String count = '33',
}) async {
  await tester.tap(find.byIcon(AppIcons.add));
  await tester.pumpAndSettle();

  final sheetFields = find.descendant(
    of: find.byType(ZikrFormBottomSheet),
    matching: find.byType(TextField),
  );
  await tester.enterText(sheetFields.at(0), text);
  await tester.enterText(sheetFields.at(2), count);
  await _tapSheetSave(tester, find.byType(ZikrFormBottomSheet));
}

Finder _saveFinder(WidgetTester tester) =>
    find.widgetWithText(AppTextButton, AppStrings.save);

AppTextButton _saveButton(WidgetTester tester) =>
    tester.widget<AppTextButton>(_saveFinder(tester));

CustomAzkarCubit _buildCubit(
  _FakeCustomCategoryRepository customRepository,
  _FakeAzkarRepository azkarRepository,
) {
  return CustomAzkarCubit(
    getCustomCategoriesUseCase: GetCustomCategoriesUseCase(customRepository),
    saveCustomCategoryUseCase: SaveCustomCategoryUseCase(customRepository),
    deleteCustomCategoryUseCase: DeleteCustomCategoryUseCase(customRepository),
    getAzkarCategoriesUseCase: GetAzkarCategoriesUseCase(azkarRepository),
  );
}

AzkarTasbeehSettingsCubit _buildAzkarTasbeehSettingsCubit() {
  final repository = _FakeAzkarTasbeehSettingsRepository();
  return AzkarTasbeehSettingsCubit(
    GetAzkarTasbeehSettingsUseCase(repository),
    UpdateAzkarTasbeehSettingsUseCase(repository),
  );
}

class _FakeAzkarRepository implements AzkarRepository {
  List<AzkarCategoryEntity> categories = const [];

  @override
  Future<Result<List<AzkarCategoryEntity>>> getCategories() async =>
      Result.success(categories);

  @override
  Future<Result<List<ZikrEntity>>> getZikrsByCategory(
    String categoryKey,
  ) async => const Result.success([]);
}

class _FakeAzkarTasbeehSettingsRepository
    implements AzkarTasbeehSettingsRepository {
  @override
  Future<Result<AzkarTasbeehSettingsEntity>> getAzkarTasbeehSettings() async =>
      Result.success(AzkarTasbeehSettingsEntity(fontSize: 26));

  @override
  Future<Result<void>> updateAzkarTasbeehSettings(
    AzkarTasbeehSettingsEntity settings,
  ) async => const Result.success(null);
}

class _FakeCustomCategoryRepository implements CustomCategoryRepository {
  List<CustomCategoryEntity> categories = [];
  final List<CustomCategoryEntity> saves = [];
  bool failSave = false;
  String failureMessage = 'تعذّر الحفظ';

  @override
  Future<Result<void>> deleteCustomCategory(String id) async {
    categories = categories.where((c) => c.id != id).toList();
    return const Result.success(null);
  }

  @override
  Future<Result<CustomCategoryEntity?>> getCustomCategoryById(String id) async {
    for (final category in categories) {
      if (category.id == id) return Result.success(category);
    }
    return const Result.success(null);
  }

  @override
  Future<Result<List<CustomCategoryEntity>>> getCustomCategories() async =>
      Result.success(categories);

  @override
  Future<Result<void>> saveCustomCategory(
    CustomCategoryEntity category,
  ) async {
    if (failSave) {
      return Result.failure(CacheFailure(message: failureMessage));
    }
    saves.add(category);
    categories = [
      ...categories.where((c) => c.id != category.id),
      category,
    ];
    return const Result.success(null);
  }
}
