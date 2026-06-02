import 'package:flutter/material.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/common/decorations/feature_card_decoration.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/salat_ala_nabi/presentation/widgets/salawat_option_card.dart';

class CustomWorkingHourOption extends StatelessWidget {
  const CustomWorkingHourOption({
    required this.isSelected,
    required this.startTimeText,
    required this.endTimeText,
    required this.onModeTap,
    required this.onStartTimeTap,
    required this.onEndTimeTap,
    super.key,
  });

  final bool isSelected;
  final String startTimeText;
  final String endTimeText;
  final VoidCallback onModeTap;
  final VoidCallback onStartTimeTap;
  final VoidCallback onEndTimeTap;

  @override
  Widget build(BuildContext context) {
    return SalawatOptionCard(
      title: AppStrings.selectCustomTime,
      isSelected: isSelected,
      onTap: onModeTap,
      content: Column(
        children: [
          const SizedBox(height: AppSpacing.v16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.v16),
            child: Row(
              children: [
                Expanded(
                  child: _TimePickerItem(
                    label: AppStrings.from,
                    time: startTimeText,
                    onTap: onStartTimeTap,
                  ),
                ),
                const SizedBox(width: AppSpacing.v12),
                Expanded(
                  child: _TimePickerItem(
                    label: AppStrings.to,
                    time: endTimeText,
                    onTap: onEndTimeTap,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.v16),
        ],
      ),
    );
  }
}

class _TimePickerItem extends StatelessWidget {
  const _TimePickerItem({
    required this.label,
    required this.time,
    required this.onTap,
  });

  final String label;
  final String time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: featureCardDecoration(context: context, 
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        color: context.color.scaffoldBackgroundColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.v12),

            child: Column(
              children: [
                Text(
                  label,
                  style: AppTextStyles.font12W500Grey(context),
                ),
                const SizedBox(height: AppSpacing.v4),
                Text(
                  time,
                  style: AppTextStyles.font16W700primary(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

