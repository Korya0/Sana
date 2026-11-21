import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/common/azkar_options_sheet_scaffold.dart';
import 'package:sana/features/azkar/presentation/widgets/common/haptic_feedback_toggle_tile.dart';
import 'package:sana/features/azkar/presentation/widgets/common/option_tile.dart';
import 'package:sana/features/azkar/presentation/widgets/common/volume_button_count_toggle_tile.dart';

enum AzkarHomeOption { manageCustomAzkar, fontSize }

class AzkarHomeOptionsBottomSheet extends StatelessWidget {
  const AzkarHomeOptionsBottomSheet({
    required this.azkarTasbeehSettingsCubit,
    super.key,
  });

  final AzkarTasbeehSettingsCubit azkarTasbeehSettingsCubit;

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: azkarTasbeehSettingsCubit,
    child: AzkarOptionsSheetScaffold(
      title: AppStrings.azkarOptions,
      onDismiss: () => context.popOnce(),
      children: [
        OptionTile(
          icon: AppIcons.adhkar,
          label: AppStrings.manageCustomAzkar,
          onPressed: () => context.popOnce(AzkarHomeOption.manageCustomAzkar),
        ),
        OptionTile(
          icon: AppIcons.fontSize,
          label: AppStrings.fontSize,
          onPressed: () => context.popOnce(AzkarHomeOption.fontSize),
        ),
        const HapticFeedbackToggleTile(),
        const VolumeButtonCountToggleTile(),
      ],
    ),
  );
}
