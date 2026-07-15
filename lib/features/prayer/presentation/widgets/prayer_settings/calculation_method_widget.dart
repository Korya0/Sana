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
import 'package:sana/core/theme/app_spacing.dart';

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
              AppStrings.calculationMethodTitle,
              style: AppTextStyles.font16W700(context)
                  .copyWith(color: context.color.textPrimary),
              textAlign: TextAlign.center,
            ),
            const AppGap.h(AppSpacing.v24),
            Flexible(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: methods.length,
                separatorBuilder: (context, index) => const AppGap.h(AppSpacing.v12),
                itemBuilder: (context, index) {
                  final method = methods[index];
                  final isSelected = method == selectedMethod;
                  return AppSelectionCard(
                    title: PrayerSettingsNames.getMethodName(method),
                    isSelected: isSelected,
                    onTap: () {
                      onMethodSelected(method);
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
      title: PrayerSettingsNames.getMethodName(selectedMethod),
      onTap: () => _showCalculationMethodBottomSheet(context),
    );
  }
}
