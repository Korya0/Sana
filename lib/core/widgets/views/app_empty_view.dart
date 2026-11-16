import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/views/app_state_view.dart';

class AppEmptyView extends StatelessWidget {
  const AppEmptyView({
    super.key,
    this.title = AppStrings.emptyTitle,
    this.message,
  });

  final String title;
  final String? message;

  // Builds empty view
  @override
  Widget build(BuildContext context) => AppStateView(
    icon: AppIcons.empty,
    title: title,
    message: message,
  );
}
