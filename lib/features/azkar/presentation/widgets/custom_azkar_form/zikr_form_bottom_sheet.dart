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
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/utils/unsaved_changes_guard.dart';

class ZikrFormBottomSheet extends StatefulWidget {
  const ZikrFormBottomSheet({
    required this.onSave,
    required this.generateNextId,
    super.key,
    this.initialZikr,
  });

  final ZikrEntity? initialZikr;
  final ValueChanged<ZikrEntity> onSave;
  final int Function() generateNextId;

  @override
  State<ZikrFormBottomSheet> createState() => _ZikrFormBottomSheetState();
}

class _ZikrFormBottomSheetState extends State<ZikrFormBottomSheet>
    with UnsavedChangesGuard<ZikrFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _textController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _countController;
  late final String _initialText;
  late final String _initialDescription;
  late final String _initialCount;
  bool _submitted = false;
  bool _canSave = false;

  bool get _isValid {
    final count = AppValidators.parseCount(_countController.text);
    final description = _descriptionController.text.trim();
    final shortText = AppStrings.tooShortText(AppConstants.minTextLength);
    return AppValidators.requiredField(
          _textController.text,
          AppStrings.zikrTextRequired,
        ) ==
            null &&
        AppValidators.arabicLetters(
          _textController.text,
          AppStrings.arabicLettersRequired,
        ) ==
            null &&
        AppValidators.minLetters(
          _textController.text,
          AppConstants.minTextLength,
          shortText,
        ) ==
            null &&
        (description.isEmpty ||
            AppValidators.minLetters(
              description,
              AppConstants.minTextLength,
              shortText,
            ) ==
                null) &&
        count != null &&
        count > 0 &&
        count <= AppConstants.tasbeehMaxCount;
  }

  @override
  bool get isDirty =>
      _textController.text.trim() != _initialText ||
      _descriptionController.text.trim() != _initialDescription ||
      _countController.text.trim() != _initialCount;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.initialZikr?.text ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.initialZikr?.description ?? '',
    );
    _countController = TextEditingController(
      text: widget.initialZikr != null
          ? widget.initialZikr!.count.toString()
          : '',
    );
    _initialText = _textController.text.trim();
    _initialDescription = _descriptionController.text.trim();
    _initialCount = _countController.text.trim();
    _canSave = _isValid;
    _textController.addListener(_updateCanSave);
    _countController.addListener(_updateCanSave);
  }

  @override
  void dispose() {
    _textController.dispose();
    _descriptionController.dispose();
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

    final text = AppValidators.collapseWhitespace(_textController.text);
    final descriptionText = AppValidators.collapseWhitespace(
      _descriptionController.text,
    );
    final count = AppValidators.parseCount(_countController.text.trim());
    if (count == null || count <= 0) return;

    final zikr = ZikrEntity(
      id: widget.initialZikr?.id ?? widget.generateNextId(),
      text: text,
      count: count,
      description: descriptionText.isEmpty ? null : descriptionText,
      isUserAdded: widget.initialZikr?.isUserAdded ?? true,
    );

    _submitted = true;
    widget.onSave(zikr);
    context.popOnce();
  }

  @override
  Widget build(BuildContext context) => AppFormSheet(
    formKey: _formKey,
    title: widget.initialZikr == null
        ? AppStrings.addZikr
        : AppStrings.editZikr,
    onSubmit: _submit,
    onClose: closeWithGuard,
    canSave: _canSave,
    fields: [
      // Text field
      AppTextAreaField(
        controller: _textController,
        label: AppStrings.zikrText,
        hint: AppStrings.zikrTextHint,
        minHeight: AppSize.h75,
        isRequired: true,
        inputFormatters: AppValidators.arabicInputFormatters,
        validator: (v) =>
            AppValidators.requiredField(v, AppStrings.zikrTextRequired) ??
            AppValidators.arabicLetters(v, AppStrings.arabicLettersRequired) ??
            AppValidators.minLetters(
              v,
              AppConstants.minTextLength,
              AppStrings.tooShortText(AppConstants.minTextLength),
            ),
      ),
      AppGap.h(AppSize.p16),

      // Virtue field
      AppTextAreaField(
        controller: _descriptionController,
        label: AppStrings.zikrVirtue,
        hint: AppStrings.zikrVirtueHint,
        maxLength: AppConstants.zikrVirtueMaxLength,
        minHeight: AppSize.h56,
        isOptional: true,
        inputFormatters: AppValidators.arabicInputFormatters,
        validator: (v) => AppValidators.minLetters(
          v,
          AppConstants.minTextLength,
          AppStrings.tooShortText(AppConstants.minTextLength),
        ),
      ),
      AppGap.h(AppSize.p16),

      // Count field
      AppTextField(
        controller: _countController,
        label: AppStrings.targetCount,
        hint: AppStrings.targetCountHint,
        isRequired: true,
        keyboardType: TextInputType.number,
        inputFormatters: AppValidators.digitsOnlyInputFormatters,
        validator: (v) => AppValidators.targetCount(
          v,
          emptyError: AppStrings.targetCountRequired,
          greaterThanZeroError: AppStrings.targetCountGreaterThanZero,
          max: AppConstants.tasbeehMaxCount,
          maxError: AppStrings.tasbeehTargetMaxError(
            AppConstants.tasbeehMaxCount,
          ),
        ),
      ),
    ],
  );
}
