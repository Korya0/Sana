import 'package:flutter/material.dart';
import 'package:sana/core/services/location/data/location_name_service.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:solar_icons/solar_icons.dart';

class CityCountryWidget extends StatelessWidget {
  const CityCountryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: (4),
      children: [
        FutureBuilder(
          future: LocationNameService.getCityAndCountry(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text(
                'غير معروف',
                style: AppTextStyles.font14W600White(context),
                overflow: TextOverflow.ellipsis,
              );
            }
            return Text(
              snapshot.data!,
              style: AppTextStyles.font12W500White(context),
              overflow: TextOverflow.ellipsis,
            );
          },
        ),
        Icon(SolarIconsBold.mapPoint, color: AppColors.gold, size: (14)),
      ],
    );
  }
}
