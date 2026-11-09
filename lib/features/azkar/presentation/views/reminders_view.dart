import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/widgets/slivers/common_sliver_app_bar.dart';
import 'package:sana/core/widgets/views/app_empty_view.dart';

class RemindersView extends StatelessWidget {
  const RemindersView({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: CustomScrollView(
      slivers: [
        // App bar
        CommonSliverAppBar(
          title: AppStrings.remindersTitle,
        ),

        // Body — temporary empty state
        SliverFillRemaining(
          hasScrollBody: false,
          child: AppEmptyView(title: AppStrings.remindersEmpty),
        ),
      ],
    ),
  );
}

