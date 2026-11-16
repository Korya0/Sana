import 'package:flutter/material.dart';
import 'package:sana/core/widgets/buttons/app_button.dart';

class AppSecondaryButton extends StatelessWidget {
  // Creates button
  const AppSecondaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool expand;

  // Builds button
  @override
  Widget build(BuildContext context) => AppButton(
    label: label,
    onPressed: onPressed,
    variant: AppButtonVariant.secondary,
    expand: expand,
  );
}
