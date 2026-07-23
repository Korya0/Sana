import 'package:sana/core/routing/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/features/prayer/constants/prayer_settings_names.dart';
import 'package:sana/features/prayer/domain/entities/prayer_calculation_settings_entity.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_settings/settings_tile_widget.dart';
import 'package:sana/core/common/overlays/bottom_sheet/app_bottom_sheet.dart';
import 'package:sana/core/constants/app_spacing.dart';

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

    await AppBottomSheet.show<void>(
      context: context,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.madhabTitle,
              style: AppTextStyles.font16W700(context)
                  .copyWith(color: context.color.textPrimary),
              textAlign: TextAlign.center,
            ),
            const AppGap.h(AppSpacing.v24),
            Flexible(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: madhabs.length,
                separatorBuilder: (context, index) => const AppGap.h(AppSpacing.v12),
                itemBuilder: (context, index) {
                  final madhab = madhabs[index];
                  final isSelected = madhab == selectedMadhab;
                  return AppSelectionCard(
                    title: PrayerSettingsNames.getMadhabName(madhab),
                    isSelected: isSelected,
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
