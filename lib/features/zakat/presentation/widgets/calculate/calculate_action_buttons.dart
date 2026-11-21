import 'package:flutter/material.dart';

class CalculateActionButtons extends StatelessWidget {
  const CalculateActionButtons({
    super.key,
    required this.onSubmit,
    required this.onClear,
  });

  final VoidCallback onSubmit;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilledButton.icon(
          onPressed: onSubmit,
          icon: const Icon(Icons.calculate),
          label: const Text('احسب الزكاة'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onClear,
          icon: const Icon(Icons.refresh),
          label: const Text('مسح البيانات وإعادة الحساب'),
        ),
      ],
    );
  }
}
