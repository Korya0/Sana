import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/widgets/app_error_widget.dart';
import 'package:sana/core/constants/app_design.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/features/developer_dashboard/presentation/controller/dashboard_cubit.dart';
import 'package:sana/features/developer_dashboard/presentation/controller/dashboard_state.dart';
import 'package:sana/features/developer_dashboard/presentation/widgets/feedback_admin_card.dart';

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
            child: AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<DashboardCubit>().getFeedbacks(),
            ),
          );
        }

        if (state is DashboardFeedbacksLoaded) {
          if (state.feedbacks.isEmpty) {
            return SliverFillRemaining(
              child: Center(
                child: Text(
                  AppStrings.noFeedbacksYet,
                  style: AppTextStyles.font16W500Grey(context),
                ),
              ),
            );
          }

          return SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDesign.horizontalP18,
              vertical: 16,
            ),
            sliver: SliverList.separated(
              itemCount: state.feedbacks.length,
              separatorBuilder: (context, index) => const SizedBox(
                height: 16,
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
