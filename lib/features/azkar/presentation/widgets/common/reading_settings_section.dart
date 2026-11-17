import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/features/azkar/presentation/widgets/common/haptic_feedback_toggle_tile.dart';
import 'package:sana/features/azkar/presentation/widgets/common/option_section.dart';
import 'package:sana/features/azkar/presentation/widgets/common/option_tile.dart';

class ReadingSettingsSection extends StatelessWidget {
  const ReadingSettingsSection({required this.onFontSizeTap, super.key});

  final VoidCallback onFontSizeTap;

  @override
  Widget build(BuildContext context) => OptionSection(
    title: AppStrings.azkarTasbeehSettingsTitle,
    children: [
      OptionTile(
        icon: AppIcons.fontSize,
        label: AppStrings.fontSize,
        onPressed: onFontSizeTap,
      ),
      const HapticFeedbackToggleTile(),
    ],
  );
}
