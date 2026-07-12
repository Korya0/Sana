import 'package:sana/core/routing/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/features/prayer/constants/prayer_settings_names.dart';
import 'package:sana/features/prayer/domain/entities/prayer_calculation_settings_entity.dart';
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
                    style: AppTextStyles.font16W700(context)
                        .copyWith(color: context.color.textPrimary)
                        .copyWith(
                          color: isSelected
                              ? context.color.textAccent
                              : context.color.textPrimary,
                        ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check, color: context.color.primary)
                      : null,
                  onTap: () {
                    onMadhabSelected(madhab);
                    AppNavigator.pop(context);
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
