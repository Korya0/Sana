import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/app_id_generator.dart';
import 'package:sana/core/utils/app_validators.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/dividers/app_divider.dart';
import 'package:sana/core/widgets/buttons/app_text_button.dart';
import 'package:sana/core/widgets/overlays/app_bottom_sheet.dart';
import 'package:sana/core/widgets/overlays/app_toast.dart';
import 'package:sana/core/widgets/overlays/custom_confirmation_dialog.dart';
import 'package:sana/core/widgets/slivers/common_sliver_app_bar.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/domain/extensions/custom_category_id_extension.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_custom_categories_use_case.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/utils/unsaved_changes_guard.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_form/custom_azkar_form_items_section.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_form/custom_azkar_form_name_section.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_form/edit_target_count_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_form/zikr_form_bottom_sheet.dart';

class CustomAzkarFormView extends StatefulWidget {
  const CustomAzkarFormView({super.key, this.initialCategory});

  final CustomCategoryEntity? initialCategory;

  @override
  State<CustomAzkarFormView> createState() => _CustomAzkarFormViewState();
}

class _CustomAzkarFormViewState extends State<CustomAzkarFormView>
    with UnsavedChangesGuard<CustomAzkarFormView> {
  final _formKey = GlobalKey<FormState>();
  final _idGenerator = AppIdGenerator();
  final ValueNotifier<bool> _isSaving = ValueNotifier(false);
  late final Listenable _saveButtonListenable;
  late final TextEditingController _nameController;
  late List<ZikrEntity> _items;
  late List<ZikrEntity> _initialItems;
  late String _initialName;
  Set<String> _existingNames = const <String>{};

  bool get _isEditing => widget.initialCategory != null;
  bool get _isBuiltIn =>
      widget.initialCategory != null &&
      !widget.initialCategory!.id.isCustomCategoryId;

  @override
  bool get isDirty =>
      _nameController.text.trim() != _initialName ||
      !_listEquals(_items, _initialItems);

  bool get canSave =>
      _validateName(_nameController.text) == null &&
      (_isBuiltIn || _items.isNotEmpty) &&
      (!_isEditing || isDirty) &&
      !_isSaving.value;

  String? _validateName(String? value) =>
      AppValidators.requiredField(value, AppStrings.azkarNameRequired) ??
      AppValidators.minLetters(
        value,
        AppConstants.minTextLength,
        AppStrings.tooShortText(AppConstants.minTextLength),
      ) ??
      AppValidators.duplicate(
        value,
        _existingNames,
        AppStrings.categoryNameDuplicate,
      );

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialCategory?.name ?? '',
    );
    _items = widget.initialCategory == null
        ? []
        : List.of(widget.initialCategory!.azkar);
    _initialItems = List.of(_items);
    _initialName = _nameController.text.trim();
    _saveButtonListenable = Listenable.merge([_nameController, _isSaving]);
    unawaited(_loadExistingNames());
  }

  Future<void> _loadExistingNames() async {
    final custom = await sl<GetCustomCategoriesUseCase>()();
    final builtIn = await sl<GetAzkarCategoriesUseCase>()();
    if (!mounted) return;

    final names = <String>{};
    if (custom is Success<List<CustomCategoryEntity>>) {
      names.addAll(
        custom.data.map((item) => AppValidators.collapseWhitespace(item.name)),
      );
    }
    if (builtIn is Success<List<AzkarCategoryEntity>>) {
      names.addAll(
        builtIn.data.map(
          (item) => AppValidators.collapseWhitespace(item.title),
        ),
      );
    }
    names.remove(AppValidators.collapseWhitespace(_initialName));

    setState(() => _existingNames = names);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _isSaving.dispose();
    super.dispose();
  }

  bool _listEquals(List<ZikrEntity> first, List<ZikrEntity> second) {
    if (first.length != second.length) return false;
    for (var index = 0; index < first.length; index++) {
      if (first[index] != second[index]) return false;
    }
    return true;
  }

  void _openZikrFormBottomSheet([int? editIndex]) {
    final existingItem = editIndex != null ? _items[editIndex] : null;

    unawaited(
      AppBottomSheet.show<void>(
        context: context,
        enableDrag: false,
        child: ZikrFormBottomSheet(
          initialZikr: existingItem,
          generateNextId: () => _idGenerator.nextInt(
            existingIds: _items.map((item) => item.id).toSet(),
          ),
          onSave: (zikr) {
            setState(() {
              if (editIndex != null) {
                _items[editIndex] = zikr;
              } else {
                _items.add(zikr);
              }
            });
          },
        ),
      ),
    );
  }

  void _editItem(int index) {
    final zikr = _items[index];
    final isBuiltInZikr = _isBuiltIn && !zikr.canBeDeleted;

    if (isBuiltInZikr) {
      unawaited(
        AppBottomSheet.show<int>(
          context: context,
          enableDrag: false,
          child: EditTargetCountBottomSheet(initialCount: zikr.count),
        ).then((newCount) {
          if (newCount != null && newCount != zikr.count && mounted) {
            setState(() {
              _items[index] = zikr.copyWith(count: newCount);
            });
          }
        }),
      );
      return;
    }

    _openZikrFormBottomSheet(index);
  }

  Future<void> _deleteItem(int index) async {
    final zikr = _items[index];
    if (_isBuiltIn && !zikr.canBeDeleted) return;

    final confirmed = await CustomConfirmationDialog.show(
      context: context,
      title: AppStrings.deleteItemDialogTitle,
      message: AppStrings.deleteItemDialogMessage,
      confirmText: AppStrings.delete,
      cancelText: AppStrings.cancel,
    );

    if (confirmed == true && mounted) {
      setState(() => _items.removeAt(index));
    }
  }

  void _reorderItems(int oldIndex, int newIndex) {
    setState(() {
      final item = _items.removeAt(oldIndex);
      _items.insert(newIndex, item);
    });
  }

  Future<void> _saveCategory(CustomAzkarCubit cubit) async {
    if (_isSaving.value) return;

    if (_isEditing && !isDirty) {
      context.popOnce();
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final id =
        widget.initialCategory?.id ??
        _idGenerator.next(prefix: customCategoryIdPrefix);
    final name = _nameController.text.trim();

    final category = CustomCategoryEntity(
      id: id,
      name: name,
      azkar: List.of(_items),
      createdAt: widget.initialCategory?.createdAt ?? DateTime.now(),
    );

    _isSaving.value = true;
    final result = await cubit.saveCustomCategory(category);
    if (!mounted || !context.mounted) return;

    if (result is FailureResult<void>) {
      // Keep the form usable so the user can retry the save.
      _isSaving.value = false;
      final message = result.failure.message;
      AppToast.show(context, message, type: AppToastType.error);
      return;
    }

    AppToast.show(
      context,
      AppStrings.azkarSavedSuccess,
      type: AppToastType.success,
    );
    context.popOnce(category);
  }

  @override
  Widget build(BuildContext context) => BlocProvider<AzkarTasbeehSettingsCubit>(
    create: (context) {
      final cubit = sl<AzkarTasbeehSettingsCubit>();
      unawaited(cubit.loadSettings());
      return cubit;
    },
    child: BlocProvider<CustomAzkarCubit>(
      create: (context) => sl<CustomAzkarCubit>(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<CustomAzkarCubit>();

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              unawaited(closeWithGuard());
            },
            child: Scaffold(
              body: Form(
                key: _formKey,
                child: CustomScrollView(
                  slivers: [
                    CommonSliverAppBar(
                      title: _isEditing
                          ? AppStrings.editAzkar
                          : AppStrings.addCustomAzkar,
                      isPinned: true,
                      onBackPressed: () => unawaited(closeWithGuard()),
                      actions: [
                        ListenableBuilder(
                          listenable: _saveButtonListenable,
                          builder: (context, _) => AppTextButton(
                            label: AppStrings.save,
                            onPressed: canSave
                                ? () => unawaited(_saveCategory(cubit))
                                : null,
                          ),
                        ),
                      ],
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: AppSize.shp.copyWith(top: AppSize.p16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppTextButton(
                                  icon: AppIcons.add,
                                  label: AppStrings.addZikr,
                                  onPressed: () =>
                                      _openZikrFormBottomSheet(),
                                ),
                                const Spacer(),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: AppSize.w88 * 2,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        AppIcons.info,
                                        size: AppSize.icon16,
                                        color: context.color.iconSecondary,
                                      ),
                                      AppGap.w(AppSize.p4),
                                      Expanded(
                                        child: Text(
                                          AppStrings.reorderZikrHint,
                                          maxLines: AppConstants.maxOneLine,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.start,
                                          style:
                                              AppTextStyles.font12W500Secondary(
                                            context,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            AppGap.h(AppSize.p8),
                            const AppDivider(),
                            AppGap.h(AppSize.p16),
                          ],
                        ),
                      ),
                    ),
                    CustomAzkarFormNameSection(
                      controller: _nameController,
                      isLocked: _isBuiltIn,
                      validator: _validateName,
                    ),
                    CustomAzkarFormItemsSection(
                      items: _items,
                      isBuiltIn: _isBuiltIn,
                      topInset: AppSize.appBarInset(context),
                      onEdit: _editItem,
                      onDelete: (index) => unawaited(_deleteItem(index)),
                      onReorder: _reorderItems,
                    ),
                    // Bottom gap
                    SliverToBoxAdapter(child: AppGap.h(AppSize.sbp)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}
