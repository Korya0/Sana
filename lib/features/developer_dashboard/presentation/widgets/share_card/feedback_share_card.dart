import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/sharing/presentation/app_info_share.dart';
import 'package:sana/features/sharing/presentation/share_card_container.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/features/developer_dashboard/constants/dashboard_ui_constants.dart';
import 'package:sana/features/developer_dashboard/domain/entities/feedback_entity.dart';
import 'package:sana/features/developer_dashboard/presentation/widgets/feedback_content.dart';
import 'package:solar_icons/solar_icons.dart';

class FeedbackShareCard extends StatelessWidget {
  const FeedbackShareCard({
    required this.feedback,
    super.key,
  });
  final FeedbackEntity feedback;

  @override
  Widget build(BuildContext context) {
    return ShareCardContainer(
      child: Container(
        width: double.infinity,
        decoration: customAppCardDecoration(context).copyWith(
          borderRadius: BorderRadius.zero,
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              right: DashboardUiConstants.shareCardBackgroundIconRight,
              bottom: DashboardUiConstants.shareCardBackgroundIconBottom,
              child: Icon(
                SolarIconsBold.user,
                size: DashboardUiConstants.shareCardBackgroundIconSize.r(context),
                color: context.color.textPrimary.withValues(alpha: 0.05),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.v24,
                vertical: AppSpacing.v40,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FeedbackContent(feedback: feedback, isSharing: true),
                  const AppGap.h(AppSpacing.v32),
                  const CustomAppDivider(),
                  const AppGap.h(AppSpacing.v32),
                  const AppInfoShare(department: AppStrings.adminPanel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
