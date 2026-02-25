import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/widgets/app_error_widget.dart';
import 'package:sana/core/common/widgets/common_sliver_app_bar.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/features/asma_ul_husna/presentation/controller/asma_ul_husna_cubit.dart';
import 'package:sana/features/asma_ul_husna/presentation/controller/asma_ul_husna_state.dart';
import 'package:sana/features/asma_ul_husna/presentation/widgets/modern_asma_ul_husna_view.dart';
import 'package:sana/features/asma_ul_husna/presentation/widgets/skeletonizer_loading_asma_ul_husna_view.dart';

class AsmaUlHusnaPage extends StatelessWidget {
  const AsmaUlHusnaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = sl<AsmaUlHusnaCubit>();
        unawaited(cubit.loadNames());
        return cubit;
      },
      child: Scaffold(
        body: BlocBuilder<AsmaUlHusnaCubit, AsmaUlHusnaState>(
          builder: (context, state) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const CommonSliverAppBar(title: 'الأسماء الحسنى'),
                if (state is AsmaUlHusnaLoading) ...[
                  const SkeletonizerLoadingAsmaUlHusnaView(),
                ] else if (state is AsmaUlHusnaError) ...[
                  SliverFillRemaining(
                    child: AppErrorWidget(
                      title: 'عذراً، حدث خطأ',
                      message:
                          'لم نتمكن من تحميل الأسماء الحسنى. ساعدنا في تحسين التطبيق بإرسال بلاغ عن المشكلة، جزاك الله خيراً',
                      onRetry: () => unawaited(
                        context.read<AsmaUlHusnaCubit>().loadNames(),
                      ),
                      technicalMessage: state.message,
                    ),
                  ),
                ] else if (state is AsmaUlHusnaLoaded) ...[
                  ModernAsmaUlHusnaView(names: state.names),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
