import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/common/overlays/dialog/app_dialog.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/routing/app_navigator.dart';
import 'package:sana/core/constants/app_spacing.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';

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
      AppNavigator.pop(context); // Close dialog
      widget.onSuccess();
    } else {
      setState(() {
        _hasError = true;
        _pinController.clear();
      });
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.adminPanel,
              style: AppTextStyles.font20W700(context),
            ),
            const AppGap.h(AppSpacing.v16),
            Text(
              AppStrings.adminSectionRequirePin,
              style: AppTextStyles.font14W500(context),
              textAlign: TextAlign.center,
            ),
            const AppGap.h(AppSpacing.v24),
            AppTextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              textAlign: TextAlign.center,
              hint: '****',
              errorText: _hasError ? AppStrings.wrongPin : null,
              onFieldSubmitted: (_) => _verifyPin(),
            ),
            const AppGap.h(AppSpacing.v24),
            Row(
              children: [
                Expanded(
                  child: AppSecondaryButton(
                    text: AppStrings.cancel,
                    onPressed: () => AppNavigator.pop(context),
                  ),
                ),
                const AppGap.w(AppSpacing.v12),
                Expanded(
                  child: AppPrimaryButton(
                    text: AppStrings.login,
                    onPressed: _verifyPin,
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
