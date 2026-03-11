import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/slivers/common_sliver_app_bar.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/developer_dashboard/presentation/widgets/feedbacks_list_view.dart';

class DeveloperDashboardView extends StatelessWidget {
  const DeveloperDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [
          CommonSliverAppBar(
            title: AppStrings.developerDashboard,
          ),
          FeedbacksListView(),
        ],
      ),
    );
  }
}
