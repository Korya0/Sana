import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_design.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/developer_dashboard/data/models/dashboard_feedback_model.dart';
import 'package:sana/features/developer_dashboard/presentation/widgets/admin_feedback_actions.dart';
import 'package:sana/features/developer_dashboard/presentation/widgets/feedback_content.dart';
import 'package:sana/features/developer_dashboard/presentation/widgets/share_card/feedback_share_card.dart';

class FeedbackAdminCard extends StatelessWidget {
  const FeedbackAdminCard({
    required this.feedback,
    super.key,
  });

  final DashboardFeedbackModel feedback;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.secondaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.gold.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Body of the feedback
            Padding(
              padding: const EdgeInsets.all(AppDesign.horizontalP18),
              child: FeedbackContent(feedback: feedback),
            ),
            // Actions (Delete, Share) at the bottom
            AdminFeedbackActions(
              feedback: feedback,
              shareChild: FeedbackShareCard(
                feedback: feedback,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
