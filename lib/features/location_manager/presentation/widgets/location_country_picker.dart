import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/features/location_manager/data/constants/arab_countries.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';

class LocationCountryPicker extends StatelessWidget {
  const LocationCountryPicker({
    required this.countries,
    required this.selectedCountryName,
    required this.onCountrySelected,
    super.key,
  });

  final List<ArabCountry> countries;
  final String? selectedCountryName;
  final ValueChanged<ArabCountry> onCountrySelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CustomAppDivider(),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: countries.length,
          separatorBuilder: (context, index) => const CustomAppDivider(),
          itemBuilder: (context, index) {
            final country = countries[index];
            final isSelected = country.name == selectedCountryName;
            return ListTile(
              title: Text(
                country.name,
                style: isSelected
                    ? AppTextStyles.font16W700(
                        context,
                      ).copyWith(color: context.color.textAccent)
                    : AppTextStyles.font16W700(
                        context,
                      ).copyWith(color: context.color.textPrimary),
              ),
              trailing: isSelected
                  ? Icon(Icons.check, color: context.color.primary)
                  : null,
              onTap: () => onCountrySelected(country),
            );
          },
        ),
      ],
    );
  }
}
