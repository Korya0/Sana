import 'package:sana/core/routing/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/features/feedback/presentation/cubit/feedback_cubit.dart';
import 'package:sana/features/feedback/presentation/cubit/feedback_state.dart';
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
          AppToast.show(context, state.message);
          AppNavigator.pop(context);
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FeedbackHeader(),
                    AppGap.h(AppSpacing.v24),
                    FeedbackForm(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
