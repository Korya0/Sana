import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class QuranCardActions extends StatelessWidget {
  const QuranCardActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _ActionButton(
          title: 'قراءة',
          onTap: () => context.pushNamed(AppRoutes.quran),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String title;
  final Function()? onTap;

  const _ActionButton({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.gold,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          title,
          style: AppTextStyles.font14W600White(
            context,
          ).copyWith(color: Colors.black),
        ),
      ),
    );
  }
}
