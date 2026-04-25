import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_library/quran_library.dart' as ql;
import 'package:sana/core/common/widgets/app_error_view.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/utils/app_feedback.dart';
import 'package:sana/features/quran/presentation/cubit/quran_cubit.dart';
import 'package:sana/features/quran/presentation/cubit/quran_state.dart';

class QuranView extends StatefulWidget {
  const QuranView({super.key});

  @override
  State<QuranView> createState() => _QuranViewState();
}

class _QuranViewState extends State<QuranView> {
  @override
  void initState() {
    super.initState();
    unawaited(context.read<QuranCubit>().init());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranCubit, QuranState>(
      builder: (context, state) {
        if (state is QuranLoading || state is QuranInitial) {
          return const Scaffold(
            backgroundColor: AppColors.secondaryBackground,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (state is QuranFailure) {
          return Scaffold(
            backgroundColor: AppColors.secondaryBackground,
            body: AppErrorView(
              onRetry: () => context.read<QuranCubit>().init(),
            ),
          );
        }

        return Stack(
          children: [
            ql.QuranLibraryScreen(
              parentContext: context,
              isDark: true,
              backgroundColor: AppColors.secondaryBackground,
              textColor: AppColors.textWhite,
              ayahSelectedBackgroundColor: AppColors.primary.withValues(
                alpha: 0.3,
              ),
              ayahIconColor: AppColors.primary,
              topBottomQuranStyle: const ql.TopBottomQuranStyle(
                juzTextColor: AppColors.primary,
                hizbTextColor: AppColors.primary,
                sajdaNameColor: AppColors.primary,
                surahNameColor: AppColors.primary,
                pageNumberColor: AppColors.primary,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Material(
                  color: Colors.transparent,
                  child: Center(
                    child: _FloatingExitButton(
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FloatingExitButton extends StatelessWidget {
  const _FloatingExitButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GestureDetector(
        onTap: () {
          unawaited(AppFeedback.playClickSound());
          unawaited(AppFeedback.playVibrate());
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.secondaryBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
          child: Text(
            'خروج',
            style: AppTextStyles.font14W600primary(context),
          ),
        ),
      ),
    );
  }
}
