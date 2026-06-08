import 'package:flutter/material.dart';
import 'package:sana/core/common/buttons/lightbulb_button.dart';
import 'package:sana/core/common/slivers/common_sliver_app_bar.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/qibla/presentation/widgets/qibla_help_dialog.dart';

class QiblaScaffold extends StatelessWidget {
  const QiblaScaffold({required this.body, super.key});
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CommonSliverAppBar(
            title: AppStrings.qiblaDirection,
            actions: [
              LightbulbButton(
                onPressed: () => showQiblaHelpDialog(context),
              ),
            ],
          ),
          SliverFillRemaining(
            child: body,
          ),
        ],
      ),
    );
  }
}
