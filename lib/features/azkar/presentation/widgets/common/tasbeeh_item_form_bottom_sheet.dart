import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/utils/app_validators.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/inputs/app_text_area_field.dart';
import 'package:sana/core/widgets/inputs/app_text_field.dart';
import 'package:sana/core/widgets/overlays/app_form_sheet.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/presentation/utils/unsaved_changes_guard.dart';

class TasbeehItemFormBottomSheet extends StatefulWidget {
  const TasbeehItemFormBottomSheet({super.key, this.initialItem});

  final TasbeehItemEntity? initialItem;

  @override
  State<TasbeehItemFormBottomSheet> createState() =>
      _TasbeehItemFormBottomSheetState();
}

class _TasbeehItemFormBottomSheetState
    extends State<TasbeehItemFormBottomSheet>
    with UnsavedChangesGuard<TasbeehItemFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _textController;
  late final TextEditingController _countController;
  late final String _initialText;
  late final String _initialCount;
  bool _isSubmitting = false;

  @override
  bool get isDirty =>
      _textController.text.trim() != _initialText ||
      _countController.text.trim() != _initialCount;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.initialItem?.text ?? '',
    );
    _countController = TextEditingController(
      text: widget.initialItem?.targetCount?.toString() ?? '',
    );
    _initialText = _textController.text.trim();
    _initialCount = _countController.text.trim();
  }

  @override
  void dispose() {
    _textController.dispose();
    _countController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_isSubmitting) return;
    if (!_formKey.currentState!.validate()) return;

    final text = _textController.text.trim();
    final countText = _countController.text.trim();
    final count = countText.isEmpty
        ? null
        : AppValidators.parseCount(countText);
    if (countText.isNotEmpty && (count == null || count <= 0)) return;

    setState(() => _isSubmitting = true);
    context.popOnce((text: text, targetCount: count));
  }

  @override
  Widget build(BuildContext context) => AppFormSheet(
    formKey: _formKey,
    title: widget.initialItem == null
        ? AppStrings.addTasbeeh
        : AppStrings.editTasbeeh,
    isSubmitting: _isSubmitting,
    onSubmit: _submit,
    onClose: closeWithGuard,
    fields: [
      // Text field
      AppTextAreaField(
        controller: _textController,
        label: AppStrings.tasbeehName,
        hint: AppStrings.tasbeehNameHint,
        inputFormatters: AppValidators.arabicInputFormatters,
        validator: (v) =>
            AppValidators.requiredField(v, AppStrings.tasbeehNameRequired),
      ),
      AppGap.h(AppSize.p16),

      // Count field
      AppTextField(
        controller: _countController,
        label: AppStrings.tasbeehTarget,
        hint: AppStrings.tasbeehTargetHint,
        keyboardType: TextInputType.number,
        inputFormatters: AppValidators.digitsOnlyInputFormatters,
        validator: (v) {
          final value = v?.trim() ?? '';
          if (value.isEmpty) return null;
          return AppValidators.targetCount(
            value,
            emptyError: AppStrings.targetCountRequired,
            greaterThanZeroError: AppStrings.targetCountGreaterThanZero,
          );
        },
      ),
    ],
  );
}
