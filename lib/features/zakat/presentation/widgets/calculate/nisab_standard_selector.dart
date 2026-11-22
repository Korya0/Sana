import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/features/zakat/data/models/zakat_input.dart';

class NisabStandardSelector extends StatelessWidget {
  const NisabStandardSelector({
    super.key,
    required this.standard,
    required this.onStandardChanged,
    required this.goldKarat,
    required this.onKaratChanged,
  });

  final NisabStandard standard;
  final ValueChanged<NisabStandard> onStandardChanged;
  final int goldKarat;
  final ValueChanged<int?> onKaratChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label: AppStrings.zakatChooseStandard,
          child: ExcludeSemantics(
            child: Text(
              AppStrings.zakatChooseStandard,
              style: AppTextStyles.font16W400Primary(context),
            ),
          ),
        ),
        AppGap.h(AppSize.p12),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<NisabStandard>(
            segments: [
              for (final s in NisabStandard.values)
                ButtonSegment(
                  value: s,
                  label: Text(AppStrings.zakatNisabStandardLabel(s.label)),
                ),
            ],
            selected: {standard},
            onSelectionChanged: (s) => onStandardChanged(s.first),
          ),
        ),
        AppGap.h(AppSize.p16),
        DropdownButtonFormField<int>(
          key: ValueKey('gold_karat_$goldKarat'),
          initialValue: goldKarat,
          decoration: InputDecoration(
            labelText: AppStrings.zakatGoldKaratLabel,
            helperText: AppStrings.zakatGoldKaratHelper,
            helperStyle: AppTextStyles.font12W500Secondary(context),
          ),
          items: [
            for (final karat in GoldKarats.common)
              DropdownMenuItem(
                value: karat,
                child: Text(AppStrings.zakatKaratLabel(karat)),
              ),
          ],
          onChanged: onKaratChanged,
        ),
      ],
    );
  }
}
