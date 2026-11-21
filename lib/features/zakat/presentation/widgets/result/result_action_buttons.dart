import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/router/app_routes.dart';

class ResultActionButtons extends StatelessWidget {
  const ResultActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilledButton.icon(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.edit_outlined),
          label: const Text('تعديل البيانات'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => context.go(AppRoutes.homeView),
          icon: const Icon(Icons.home_outlined),
          label: const Text('العودة للرئيسية'),
        ),
      ],
    );
  }
}
