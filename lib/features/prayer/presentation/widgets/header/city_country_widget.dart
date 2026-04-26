import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/services/location_manager/presentation/controller/location_name/location_name_cubit.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:solar_icons/solar_icons.dart';

class CityCountryWidget extends StatelessWidget {
  const CityCountryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocBuilder<LocationNameCubit, LocationNameState>(
          builder: (context, state) {
            String text;
            if (state is LocationNameLoading) {
              text = AppStrings.loading;
            } else if (state is LocationNameLoaded) {
              text = state.location;
            } else {
              text = AppStrings.unknownLocation;
            }
            return Text(
              text,
              style: AppTextStyles.font12W500White(context),
              overflow: TextOverflow.ellipsis,
            );
          },
        ),
        const Icon(
          SolarIconsBold.mapPoint,
          color: AppColors.iconPrimary,
          size: 14,
        ),
      ],
    );
  }
}
