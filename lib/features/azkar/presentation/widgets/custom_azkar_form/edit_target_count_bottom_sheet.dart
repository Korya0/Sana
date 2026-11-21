import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/utils/app_validators.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/inputs/app_text_field.dart';
import 'package:sana/core/widgets/overlays/app_form_sheet.dart';
import 'package:sana/features/azkar/presentation/utils/unsaved_changes_guard.dart';

class EditTargetCountBottomSheet extends StatefulWidget {
  const EditTargetCountBottomSheet({
    required this.initialCount,
    super.key,
  });

  final int initialCount;

  @override
  State<EditTargetCountBottomSheet> createState() =>
      _EditTargetCountBottomSheetState();
}

class _EditTargetCountBottomSheetState extends State<EditTargetCountBottomSheet>
    with UnsavedChangesGuard<EditTargetCountBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _countController;
  late final String _initialCount;
  bool _isSubmitting = false;
  bool _canSave = false;

  @override
  bool get isDirty => _countController.text.trim() != _initialCount;

  bool get _isValid {
    final count = AppValidators.parseCount(_countController.text);
    return count != null && count > 0;
  }

  @override
  void initState() {
    super.initState();
    _initialCount = widget.initialCount.toString();
    _countController = TextEditingController(text: _initialCount);
    _canSave = _isValid;
    _countController.addListener(_updateCanSave);
  }

  @override
  void dispose() {
    _countController.dispose();
    super.dispose();
  }

  // Keeps the header save action in step with the field.
  void _updateCanSave() {
    final canSave = _isValid;
    if (canSave == _canSave) return;
    setState(() => _canSave = canSave);
  }

  void _submit() {
    if (_isSubmitting) return;
    if (!_formKey.currentState!.validate()) return;

    final count = AppValidators.parseCount(_countController.text.trim());
    if (count == null || count <= 0) return;

    setState(() => _isSubmitting = true);
    context.popOnce(count);
  }

  @override
  Widget build(BuildContext context) => AppFormSheet(
    formKey: _formKey,
    title: AppStrings.editTargetCount,
    onSubmit: _submit,
    onClose: closeWithGuard,
    canSave: _canSave,
    isSubmitting: _isSubmitting,
    fields: [
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
