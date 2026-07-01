import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/developer_dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:sana/features/developer_dashboard/presentation/cubit/dashboard_state.dart';
import 'package:sana/features/developer_dashboard/presentation/widgets/feedbacks_list_view.dart';

class DeveloperDashboardView extends StatelessWidget {
  const DeveloperDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardCubit, DashboardState>(
      listener: (context, state) {
        if (state is DashboardFeedbacksLoaded && state.actionMessage != null) {
          if (state.isError) {
            AppToast.show(context, state.actionMessage!, type: AppToastType.error);
          } else {
            AppToast.show(context, state.actionMessage!);
          }
        }
      },
      child: const Scaffold(
        body: CustomScrollView(
          slivers: [
            CommonSliverAppBar(
              title: AppStrings.adminPanel,
            ),
            FeedbacksListView(),
          ],
        ),
      ),
    );
  }
}
