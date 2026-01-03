import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/services/date_gregorian_and_hijri/app_date_formatter.dart';
import 'package:sana/core/services/date_gregorian_and_hijri/cubit/app_date_cubit.dart';
import 'package:sana/core/services/date_gregorian_and_hijri/cubit/app_date_state.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class HijriAndGregorianDateWidget extends StatelessWidget {
  const HijriAndGregorianDateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppDateCubit, AppDateState>(
      builder: (context, state) {
        final appDate = state.date;

        return Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppDateFormatter.hijriFull(appDate.hijri),
              style: AppTextStyles.font12W500(
                context,
              ).copyWith(color: AppColors.textPrimary, height: 1),
            ),
            Text(
              AppDateFormatter.gregorianFull(
                appDate.gregorian,
                AppConstants.locale,
              ),
              style: AppTextStyles.font12W500(
                context,
              ).copyWith(color: AppColors.textWhite, height: 1),
            ),
          ],
        );
      },
    );
  }
}
