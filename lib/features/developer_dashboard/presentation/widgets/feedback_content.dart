import 'package:sana/core/common/common.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/constants/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/developer_dashboard/domain/entities/feedback_entity.dart';
import 'package:sana/features/feedback/constants/feedback_keys.dart';
import 'package:solar_icons/solar_icons.dart';

class FeedbackContent extends StatelessWidget {
  const FeedbackContent({
    required this.feedback,
    this.isSharing = false,
    super.key,
  });

  final FeedbackEntity feedback;
  final bool isSharing;

  @override
  Widget build(BuildContext context) {
    // ... skipping until the contact info ...
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
                isSharing
                    ? AppStrings.userSuggestion
                    : feedback
                          .timestamp, // Assuming formattedDate was moved or we just use timestamp temporarily
                style: isSharing
                    ? AppTextStyles.font14W700(
                        context,
                      ).copyWith(color: context.color.textAccent)
                    : AppTextStyles.font12W700(
                        context,
                      ).copyWith(color: context.color.textAccent),
              ),
              if (!isSharing)
                AppActionCard(
                  backgroundColor: context.color.primary.withValues(alpha: 0.1),
                  borderColor: Colors.transparent,
                  title: feedback.metadata[FeedbackFirestoreKeys.platform]?.toString() ?? AppStrings.unknown,
                  textStyle: AppTextStyles.font12W700(
                      context,
                    ).copyWith(color: context.color.textAccent),
                )
              else
                Text(
                  feedback.timestamp,
                  style: AppTextStyles.font12W700(
                    context,
                  ).copyWith(color: context.color.textSecondary),
                ),
            ],
          ),
          const AppGap.h(AppSpacing.v16),
          Text(
            feedback.message,
            style: isSharing
                ? AppTextStyles.font20W700(
                    context,
                  ).copyWith(color: context.color.textPrimary, height: 1.8)
                : AppTextStyles.font16W700(
                    context,
                  ).copyWith(color: context.color.textPrimary, height: 1.6),
            textAlign: TextAlign.start,
            maxLines: isSharing ? 12 : null,
            overflow: isSharing ? TextOverflow.ellipsis : null,
          ),
          if (!isSharing) ...[
            const AppGap.h(AppSpacing.v16),
            AppSectionCard(
              padding: const EdgeInsets.all(AppSpacing.v12),
              backgroundColor: context.color.scaffoldBackgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MetaRow(
                    icon: Icons.contact_mail,
                    text:
                        (feedback.contactInfo == null ||
                            feedback.contactInfo!.isEmpty)
                        ? AppStrings.notAvailable
                        : feedback.contactInfo!,
                  ),
                  const AppGap.h(AppSpacing.v8),
                  _MetaRow(
                    icon: Icons.phone_android,
                    text:
                        feedback.metadata[FeedbackFirestoreKeys.deviceModel]
                            ?.toString() ??
                        AppStrings.unknownDevice,
                  ),
                  const AppGap.h(AppSpacing.v8),
                  _MetaRow(
                    icon: Icons.settings_outlined,
                    text:
                        feedback.metadata[FeedbackFirestoreKeys.osVersion]
                            ?.toString() ??
                        AppStrings.unknownOS,
                  ),
                  const AppGap.h(AppSpacing.v8),
                  _MetaRow(
                    icon: SolarIconsBold.infoSquare,
                    text: AppStrings.appVersionWithBuild(
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
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: AppSpacing.s16.r(context), color: context.color.textPrimary),
        const AppGap.w(AppSpacing.v8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.font12W700(
              context,
            ).copyWith(color: context.color.textPrimary),
          ),
        ),
      ],
    );
  }
}
