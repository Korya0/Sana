import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/common/option_section.dart';
import 'package:sana/features/azkar/presentation/widgets/common/option_tile.dart';
import 'package:sana/features/azkar/presentation/widgets/common/haptic_feedback_toggle_tile.dart';

enum AzkarHomeOption { fontSize, createCustomAzkar, manageCustomAzkar }

class AzkarHomeOptionsBottomSheet extends StatelessWidget {
  // Creates sheet
  const AzkarHomeOptionsBottomSheet({
    required this.azkarTasbeehSettingsCubit,
    super.key,
  });

  final AzkarTasbeehSettingsCubit azkarTasbeehSettingsCubit;

  // Builds sheet
  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: azkarTasbeehSettingsCubit,
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.p20,
        vertical: AppSize.p16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Reading section
          OptionSection(
            title: AppStrings.azkarTasbeehSettingsTitle,
            children: [
              OptionTile(
                icon: AppIcons.fontSize,
                label: AppStrings.fontSize,
                onPressed: () => context.popOnce(AzkarHomeOption.fontSize),
              ),
              // Haptics
              const HapticFeedbackToggleTile(),
            ],
          ),
          AppGap.h(AppSize.p16),

          // Custom azkar section
          OptionSection(
            title: AppStrings.customAzkar,
            children: [
              OptionTile(
                icon: AppIcons.add,
                label: AppStrings.createCustomAzkar,
                onPressed: () =>
                    context.popOnce(AzkarHomeOption.createCustomAzkar),
              ),
              OptionTile(
                icon: AppIcons.adhkar,
                label: AppStrings.manageCustomAzkar,
                onPressed: () =>
                    context.popOnce(AzkarHomeOption.manageCustomAzkar),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
