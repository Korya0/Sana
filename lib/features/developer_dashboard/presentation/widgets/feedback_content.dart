import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/developer_dashboard/data/models/dashboard_feedback_model.dart';
import 'package:sana/features/feedback/data/constants/feedback_keys.dart';
import 'package:solar_icons/solar_icons.dart';

class FeedbackContent extends StatelessWidget {
  const FeedbackContent({
    required this.feedback,
    this.isSharing = false,
    super.key,
  });

  final DashboardFeedbackModel feedback;
  final bool isSharing;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(feedback.timestamp);
    final formattedDate = date != null
        ? DateFormat(AppConstants.dateTimeFormat).format(date)
        : AppStrings.notAvailable;

    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isSharing ? AppStrings.userSuggestion : formattedDate,
                style: isSharing
                    ? AppTextStyles.font14W600primary(context)
                    : AppTextStyles.font12W700White(context).copyWith(
                        color: AppColors.textPrimary,
                      ),
              ),
              if (!isSharing)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.v8,
                    vertical: AppSpacing.v4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.v4),
                  ),
                  child: Text(
                    feedback.metadata[FeedbackFirestoreKeys.platform]
                            ?.toString() ??
                        AppStrings.unknown,
                    style: AppTextStyles.font10W600White(context).copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                )
              else
                Text(
                  formattedDate,
                  style: AppTextStyles.font12W700Grey(context),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.v16),
          Text(
            feedback.message,
            style: isSharing
                ? AppTextStyles.font18W800White(context).copyWith(height: 1.8)
                : AppTextStyles.font16W600White(context).copyWith(height: 1.6),
            textAlign: TextAlign.start,
            maxLines: isSharing ? 12 : null,
            overflow: isSharing ? TextOverflow.ellipsis : null,
          ),
          if (!isSharing) ...[
            const SizedBox(height: AppSpacing.v16),
            Container(
              padding: const EdgeInsets.all(AppSpacing.v12),
              decoration: BoxDecoration(
                color: AppColors.scaffoldBackground,
                borderRadius: BorderRadius.circular(AppSpacing.radiusS),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (feedback.contactInfo.isNotEmpty &&
                      feedback.contactInfo != AppStrings.notAvailable)
                    _buildMetaRow(
                      context,
                      Icons.contact_mail_outlined,
                      feedback.contactInfo,
                    ),
                  if (feedback.contactInfo.isNotEmpty &&
                      feedback.contactInfo != AppStrings.notAvailable)
                    const SizedBox(height: AppSpacing.v8),
                  _buildMetaRow(
                    context,
                    Icons.phone_android_outlined,
                    feedback.metadata[FeedbackFirestoreKeys.deviceModel]
                            ?.toString() ??
                        AppStrings.unknownDevice,
                  ),
                  const SizedBox(height: 8),
                  _buildMetaRow(
                    context,
                    Icons.settings_outlined,
                    feedback.metadata[FeedbackFirestoreKeys.osVersion]
                            ?.toString() ??
                        AppStrings.unknownOS,
                  ),
                  const SizedBox(height: 8),
                  _buildMetaRow(
                    context,
                    SolarIconsOutline.infoSquare,
                    AppStrings.appVersionWithBuild(
                      feedback.metadata[FeedbackFirestoreKeys.appVersion]
                              ?.toString() ??
                          '?',
                      feedback.metadata[FeedbackFirestoreKeys.buildNumber]
                              ?.toString() ??
                          '?',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetaRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.iconWhite),
        const SizedBox(width: AppSpacing.v8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.font12W700White(context),
          ),
        ),
      ],
    );
  }
}
