import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
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
  const TasbeehItemFormBottomSheet({
    super.key,
    this.initialItem,
    this.existingTexts = const <String>{},
  });

  final TasbeehItemEntity? initialItem;
  final Set<String> existingTexts;

  @override
  State<TasbeehItemFormBottomSheet> createState() =>
      _TasbeehItemFormBottomSheetState();
}

class _TasbeehItemFormBottomSheetState extends State<TasbeehItemFormBottomSheet>
    with UnsavedChangesGuard<TasbeehItemFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _textController;
  late final TextEditingController _countController;
  late final String _initialText;
  late final String _initialCount;
  bool _submitted = false;
  bool _canSave = false;

  bool get _isValid {
    final shortText = AppStrings.tooShortText(AppConstants.minTextLength);
    if (AppValidators.requiredField(
          _textController.text,
          AppStrings.tasbeehNameRequired,
        ) !=
        null) {
      return false;
    }
    if (AppValidators.arabicLetters(
          _textController.text,
          AppStrings.arabicLettersRequired,
        ) !=
        null) {
      return false;
    }
    if (AppValidators.minLetters(
          _textController.text,
          AppConstants.minTextLength,
          shortText,
        ) !=
        null) {
      return false;
    }
    if (AppValidators.duplicate(
          _textController.text,
          widget.existingTexts,
          AppStrings.tasbeehTextDuplicate,
        ) !=
        null) {
      return false;
    }

    final countText = _countController.text.trim();
    if (countText.isEmpty) return true;

    final count = AppValidators.parseCount(countText);
    return count != null &&
        count > 0 &&
        count <= AppConstants.tasbeehMaxCount;
  }

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
    _canSave = _isValid;
    _textController.addListener(_updateCanSave);
    _countController.addListener(_updateCanSave);
  }

  @override
  void dispose() {
    _textController.dispose();
    _countController.dispose();
    super.dispose();
  }

  // Keeps the header save action in step with the fields.
  void _updateCanSave() {
    final canSave = _isValid;
    if (canSave == _canSave) return;
    setState(() => _canSave = canSave);
  }

  void _submit() {
    if (_submitted) return;
    if (!_formKey.currentState!.validate()) return;

    final text = _textController.text.trim();
    final countText = _countController.text.trim();
    final count = countText.isEmpty
        ? null
        : AppValidators.parseCount(countText);
    if (countText.isNotEmpty && (count == null || count <= 0)) return;

    _submitted = true;
    context.popOnce((text: text, targetCount: count));
  }

  @override
  Widget build(BuildContext context) => AppFormSheet(
    formKey: _formKey,
    title: widget.initialItem == null
        ? AppStrings.addTasbeeh
        : AppStrings.editTasbeeh,
    onSubmit: _submit,
    onClose: closeWithGuard,
    canSave: _canSave,
    fields: [
      // Text field
      AppTextAreaField(
        controller: _textController,
        label: AppStrings.tasbeehName,
        hint: AppStrings.tasbeehNameHint,
        maxLength: AppConstants.tasbeehTextMaxLength,
        minHeight: AppSize.h100,
        isRequired: true,
        inputFormatters: AppValidators.arabicInputFormatters,
        validator: (v) =>
            AppValidators.requiredField(v, AppStrings.tasbeehNameRequired) ??
            AppValidators.arabicLetters(v, AppStrings.arabicLettersRequired) ??
            AppValidators.minLetters(
              v,
              AppConstants.minTextLength,
              AppStrings.tooShortText(AppConstants.minTextLength),
            ) ??
            AppValidators.duplicate(
              v,
              widget.existingTexts,
              AppStrings.tasbeehTextDuplicate,
            ),
      ),
      AppGap.h(AppSize.p16),

      // Count field
      AppTextField(
        controller: _countController,
        label: AppStrings.tasbeehTarget,
        hint: AppStrings.tasbeehTargetHint,
        isOptional: true,
        keyboardType: TextInputType.number,
        inputFormatters: AppValidators.tasbeehCountInputFormatters,
        validator: (v) {
          final value = v?.trim() ?? '';
          if (value.isEmpty) return null;
          final count = AppValidators.parseCount(value);
          if (count != null && count > AppConstants.tasbeehMaxCount) {
            return AppStrings.tasbeehTargetMaxError(
              AppConstants.tasbeehMaxCount,
            );
          }
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
