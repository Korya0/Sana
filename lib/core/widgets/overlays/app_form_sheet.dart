import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/widgets/dividers/app_divider.dart';
import 'package:sana/core/widgets/overlays/app_sheet_body.dart';
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        unawaited(onClose());
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: AppSize.p16,
              end: AppSize.p16,
              top: AppSize.p8,
            ),
            child: AppSheetHeader(
              title: title,
              onDismiss: () => unawaited(onClose()),
              onSave: onSubmit,
              isSaveEnabled: canSave,
              isSaving: isSubmitting,
            ),
          ),
          const AppDivider(),
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: AppSize.p16,
              end: AppSize.p16,
              top: AppSize.p24,
              bottom: AppSize.p24,
            ),
            child: Form(
              key: formKey,
              child: AppSheetBody(children: fields),
            ),
          ),
        ],
      ),
    );
  }
}
