import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/overlays/app_sheet_header.dart';

class AppFormSheet extends StatelessWidget {
  const AppFormSheet({
    required this.formKey,
    required this.title,
    required this.fields,
    required this.onSubmit,
    required this.onClose,
    super.key,
    this.canSave = true,
    this.isSubmitting = false,
  });

  final GlobalKey<FormState> formKey;
  final String title;
  final List<Widget> fields;
  final VoidCallback onSubmit;
  final Future<void> Function() onClose;
  final bool canSave;
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
                AppSheetHeader(
                  title: title,
                  onDismiss: () => unawaited(onClose()),
                  onSave: onSubmit,
                  isSaveEnabled: canSave,
                  isSaving: isSubmitting,
                ),
                AppGap.h(AppSize.p20),

                // Body
                ...fields,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
