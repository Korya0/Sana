import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/app_spacing.dart';

class SecretPinDialog extends StatefulWidget {
  const SecretPinDialog({
    required this.onSuccess,
    super.key,
  });

  final VoidCallback onSuccess;

  static bool isAuthenticated = false;

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onSuccess,
    String? routeName,
  }) {
    return showDialog(
      context: context,
      routeSettings: routeName != null ? RouteSettings(name: routeName) : null,
      builder: (context) => SecretPinDialog(onSuccess: onSuccess),
    );
  }

  @override
  State<SecretPinDialog> createState() => _SecretPinDialogState();
}

class _SecretPinDialogState extends State<SecretPinDialog> {
  final TextEditingController _pinController = TextEditingController();
  bool _hasError = false;

  void _verifyPin() {
    final inputHash = sha256
        .convert(utf8.encode(_pinController.text))
        .toString();
    if (inputHash == AppConstants.adminSecretPinHash) {
      SecretPinDialog.isAuthenticated = true;
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
      backgroundColor: context.color.secondaryScaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusL),
        side: BorderSide(color: context.color.primary.withValues(alpha: 0.3)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.v24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.adminPanel,
                style: AppTextStyles.font20W700(
                  context,
                ).copyWith(color: context.color.textPrimary),
              ),
              const AppGap.h(AppSpacing.v16),
              Text(
                AppStrings.adminSectionRequirePin,
                style: AppTextStyles.font14W500(
                  context,
                ).copyWith(color: context.color.textSecondary),
                textAlign: TextAlign.center,
              ),
              const AppGap.h(AppSpacing.v24),
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                style: AppTextStyles.font16W700(
                  context,
                ).copyWith(color: context.color.textPrimary),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '****',
                  hintStyle: AppTextStyles.font14W500(
                    context,
                  ).copyWith(color: context.color.textSecondary),
                  filled: true,
                  fillColor: context.color.scaffoldBackgroundColor,
                  errorText: _hasError ? AppStrings.wrongPin : null,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.v16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                    borderSide: BorderSide(
                      color: context.color.textSecondary.withValues(alpha: 0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                    borderSide: BorderSide(
                      color: context.color.textSecondary.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                    borderSide: BorderSide(
                      color: context.color.primary.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                onSubmitted: (_) => _verifyPin(),
              ),
              const AppGap.h(AppSpacing.v24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.v12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusS,
                          ),
                          border: Border.all(
                            color: context.color.textSecondary.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            AppStrings.cancel,
                            style: AppTextStyles.font14W700(
                              context,
                            ).copyWith(color: context.color.textPrimary),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const AppGap.w(AppSpacing.v12),
                  Expanded(
                    child: GestureDetector(
                      onTap: _verifyPin,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.v12,
                        ),
                        decoration: BoxDecoration(
                          color: context.color.primary,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusS,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            AppStrings.login,
                            style: AppTextStyles.font12W700(context).copyWith(
                              color: context.color.scaffoldBackgroundColor,
                            ),
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
      ),
    );
  }
}
