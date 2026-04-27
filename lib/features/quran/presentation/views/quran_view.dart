import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_library/quran_library.dart' as ql;
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/quran/presentation/cubit/quran_cubit.dart';
import 'package:sana/features/quran/presentation/cubit/quran_state.dart';
import 'package:sana/features/quran/presentation/widgets/quran_error_widget.dart';
import 'package:sana/features/quran/presentation/widgets/quran_loading_widget.dart';

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
        return switch (state) {
          QuranLoading() || QuranInitial() => const QuranLoadingWidget(),
          QuranError() => QuranErrorWidget(
            onRetry: () => context.read<QuranCubit>().init(),
          ),
          QuranSuccess() => const _QuranSuccessWidget(),
        };
      },
    );
  }
}

class _QuranSuccessWidget extends StatelessWidget {
  const _QuranSuccessWidget();

  @override
  Widget build(BuildContext context) {
    return ql.QuranLibraryScreen(
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
    );
  }
}
