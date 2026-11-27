import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_library/quran_library.dart' hide QuranState;
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/views/app_error_view.dart';
import 'package:sana/features/quran/presentation/cubits/quran/quran_cubit.dart';
import 'package:sana/features/quran/presentation/cubits/quran/quran_state.dart';

class QuranView extends StatelessWidget {
  const QuranView({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<QuranCubit>(
        create: (_) {
          final cubit = sl<QuranCubit>();
          unawaited(cubit.initialize());
          return cubit;
        },
        child: const _QuranViewContent(),
      );
}

class _QuranViewContent extends StatelessWidget {
  const _QuranViewContent();

  @override
  Widget build(BuildContext context) => BlocBuilder<QuranCubit, QuranState>(
        builder: (context, state) => switch (state) {
          QuranInitial() ||
          QuranLoading() =>
            Scaffold(
              body: CustomScrollView(
                slivers: [
                  SliverSafeArea(
                    sliver: SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: context.color.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          QuranReady() => QuranLibraryScreen(
              parentContext: context,
              isDark: context.isDark,
              appLanguageCode: AppConstants.arLocaleCode,
            ),
          QuranFailed(:final message) => Scaffold(
              body: CustomScrollView(
                slivers: [
                  SliverSafeArea(
                    sliver: SliverFillRemaining(
                      hasScrollBody: false,
                      child: AppErrorView(
                        message: message,
                        onRetry: () => context.read<QuranCubit>().retry(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        },
      );
}
