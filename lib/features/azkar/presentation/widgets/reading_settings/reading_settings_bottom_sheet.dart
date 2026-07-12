import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/reading_settings/font_size_section.dart';
import 'package:sana/features/azkar/presentation/widgets/reminder_section.dart';

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
            const FontSizeSection(),
            const SizedBox(height: 24),
            ReminderSection(azkarId: azkarId),
          ],
        ),
      ),
    );
  }
}
