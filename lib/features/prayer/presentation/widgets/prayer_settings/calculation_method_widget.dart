import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/widgets/custom_bottom_sheet.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/prayer/data/constants/prayer_settings_names.dart';
import 'package:sana/features/prayer/data/constants/prayer_strings.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_settings/settings_tile_widget.dart';

class CalculationMethodWidget extends StatelessWidget {
  const CalculationMethodWidget({
    required this.selectedMethod,
    required this.onMethodSelected,
    super.key,
  });
  final CalculationMethod selectedMethod;
  final ValueChanged<CalculationMethod> onMethodSelected;

  Future<void> _showCalculationMethodBottomSheet(BuildContext context) async {
    await showCustomBottomSheet(
      context,
      title: PrayerStrings.calculationMethodTitle,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: CalculationMethod.values
            .where((method) => method != CalculationMethod.other)
            .map((method) {
              final isSelected = method == selectedMethod;
              return ListTile(
                title: Text(
                  PrayerSettingsNames.getMethodName(method),
                  style: AppTextStyles.font16W600White(context).copyWith(
                    color: isSelected ? AppColors.primary : AppColors.iconWhite,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  onMethodSelected(method);
                  context.pop();
                },
              );
            })
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsTileWidget(
      icon: Icons.calculate_outlined,
      title: PrayerSettingsNames.getMethodName(selectedMethod),
      onTap: () => _showCalculationMethodBottomSheet(context),
    );
  }
}
