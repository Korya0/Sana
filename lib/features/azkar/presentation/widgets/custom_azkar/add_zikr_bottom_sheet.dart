import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/app_validators.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_primary_button.dart';
import 'package:sana/core/widgets/buttons/app_secondary_button.dart';
import 'package:sana/core/widgets/inputs/app_text_area_field.dart';
import 'package:sana/core/widgets/inputs/app_text_field.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';

class AddZikrBottomSheet extends StatefulWidget {
  const AddZikrBottomSheet({
    required this.onSave,
    super.key,
    this.initialZikr,
  });

  final ZikrEntity? initialZikr;
  final ValueChanged<ZikrEntity> onSave;

  @override
  State<AddZikrBottomSheet> createState() => _AddZikrBottomSheetState();
}

class _AddZikrBottomSheetState extends State<AddZikrBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _textController;
  late final TextEditingController _countController;

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
  }

  @override
  void dispose() {
    _textController.dispose();
    _countController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final text = _textController.text.trim();
    final count = AppValidators.parseCount(_countController.text.trim());
    if (count == null || count <= 0) return;

    final zikr = ZikrEntity(
      id: widget.initialZikr?.id ?? DateTime.now().millisecondsSinceEpoch,
      text: text,
      count: count,
      isUserAdded: widget.initialZikr?.isUserAdded ?? true,
    );

    widget.onSave(zikr);
    Navigator.of(context).pop();
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
                widget.initialZikr == null
                    ? AppStrings.addZikr
                    : AppStrings.editZikr,
                maxLines: AppConstants.maxOneLine,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyles.font16W700Primary(context),
              ),
              AppGap.h(AppSize.p20),

              // Zikr text area field
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
