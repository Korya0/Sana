import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/app_validators.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_primary_button.dart';
import 'package:sana/core/widgets/buttons/app_secondary_button.dart';
import 'package:sana/core/widgets/inputs/app_text_field.dart';

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

class _EditTargetCountBottomSheetState
    extends State<EditTargetCountBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _countController;

  @override
  void initState() {
    super.initState();
    _countController = TextEditingController(
      text: widget.initialCount.toString(),
    );
  }

  @override
  void dispose() {
    _countController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final count = AppValidators.parseCount(_countController.text.trim());
    if (count == null || count <= 0) return;

    Navigator.of(context).pop(count);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = AppSize.keyboardHeight(context);

    return Padding(
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
              // Title
              Text(
                AppStrings.editTargetCount,
                maxLines: AppConstants.maxOneLine,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyles.font16W700Primary(context),
              ),
              AppGap.h(AppSize.p20),

              // Target count field
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

              // Buttons
              AppPrimaryButton(
                label: AppStrings.save,
                expand: true,
                onPressed: _submit,
              ),
              AppGap.h(AppSize.p12),

              AppSecondaryButton(
                label: AppStrings.cancel,
                expand: true,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

