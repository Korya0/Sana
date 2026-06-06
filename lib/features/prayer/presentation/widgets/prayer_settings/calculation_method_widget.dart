import 'package:flutter/material.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/common/widgets/custom_app_divider.dart';
import 'package:sana/core/common/overlays/bottom_sheet/show_custom_bottom_sheet.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/features/prayer/constants/prayer_settings_names.dart';
import 'package:sana/features/prayer/data/models/prayer_calculation_settings.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_settings/settings_tile_widget.dart';

class CalculationMethodWidget extends StatelessWidget {
  const CalculationMethodWidget({
    required this.selectedMethod,
    required this.onMethodSelected,
    super.key,
  });

  final CalculationMethodEntity selectedMethod;
  final ValueChanged<CalculationMethodEntity> onMethodSelected;

  Future<void> _showCalculationMethodBottomSheet(BuildContext context) async {
    final methods = CalculationMethodEntity.values
        .where((method) => method != CalculationMethodEntity.other)
        .toList();

    await showCustomBottomSheet(
      context,
      title: AppStrings.calculationMethodTitle,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomAppDivider(),
          Flexible(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: methods.length,
              itemBuilder: (context, index) {
                final method = methods[index];
                final isSelected = method == selectedMethod;
                return ListTile(
                  title: Text(
                    PrayerSettingsNames.getMethodName(method),
                    style: AppTextStyles.font16W700White(context).copyWith(
                      color: isSelected
                          ? context.color.textAccent
                          : context.color.textPrimary,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check, color: context.color.primary)
                      : null,
                  onTap: () {
                    onMethodSelected(method);
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
      title: PrayerSettingsNames.getMethodName(selectedMethod),
      onTap: () => _showCalculationMethodBottomSheet(context),
    );
  }
}


