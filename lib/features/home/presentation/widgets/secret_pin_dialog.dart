import 'package:flutter/material.dart';

import 'package:sana/core/common/overlays/toast/app_toast.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';

class SecretPinDialog extends StatefulWidget {
  const SecretPinDialog({
    required this.onSuccess,
    super.key,
  });

  final VoidCallback onSuccess;

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onSuccess,
  }) {
    return showDialog(
      context: context,
      builder: (context) => SecretPinDialog(onSuccess: onSuccess),
    );
  }

  @override
  State<SecretPinDialog> createState() => _SecretPinDialogState();
}

class _SecretPinDialogState extends State<SecretPinDialog> {
  final TextEditingController _pinController = TextEditingController();
  static const _secretPin = '31903556';
  bool _hasError = false;

  void _verifyPin() {
    if (_pinController.text == _secretPin) {
      Navigator.of(context).pop(); // Close dialog
      widget.onSuccess();
    } else {
      setState(() {
        _hasError = true;
        _pinController.clear();
      });
      AppToast.show(
        context,
        AppStrings.invalidPin,
        type: AppToastType.error,
      );
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.secondaryBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusL),
        side: BorderSide(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.v24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.adminPanel,
              style: AppTextStyles.font18W700White(context),
            ),
            const SizedBox(height: AppSpacing.v16),
            Text(
              AppStrings.adminSectionRequirePin,
              style: AppTextStyles.font14W500Grey(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.v24),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              style: AppTextStyles.font16W600White(context),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '****',
                hintStyle: AppTextStyles.font14W500Grey(context),
                filled: true,
                fillColor: AppColors.scaffoldBackground,
                errorText: _hasError ? AppStrings.wrongPin : null,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.v16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                  borderSide: BorderSide(
                    color: AppColors.grey.withValues(alpha: 0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                  borderSide: BorderSide(
                    color: AppColors.grey.withValues(alpha: 0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                  borderSide: BorderSide(
                    color: AppColors.gold.withValues(alpha: 0.5),
                  ),
                ),
              ),
              onSubmitted: (_) => _verifyPin(),
            ),
            const SizedBox(height: AppSpacing.v24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.v12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                        border: Border.all(
                          color: AppColors.grey.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          AppStrings.cancel,
                          style: AppTextStyles.font14W600White(context),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.v12),
                Expanded(
                  child: GestureDetector(
                    onTap: _verifyPin,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.v12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                      ),
                      child: Center(
                        child: Text(
                          AppStrings.login,
                          style: AppTextStyles.font12W700Black(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
