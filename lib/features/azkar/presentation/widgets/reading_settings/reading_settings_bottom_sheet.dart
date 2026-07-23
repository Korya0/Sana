import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_spacing.dart';
import 'package:sana/features/azkar/presentation/cubit/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/reading_settings/font_size_section.dart';
import 'package:sana/features/azkar/presentation/widgets/reminder/reminder_section.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/utils.dart';

class ReadingSettingsBottomSheet extends StatelessWidget {
  const ReadingSettingsBottomSheet({
    required this.cubit,
    required this.azkarId,
    super.key,
  });

  final ReadingSettingsCubit cubit;
  final String azkarId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.v20,
          vertical: AppSpacing.v16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.readingSettingsTitle,
              style: AppTextStyles.font16W700(context)
                  .copyWith(color: context.color.textPrimary),
              textAlign: TextAlign.center,
            ),
            const AppGap.h(AppSpacing.v24),
            const FontSizeSection(),
            const AppGap.h(AppSpacing.v24),
            ReminderSection(azkarId: azkarId),
          ],
        ),
      ),
    );
  }
}
