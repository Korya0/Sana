// lib/features/prayer/presentation/widgets/settings/calculation_method_widget.dart

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';

import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/common/widgets/custom_bottom_sheet.dart';
import 'package:sana/features/settings/presentation/widgets/settings_tile_widget.dart';

class CalculationMethodWidget extends StatefulWidget {
  final CalculationMethod selectedMethod;
  final Function(CalculationMethod) onMethodSelected;

  const CalculationMethodWidget({
    super.key,
    required this.selectedMethod,
    required this.onMethodSelected,
  });

  @override
  State<CalculationMethodWidget> createState() =>
      _CalculationMethodWidgetState();
}

class _CalculationMethodWidgetState extends State<CalculationMethodWidget> {
  String _getMethodArabicName(CalculationMethod method) {
    final Map<CalculationMethod, String> arabicNames = {
      CalculationMethod.muslim_world_league: 'رابطة العالم الإسلامي',
      CalculationMethod.egyptian: 'الهيئة العامة المصرية للمساحة',
      CalculationMethod.karachi: 'جامعة العلوم الإسلامية - كراتشي',
      CalculationMethod.umm_al_qura: 'أم القرى - مكة المكرمة',
      CalculationMethod.dubai: 'دبي',
      CalculationMethod.moon_sighting_committee: 'لجنة رؤية الهلال',
      CalculationMethod.north_america: 'أمريكا الشمالية',
      CalculationMethod.kuwait: 'الكويت',
      CalculationMethod.qatar: 'قطر',
      CalculationMethod.singapore: 'سنغافورة',
      CalculationMethod.tehran: 'طهران',
      CalculationMethod.turkey: 'تركيا',
    };
    return arabicNames[method] ?? method.name;
  }

  void _showCalculationMethodBottomSheet(BuildContext context) {
    showCustomBottomSheet(
      context,
      title: 'طريقة الحساب',
      child: ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: CalculationMethod.values
            .where((method) => method != CalculationMethod.other)
            .map((method) {
              final isSelected = method == widget.selectedMethod;
              return ListTile(
                title: Text(
                  _getMethodArabicName(method),
                  style: AppTextStyles.font16W600White(context).copyWith(
                    color: isSelected ? AppColors.primary : AppColors.iconWhite,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  widget.onMethodSelected(method);
                  Navigator.pop(context);
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
      title: _getMethodArabicName(widget.selectedMethod),
      onTap: () => _showCalculationMethodBottomSheet(context),
    );
  }
}
