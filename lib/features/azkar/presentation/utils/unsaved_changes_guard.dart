import 'package:flutter/material.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/overlays/custom_confirmation_dialog.dart';

mixin UnsavedChangesGuard<T extends StatefulWidget> on State<T> {
  bool get isDirty;

  bool _isDialogOpen = false;

  Future<void> closeWithGuard() async {
    if (_isDialogOpen) return;

    if (!isDirty) {
      context.popOnce();
      return;
    }

    _isDialogOpen = true;
    final shouldExit = await CustomConfirmationDialog.showUnsavedChanges(
      context,
    );
    _isDialogOpen = false;

    if (shouldExit && mounted) {
      context.popOnce();
    }
  }
}
