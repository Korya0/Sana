import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_primary_button.dart';
import 'package:sana/core/widgets/buttons/app_secondary_button.dart';

class AppFormSheet extends StatelessWidget {
  const AppFormSheet({
    required this.formKey,
    required this.title,
    required this.fields,
    required this.onSubmit,
    required this.onClose,
    super.key,
    this.isSubmitting = false,
  });

  final GlobalKey<FormState> formKey;
  final String title;
  final List<Widget> fields;
  final VoidCallback onSubmit;
  final Future<void> Function() onClose;
  final bool isSubmitting;

  // Builds sheet
  @override
  Widget build(BuildContext context) {
    final bottomInset = AppSize.keyboardHeight(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        unawaited(onClose());
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSize.p20,
          right: AppSize.p20,
          top: AppSize.p16,
          bottom: bottomInset + AppSize.p16,
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Text(
                  title,
                  maxLines: AppConstants.maxOneLine,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font16W700Primary(context),
                ),
                AppGap.h(AppSize.p20),

                // Body
                ...fields,
                AppGap.h(AppSize.p24),

                // Actions
                AppPrimaryButton(
                  label: AppStrings.save,
                  expand: true,
                  onPressed: isSubmitting ? null : onSubmit,
                ),
                AppGap.h(AppSize.p12),

                AppSecondaryButton(
                  label: AppStrings.cancel,
                  expand: true,
                  onPressed: () => unawaited(onClose()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
