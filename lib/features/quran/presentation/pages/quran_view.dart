import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/quran/presentation/cubits/quran_cubit.dart';
import 'package:sana/features/quran/presentation/cubits/quran_state.dart';
import 'package:sana/features/quran/presentation/widgets/quran_error_widget.dart';
import 'package:sana/features/quran/presentation/widgets/quran_loading_widget.dart';
import 'package:sana/features/quran/presentation/widgets/quran_success_widget.dart';

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
          QuranError(:final message) => QuranErrorWidget(
            message: message,
            onRetry: () => context.read<QuranCubit>().init(),
          ),
          QuranSuccess() => const QuranSuccessWidget(),
        };
      },
    );
  }
}
