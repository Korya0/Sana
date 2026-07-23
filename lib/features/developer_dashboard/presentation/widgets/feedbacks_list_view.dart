import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/constants/app_spacing.dart';
import 'package:sana/features/developer_dashboard/data/models/dashboard_feedback_model.dart';
import 'package:sana/features/developer_dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:sana/features/developer_dashboard/presentation/cubit/dashboard_state.dart';
import 'package:sana/features/developer_dashboard/presentation/widgets/feedback_admin_card.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:solar_icons/solar_icons.dart';

class FeedbacksListView extends StatelessWidget {
  const FeedbacksListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardFeedbacksLoading) {
          return SliverFillRemaining(
            child: Skeletonizer(
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.v18,
                  vertical: AppSpacing.v16,
                ),
                itemCount: 5,
                separatorBuilder: (context, index) =>
                    const AppGap.h(AppSpacing.v16),
                itemBuilder: (context, index) {
                  return const FeedbackAdminCard(
                    feedback: DashboardFeedbackModel(
                      id: 'dummy',

                      message: 'وصف تجريبي للمشكلة يظهر أثناء التحميل',

                      timestamp: '2023-01-01T00:00:00.000Z',
                      metadata: {},
                    ),
                  );
                },
              ),
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
              separatorBuilder: (context, index) =>
                  const AppGap.h(AppSpacing.v16),
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
