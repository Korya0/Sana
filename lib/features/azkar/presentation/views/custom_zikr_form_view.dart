import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/theme/colors/app_colors_common.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/app_validators.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/core/widgets/buttons/app_primary_button.dart';
import 'package:sana/core/widgets/buttons/app_secondary_button.dart';
import 'package:sana/core/widgets/buttons/app_text_button.dart';
import 'package:sana/core/widgets/cards/app_section_card.dart';
import 'package:sana/core/widgets/dividers/custom_app_divider.dart';
import 'package:sana/core/widgets/inputs/app_text_field.dart';
import 'package:sana/core/widgets/overlays/app_bottom_sheet.dart';
import 'package:sana/core/widgets/overlays/app_toast.dart';
import 'package:sana/core/widgets/overlays/custom_confirmation_dialog.dart';
import 'package:sana/core/widgets/slivers/app_sliver_list.dart';
import 'package:sana/core/widgets/slivers/common_sliver_app_bar.dart';
import 'package:sana/features/azkar/data/data_sources/azkar_local_data_source.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar/add_zikr_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/edit_target_count_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_content.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_counter.dart';

class CustomZikrFormView extends StatefulWidget {
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
  late final TextEditingController _nameController;
  late List<ZikrEntity> _items;
  List<ZikrEntity> _allCategoryItems = [];
  Map<int, int> _originalCounts = {};
  bool _isLoadingBuiltIn = false;

  bool get _isEditing => widget.initialCategory != null;
  bool get _isBuiltIn =>
      widget.initialCategory != null &&
      !widget.initialCategory!.id.startsWith('custom_');

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialCategory?.name ?? '',
    );
    if (widget.initialCategory != null) {
      _allCategoryItems = List.of(widget.initialCategory!.azkar);
      if (_isBuiltIn) {
        _items = [];
        _isLoadingBuiltIn = true;
        unawaited(_filterModifiedBuiltInItems());
      } else {
        _items = List.of(widget.initialCategory!.azkar);
      }
    } else {
      _items = [];
    }
  }

  Future<void> _filterModifiedBuiltInItems() async {
    final ds = sl<AzkarLocalDataSource>();
    try {
      final originalList =
          await ds.getAzkarByCategory(widget.initialCategory!.id);
      _originalCounts = {for (final z in originalList) z.id: z.count};
    } catch (_) {}

    if (!mounted) return;

    setState(() {
      _items = _allCategoryItems.where((z) {
        if (z.canBeDeleted) return true; // User-added zikr
        final originalCount = _originalCounts[z.id];
        return originalCount != null && originalCount != z.count; // Target modified
      }).toList();
      _isLoadingBuiltIn = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _openAddZikrBottomSheet([int? editIndex]) {
    final existingItem = editIndex != null ? _items[editIndex] : null;

    unawaited(
      AppBottomSheet.show<void>(
        context: context,
        child: AddZikrBottomSheet(
          initialZikr: existingItem,
          onSave: (zikr) {
            setState(() {
              if (editIndex != null) {
                _items[editIndex] = zikr;
                final allIndex =
                    _allCategoryItems.indexWhere((z) => z.id == zikr.id);
                if (allIndex != -1) {
                  _allCategoryItems[allIndex] = zikr;
                }
              } else {
                _items.add(zikr);
                _allCategoryItems.add(zikr);
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
          child: EditTargetCountBottomSheet(initialCount: zikr.count),
        ).then((newCount) {
          if (newCount != null && newCount != zikr.count && mounted) {
            setState(() {
              final updatedZikr = ZikrEntity(
                id: zikr.id,
                text: zikr.text,
                count: newCount,
                description: zikr.description,
                isUserAdded: zikr.isUserAdded,
              );
              _items[index] = updatedZikr;
              final allIndex =
                  _allCategoryItems.indexWhere((z) => z.id == zikr.id);
              if (allIndex != -1) {
                _allCategoryItems[allIndex] = updatedZikr;
              }
            });
          }
        }),
      );
      return;
    }

    _openAddZikrBottomSheet(index);
  }

  Future<void> _deleteItem(int index) async {
    final zikr = _items[index];
    if (_isBuiltIn && !zikr.canBeDeleted) {
      return; // Cannot delete built-in zikr
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
        _allCategoryItems.removeWhere((z) => z.id == zikr.id);
      });
    }
  }

  Future<void> _saveCategory(CustomAzkarCubit cubit) async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isBuiltIn && _items.isEmpty) {
      AppToast.show(
        context,
        AppStrings.mustAddAtLeastOneZikr,
        type: AppToastType.error,
      );
      return;
    }

    final id = widget.initialCategory?.id ??
        'custom_${DateTime.now().millisecondsSinceEpoch}';
    final name = _nameController.text.trim();

    final List<ZikrEntity> azkarToSave;
    if (_isBuiltIn) {
      final modifiedMap = {for (final z in _items) z.id: z};
      final mergedOriginals =
          _allCategoryItems.where((z) => !z.canBeDeleted).map((z) {
        return modifiedMap[z.id] ?? z;
      }).toList();
      final userAdded = _items.where((z) => z.canBeDeleted).toList();
      azkarToSave = [...mergedOriginals, ...userAdded];
    } else {
      azkarToSave = _items;
    }

    final category = CustomCategoryEntity(
      id: id,
      name: name,
      azkar: azkarToSave,
      createdAt: widget.initialCategory?.createdAt ?? DateTime.now(),
    );

    final success = await cubit.saveCustomCategory(category);
    if (!mounted || !context.mounted) return;

    if (success) {
      AppToast.show(
        context,
        AppStrings.customZikrSavedSuccess,
        type: AppToastType.success,
      );
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) => BlocProvider<CustomAzkarCubit>(
    create: (context) => sl<CustomAzkarCubit>(),
    child: Builder(
      builder: (context) {
        final cubit = context.read<CustomAzkarCubit>();

        if (_isLoadingBuiltIn) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }

        return Scaffold(
          body: Form(
            key: _formKey,
            child: CustomScrollView(
              slivers: [
                // App bar with Save text button
                CommonSliverAppBar(
                  title: _isEditing
                      ? AppStrings.editCustomZikr
                      : AppStrings.createCustomZikr,
                  actions: [
                    AppTextButton(
                      label: AppStrings.save,
                      onPressed: () => unawaited(_saveCategory(cubit)),
                    ),
                  ],
                ),

                // Name field & divider
                SliverPadding(
                  padding: AppSize.shp,
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppGap.h(AppSize.p8),

                        // Name input with label
                        AppTextField(
                          controller: _nameController,
                          label: AppStrings.customZikrName,
                          hint: AppStrings.customZikrNameHint,
                          readOnly: _isBuiltIn,
                          inputFormatters:
                              AppValidators.arabicNameInputFormatters,
                          validator: (v) => AppValidators.requiredField(
                            v,
                            AppStrings.customZikrNameRequired,
                          ),
                        ),
                        AppGap.h(AppSize.p16),

                        // Divider
                        const CustomAppDivider(),
                        AppGap.h(AppSize.p16),
                      ],
                    ),
                  ),
                ),

                // Azkar list / add button
                if (_items.isEmpty)
                  SliverPadding(
                    padding: AppSize.shp,
                    sliver: SliverToBoxAdapter(
                      child: AppPrimaryButton(
                        label: '+ ${AppStrings.addZikr}',
                        expand: true,
                        onPressed: () => _openAddZikrBottomSheet(),
                      ),
                    ),
                  )
                else ...[
                  SliverPadding(
                    padding: AppSize.shp,
                    sliver: AppSliverList(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final zikr = _items[index];
                        final canDelete = !_isBuiltIn || zikr.canBeDeleted;
                        return _CustomZikrItemTile(
                          zikr: zikr,
                          onEdit: () => _editItem(index),
                          onDelete: canDelete
                              ? () => unawaited(_deleteItem(index))
                              : null,
                        );
                      },
                    ),
                  ),

                  // Add another zikr button under last card
                  SliverPadding(
                    padding: AppSize.shp,
                    sliver: SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: AppSize.p4),
                        child: AppSecondaryButton(
                          label: '+ ${AppStrings.addZikr}',
                          expand: true,
                          onPressed: () => _openAddZikrBottomSheet(),
                        ),
                      ),
                    ),
                  ),
                ],

                // Bottom gap
                SliverToBoxAdapter(
                  child: AppGap.h(AppSize.sbp),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

class _CustomZikrItemTile extends StatelessWidget {
  const _CustomZikrItemTile({
    required this.zikr,
    required this.onEdit,
    this.onDelete,
  });

  final ZikrEntity zikr;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: AppSize.p16),
    child: AppSectionCard(
      padding: EdgeInsets.all(AppSize.p20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Content
          ZikrContent(
            text: zikr.text,
            subText: zikr.description,
            fontSize: ReadingSettingsEntity.defaultFontSize,
          ),
          AppGap.h(AppSize.p24),

          // Divider
          const CustomAppDivider(),
          AppGap.h(AppSize.p24),

          // Actions + Counter Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Edit and Delete actions on one side
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIconButton(
                    icon: AppIcons.edit,
                    tooltip: AppStrings.editZikr,
                    onPressed: onEdit,
                  ),
                  if (onDelete != null) ...[
                    AppGap.w(AppSize.p8),
                    AppIconButton(
                      icon: AppIcons.delete,
                      color: AppColorsCommon.errorColor,
                      tooltip: AppStrings.deleteZikr,
                      onPressed: onDelete,
                    ),
                  ],
                ],
              ),

              // Counter on the opposite side
              Semantics(
                label: AppStrings.remainingCounterLabel,
                value: '${zikr.count}',
                excludeSemantics: true,
                child: ZikrCounter(
                  completedCount: 0,
                  totalCount: zikr.count,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
