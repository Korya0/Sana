import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/overlays/toast/app_toast.dart';
import 'package:sana/core/common/slivers/common_sliver_app_bar.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/feedback/presentation/controller/feedback_cubit.dart';
import 'package:sana/features/feedback/presentation/controller/feedback_state.dart';
import 'package:sana/features/feedback/presentation/widgets/feedback_form.dart';
import 'package:sana/features/feedback/presentation/widgets/feedback_header.dart';

class FeedbackIssueView extends StatelessWidget {
  const FeedbackIssueView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FeedbackCubit>(),
      child: const _FeedbackIssueContent(),
    );
  }
}

class _FeedbackIssueContent extends StatelessWidget {
  const _FeedbackIssueContent();

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedbackCubit, FeedbackState>(
      listener: (context, state) {
        if (state is FeedbackSuccess) {
          context.pop();
          AppToast.show(context, state.message);
        } else if (state is FeedbackFailure) {
          AppToast.show(context, state.error, type: AppToastType.error);
        }
      },
      child: const Scaffold(
        body: CustomScrollView(
          slivers: [
            CommonSliverAppBar(title: AppStrings.feedbackTitle),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.v16),
                child: Column(
                  spacing: AppSpacing.v24,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [FeedbackHeader(), FeedbackForm()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
