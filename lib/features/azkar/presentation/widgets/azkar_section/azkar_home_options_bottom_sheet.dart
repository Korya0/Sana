import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/dividers/custom_app_divider.dart';
import 'package:sana/features/azkar/presentation/widgets/common/azkar_option_section.dart';
import 'package:sana/features/azkar/presentation/widgets/common/azkar_option_tile.dart';

enum AzkarHomeOption { fontSize, createCustomAzkar, manageCustomAzkar }

class AzkarHomeOptionsBottomSheet extends StatelessWidget {
  // Creates sheet
  const AzkarHomeOptionsBottomSheet({super.key});

  // Builds sheet
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(
      horizontal: AppSize.p20,
      vertical: AppSize.p16,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Reading section
        AzkarOptionSection(
          title: AppStrings.readingSettingsTitle,
          children: [
            AzkarOptionTile(
              icon: AppIcons.fontSize,
              label: AppStrings.fontSize,
              onPressed: () => context.popOnce(AzkarHomeOption.fontSize),
            ),
          ],
        ),
        AppGap.h(AppSize.p16),

        // Separator
        const CustomAppDivider(),
        AppGap.h(AppSize.p16),

        // Custom azkar section
        AzkarOptionSection(
          title: AppStrings.customAzkar,
          children: [
            AzkarOptionTile(
              icon: AppIcons.add,
              label: AppStrings.createCustomAzkar,
              onPressed: () =>
                  context.popOnce(AzkarHomeOption.createCustomAzkar),
            ),
            AzkarOptionTile(
              icon: AppIcons.adhkar,
              label: AppStrings.manageCustomAzkar,
              onPressed: () =>
                  context.popOnce(AzkarHomeOption.manageCustomAzkar),
            ),
          ],
        ),
      ],
    ),
  );
}
