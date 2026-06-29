import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/services/location_manager/presentation/cubit/location_name/location_name_cubit.dart';
import 'package:sana/core/services/location_manager/presentation/cubit/location_name/location_name_state.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:solar_icons/solar_icons.dart';

class CityCountryWidget extends StatelessWidget {
  const CityCountryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationNameCubit, LocationNameState>(
      builder: (context, state) {
        final isLoading =
            state is LocationNameLoading || state is LocationNameInitial;
        final locationText = state is LocationNameLoaded
            ? state.location
            : (state is LocationNameError
                  ? AppStrings.unknownLocation
                  : 'موقع المستخدم الحالي');

        return Skeletonizer(
          enabled: isLoading,
          child: Row(
            spacing: AppSpacing.v4,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                locationText,
                style: AppTextStyles.font12W700(
                  context,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Icon(
                SolarIconsBold.mapPoint,
                color: context.color.primary,
                size: 14.r(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
