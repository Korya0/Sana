import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/widgets/app_empty_view.dart';
import 'package:sana/core/common/widgets/app_error_view.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/developer_dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:sana/features/developer_dashboard/presentation/cubit/dashboard_state.dart';
import 'package:sana/features/developer_dashboard/presentation/widgets/feedback_admin_card.dart';
import 'package:solar_icons/solar_icons.dart';

class FeedbacksListView extends StatelessWidget {
  const FeedbacksListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardFeedbacksLoading) {
          return const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is DashboardFeedbacksError) {
          return SliverFillRemaining(
            child: AppErrorView(
              message: state.message,
              onRetry: () => context.read<DashboardCubit>().getFeedbacks(),
            ),
          );
        }

        if (state is DashboardFeedbacksLoaded) {
          if (state.feedbacks.isEmpty) {
            return const SliverFillRemaining(
              child: AppEmptyView(
                message: AppStrings.noFeedbacksYet,
                icon: SolarIconsBold.user,
              ),
            );
          }

          return SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.v18,
              vertical: AppSpacing.v16,
            ),
            sliver: SliverList.separated(
              itemCount: state.feedbacks.length,
              separatorBuilder: (context, index) => const SizedBox(
                height: AppSpacing.v16,
              ),
              itemBuilder: (context, index) {
                return FeedbackAdminCard(
                  feedback: state.feedbacks[index],
                );
              },
            ),
          );
        }

        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
