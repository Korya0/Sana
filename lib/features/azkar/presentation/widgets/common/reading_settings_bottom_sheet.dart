import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/features/azkar/presentation/widgets/common/azkar_options_sheet_scaffold.dart';
import 'package:sana/features/azkar/presentation/widgets/common/haptic_feedback_toggle_tile.dart';
import 'package:sana/features/azkar/presentation/widgets/common/option_tile.dart';
import 'package:sana/features/azkar/presentation/widgets/common/volume_button_count_toggle_tile.dart';

class ReadingSettingsBottomSheet extends StatelessWidget {
  const ReadingSettingsBottomSheet({super.key, this.isNested = false});

  final bool isNested;

  @override
  Widget build(BuildContext context) => AzkarOptionsSheetScaffold(
    title: AppStrings.azkarTasbeehSettingsTitle,
    isNested: isNested,
    onDismiss: () => context.popOnce(isNested ? true : null),
    children: [
      OptionTile(
        icon: AppIcons.fontSize,
        label: AppStrings.fontSize,
        onPressed: () => context.popOnce(true),
      ),
      const HapticFeedbackToggleTile(),
      const VolumeButtonCountToggleTile(),
    ],
  );
}
