import 'package:flutter/material.dart';
import 'package:sana/core/common/overlays/bottom_sheet/custom_bottom_sheet_widget.dart';

Future<void> showCustomBottomSheet(
  BuildContext context, {
  String? title,
  String? message,
  VoidCallback? onPrimaryAction,
  VoidCallback? onSecondaryAction,
  String primaryButtonText = 'تأكيد',
  String? secondaryButtonText,
  Color? primaryButtonColor,
  Color? secondaryButtonColor,
  Future<bool> Function()? onWillPop,
  bool isDismissible = true,
  Widget? child,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isDismissible: isDismissible,
    enableDrag: isDismissible,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => CustomBottomSheet(
      title: title,
      message: message,
      onPrimaryAction: onPrimaryAction,
      onSecondaryAction: onSecondaryAction,
      primaryButtonText: primaryButtonText,
      secondaryButtonText: secondaryButtonText,
      primaryButtonColor: primaryButtonColor,
      secondaryButtonColor: secondaryButtonColor,
      onWillPop: onWillPop,
      child: child,
    ),
  );
}
