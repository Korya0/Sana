import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/app_validators.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_primary_button.dart';
import 'package:sana/core/widgets/buttons/app_secondary_button.dart';
import 'package:sana/core/widgets/inputs/app_text_area_field.dart';
import 'package:sana/core/widgets/inputs/app_text_field.dart';
import 'package:sana/core/widgets/overlays/custom_confirmation_dialog.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';

class AddZikrBottomSheet extends StatefulWidget {
  // Creates sheet
  const AddZikrBottomSheet({
    required this.onSave,
    required this.nextId,
    super.key,
    this.initialZikr,
  });

  final ZikrEntity? initialZikr;
  final ValueChanged<ZikrEntity> onSave;
  final int Function() nextId;

  @override
  State<AddZikrBottomSheet> createState() => _AddZikrBottomSheetState();
}

class _AddZikrBottomSheetState extends State<AddZikrBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _textController;
  late final TextEditingController _countController;
  late final String _initialText;
  late final String _initialCount;
  bool _isExitDialogOpen = false;
  bool _isSubmitting = false;

  // Checks changes
  bool get _isDirty =>
      _textController.text.trim() != _initialText ||
      _countController.text.trim() != _initialCount;

  // Initializes state
  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.initialZikr?.text ?? '',
    );
    _countController = TextEditingController(
      text: widget.initialZikr != null
          ? widget.initialZikr!.count.toString()
          : '',
    );
    _initialText = _textController.text.trim();
    _initialCount = _countController.text.trim();
  }

  // Disposes state
  @override
  void dispose() {
    _textController.dispose();
    _countController.dispose();
    super.dispose();
  }

  // Handles close
  Future<void> _handleClose() async {
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

  // Submits form
  void _submit() {
    if (_isSubmitting) return;
    if (!_formKey.currentState!.validate()) return;

    final text = _textController.text.trim();
    final count = AppValidators.parseCount(_countController.text.trim());
    if (count == null || count <= 0) return;

    final zikr = ZikrEntity(
      id: widget.initialZikr?.id ?? widget.nextId(),
      text: text,
      count: count,
      isUserAdded: widget.initialZikr?.isUserAdded ?? true,
    );

    setState(() => _isSubmitting = true);
    widget.onSave(zikr);
    context.popOnce();
  }

  // Builds sheet
  @override
  Widget build(BuildContext context) {
    final bottomInset = AppSize.keyboardHeight(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        unawaited(_handleClose());
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSize.p20,
          right: AppSize.p20,
          top: AppSize.p16,
          bottom: bottomInset + AppSize.p16,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Text(
                  widget.initialZikr == null
                      ? AppStrings.addZikr
                      : AppStrings.editZikr,
                  maxLines: AppConstants.maxOneLine,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font16W700Primary(context),
                ),
                AppGap.h(AppSize.p20),

                // Body
                // Text field
                AppTextAreaField(
                  controller: _textController,
                  label: AppStrings.zikrText,
                  hint: AppStrings.zikrTextHint,
                  inputFormatters: AppValidators.arabicInputFormatters,
                  validator: (v) => AppValidators.requiredField(
                    v,
                    AppStrings.zikrTextRequired,
                  ),
                ),
                AppGap.h(AppSize.p16),

                // Count field
                AppTextField(
                  controller: _countController,
                  label: AppStrings.targetCount,
                  hint: AppStrings.targetCountHint,
                  keyboardType: TextInputType.number,
                  inputFormatters: AppValidators.digitsOnlyInputFormatters,
                  validator: (v) => AppValidators.targetCount(
                    v,
                    emptyError: AppStrings.targetCountRequired,
                    greaterThanZeroError: AppStrings.targetCountGreaterThanZero,
                  ),
                ),
                AppGap.h(AppSize.p24),

                // Actions
                AppPrimaryButton(
                  label: AppStrings.save,
                  expand: true,
                  onPressed: _isSubmitting ? null : _submit,
                ),
                AppGap.h(AppSize.p12),

                AppSecondaryButton(
                  label: AppStrings.cancel,
                  expand: true,
                  onPressed: () => unawaited(_handleClose()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
