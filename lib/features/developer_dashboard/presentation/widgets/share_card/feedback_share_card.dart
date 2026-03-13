import 'package:flutter/material.dart';
import 'package:sana/core/common/decorations/custom_app_divider.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/sharing/presentation/app_info_share.dart';
import 'package:sana/features/sharing/presentation/share_card_container.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/common/decorations/custom_app_card_decoration.dart';
import 'package:sana/features/developer_dashboard/data/models/dashboard_feedback_model.dart';
import 'package:sana/features/developer_dashboard/presentation/widgets/feedback_content.dart';
import 'package:solar_icons/solar_icons.dart';

class FeedbackShareCard extends StatelessWidget {
  const FeedbackShareCard({
    required this.feedback,
    super.key,
  });
  final DashboardFeedbackModel feedback;

  @override
  Widget build(BuildContext context) {
    return ShareCardContainer(
      child: Container(
        width: double.infinity,
        decoration: customAppCardDecoration().copyWith(
          borderRadius: BorderRadius.zero,
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              right: -10,
              bottom: -20,
              child: Icon(
                SolarIconsBold.user,
                size: 150,
                color: AppColors.white.withValues(alpha: 0.05),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FeedbackContent(feedback: feedback, isSharing: true),
                  const SizedBox(height: 32),
                  const CustomAppDivider(),
                  const SizedBox(height: 32),
                  const AppInfoShare(department: AppStrings.developerDashboard),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
