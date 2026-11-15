import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/app_id_generator.dart';
import 'package:sana/core/utils/app_validators.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_text_button.dart';
import 'package:sana/core/widgets/inputs/app_text_field.dart';
import 'package:sana/core/widgets/overlays/app_bottom_sheet.dart';
import 'package:sana/core/widgets/overlays/app_toast.dart';
import 'package:sana/core/widgets/overlays/custom_confirmation_dialog.dart';
import 'package:sana/core/widgets/slivers/app_sliver_list.dart';
import 'package:sana/core/widgets/slivers/common_sliver_app_bar.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_state.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar/add_zikr_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar/add_zikr_fab.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar/custom_zikr_form_item_tile.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/edit_target_count_bottom_sheet.dart';

class CustomZikrFormView extends StatefulWidget {
  // Creates view
  const CustomZikrFormView({
    super.key,
    this.initialCategory,
  });

  final CustomCategoryEntity? initialCategory;

  @override
  State<CustomZikrFormView> createState() => _CustomZikrFormViewState();
}

class _CustomZikrFormViewState extends State<CustomZikrFormView> {
  final _formKey = GlobalKey<FormState>();
  final _idGenerator = AppIdGenerator();
  final ValueNotifier<bool> _isSaving = ValueNotifier(false);
  late final Listenable _saveButtonListenable;
  late final TextEditingController _nameController;
  late List<ZikrEntity> _items;
  late List<ZikrEntity> _initialItems;
  late String _initialName;
  bool _isExitDialogOpen = false;

  // Checks edit mode
  bool get _isEditing => widget.initialCategory != null;
  // Checks built-in mode
  bool get _isBuiltIn =>
      widget.initialCategory != null &&
      !widget.initialCategory!.id.startsWith(customCategoryIdPrefix);

  // Checks changes
  bool get _isDirty =>
      _nameController.text.trim() != _initialName ||
      !_listEquals(_items, _initialItems);

  // Initializes state
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
  }

  // Disposes state
  @override
  void dispose() {
    _nameController.dispose();
    _isSaving.dispose();
    super.dispose();
  }

  // Compares lists
  bool _listEquals(List<ZikrEntity> first, List<ZikrEntity> second) {
    if (first.length != second.length) return false;
    for (var index = 0; index < first.length; index++) {
      if (first[index] != second[index]) return false;
    }
    return true;
  }

  // Opens item sheet
  void _openAddZikrBottomSheet([int? editIndex]) {
    final existingItem = editIndex != null ? _items[editIndex] : null;

    unawaited(
      AppBottomSheet.show<void>(
        context: context,
        enableDrag: false,
        child: AddZikrBottomSheet(
          initialZikr: existingItem,
          nextId: () => _idGenerator.nextInt(
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

  // Edits item
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

    _openAddZikrBottomSheet(index);
  }

  // Deletes item
  Future<void> _deleteItem(int index) async {
    final zikr = _items[index];
    if (_isBuiltIn && !zikr.canBeDeleted) {
      return;
    }

    final confirmed = await CustomConfirmationDialog.show(
      context: context,
      title: AppStrings.deleteItemDialogTitle,
      message: AppStrings.deleteItemDialogMessage,
      confirmText: AppStrings.delete,
      cancelText: AppStrings.cancel,
    );

    if (confirmed == true && mounted) {
      setState(() {
        _items.removeAt(index);
      });
    }
  }

  // Handles exit
  Future<void> _handleExit() async {
    if (_isExitDialogOpen) return;

    if (!_isDirty) {
      context.popOnce();
      return;
    }

    _isExitDialogOpen = true;
    final shouldExit = await CustomConfirmationDialog.show(
      context: context,
      title: AppStrings.unsavedChangesDialogTitle,
      message: AppStrings.unsavedChangesDialogMessage,
      confirmText: AppStrings.unsavedChangesConfirm,
      cancelText: AppStrings.unsavedChangesCancel,
    );
    _isExitDialogOpen = false;

    if (shouldExit == true && mounted) {
      context.popOnce();
    }
  }

  // Saves category
  Future<void> _saveCategory(CustomAzkarCubit cubit) async {
    if (_isSaving.value) return;

    if (_isEditing && !_isDirty) {
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
    final success = await cubit.saveCustomCategory(category);
    if (!mounted || !context.mounted) return;

    if (!success) {
      // Keep the form usable so the user can retry the save.
      _isSaving.value = false;
      final message = switch (cubit.state) {
        CustomAzkarError(:final message) => message,
        _ => AppStrings.azkarSaveError,
      };
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

  // Builds view
  @override
  Widget build(BuildContext context) => BlocProvider<ReadingSettingsCubit>(
    create: (context) {
      final cubit = sl<ReadingSettingsCubit>();
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
              unawaited(_handleExit());
            },
            child: Scaffold(
              floatingActionButton: AddZikrFab(
                onPressed: () => _openAddZikrBottomSheet(),
              ),
              body: Form(
                key: _formKey,
                child: CustomScrollView(
                  slivers: [
                    // Header
                    CommonSliverAppBar(
                      title: _isEditing
                          ? AppStrings.editAzkar
                          : AppStrings.createCustomAzkar,
                      isPinned: true,
                      onBackPressed: () => unawaited(_handleExit()),
                      actions: [
                        // Save action
                        ListenableBuilder(
                          listenable: _saveButtonListenable,
                          builder: (context, _) {
                            final canSave =
                                _nameController.text.trim().isNotEmpty &&
                                (_isBuiltIn || _items.isNotEmpty) &&
                                (!_isEditing || _isDirty) &&
                                !_isSaving.value;
                            return AppTextButton(
                              label: AppStrings.save,
                              onPressed: canSave
                                  ? () => unawaited(_saveCategory(cubit))
                                  : null,
                            );
                          },
                        ),
                      ],
                    ),

                    // Body
                    // Name section
                    SliverPadding(
                      padding: AppSize.shp,
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppGap.h(AppSize.p8),

                            // Name field
                            AppTextField(
                              controller: _nameController,
                              label: AppStrings.azkarName,
                              hint: AppStrings.azkarNameHint,
                              isLocked: _isBuiltIn,
                              trailing: _isBuiltIn
                                  ? Icon(
                                      AppIcons.lock,
                                      size: AppSize.icon16,
                                      color: context.color.iconSecondary,
                                    )
                                  : null,
                              inputFormatters:
                                  AppValidators.arabicNameInputFormatters,
                              validator: (v) => AppValidators.requiredField(
                                v,
                                AppStrings.azkarNameRequired,
                              ),
                            ),
                            AppGap.h(AppSize.p16),
                          ],
                        ),
                      ),
                    ),

                    // Items section
                    SliverPadding(
                      padding: AppSize.shp,
                      sliver: AppSliverList(
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          final zikr = _items[index];
                          final canDelete = !_isBuiltIn || zikr.canBeDeleted;
                          return CustomZikrFormItemTile(
                            zikr: zikr,
                            onEdit: () => _editItem(index),
                            onDelete: canDelete
                                ? () => unawaited(_deleteItem(index))
                                : null,
                          );
                        },
                      ),
                    ),

                    // Bottom gap; keeps the last card above the add FAB.
                    SliverToBoxAdapter(
                      child: AppGap.h(AppSize.sbp + AppSize.h56),
                    ),
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
