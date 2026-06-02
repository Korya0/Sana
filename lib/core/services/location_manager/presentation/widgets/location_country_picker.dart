import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/decorations/custom_app_divider.dart';
import 'package:sana/core/services/location_manager/data/constants/arab_countries.dart';
import 'package:sana/core/services/location_manager/presentation/cubit/location_permission/location_cubit.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class LocationCountryPicker extends StatelessWidget {
  const LocationCountryPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LocationCubit>();
    final selectedCountryName = cubit.getStoredLocationName();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CustomAppDivider(),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: arabCountries.length,
          separatorBuilder: (context, index) => const CustomAppDivider(),
          itemBuilder: (context, index) {
            final country = arabCountries[index];
            final isSelected = country.name == selectedCountryName;
            return ListTile(
              title: Text(
                country.name,
                style: isSelected
                    ? AppTextStyles.font16W700primary(context)
                    : AppTextStyles.font16W700White(context),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: AppColors.iconAccent)
                  : null,
              onTap: () async {
                Navigator.of(context).pop();
                await cubit.saveManualLocation(
                  lat: country.lat,
                  lng: country.lng,
                  name: country.name,
                );
              },
            );
          },
        ),
      ],
    );
  }
}


