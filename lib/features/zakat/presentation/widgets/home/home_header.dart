import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primary,
            secondary,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(
              Icons.volunteer_activism,
              size: 44,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            AppStrings.zakatTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            AppStrings.zakatSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18, height: 1.6),
          ),
        ],
      ),
    );
  }
}
