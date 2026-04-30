import 'package:flutter/material.dart';
import 'package:sana/core/common/decorations/custom_app_divider.dart';
import 'package:sana/core/common/overlays/bottom_sheet/show_custom_bottom_sheet.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/prayer/constants/prayer_settings_names.dart';
import 'package:sana/features/prayer/data/models/prayer_calculation_settings.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_settings/settings_tile_widget.dart';

class MadhabWidget extends StatelessWidget {
  const MadhabWidget({
    required this.selectedMadhab,
    required this.onMadhabSelected,
    super.key,
  });

  final MadhabEntity selectedMadhab;
  final ValueChanged<MadhabEntity> onMadhabSelected;

  Future<void> _showMadhabBottomSheet(BuildContext context) async {
    const madhabs = MadhabEntity.values;

    await showCustomBottomSheet(
      context,
      title: AppStrings.madhabTitle,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomAppDivider(),
          Flexible(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: madhabs.length,
              itemBuilder: (context, index) {
                final madhab = madhabs[index];
                final isSelected = madhab == selectedMadhab;
                return ListTile(
                  title: Text(
                    PrayerSettingsNames.getMadhabName(madhab),
                    style: AppTextStyles.font16W600White(context).copyWith(
                      color: isSelected
                          ? AppColors.textPrimary
                          : AppColors.textWhite,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.iconPrimary)
                      : null,
                  onTap: () {
                    onMadhabSelected(madhab);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsTileWidget(
      title: PrayerSettingsNames.getMadhabName(selectedMadhab),
      onTap: () => _showMadhabBottomSheet(context),
    );
  }
}
