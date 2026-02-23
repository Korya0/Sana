import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/widgets/custom_bottom_sheet.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/utils/app_date_formatter.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_cubit.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_state.dart';
import 'package:sana/features/app_date/presentation/widgets/hijri_adjustment_bottom_sheet.dart';
import 'package:sana/features/app_date/presentation/widgets/hijri_pulse.dart';
import 'package:sana/features/app_date/presentation/widgets/hijri_social_verification_dialog.dart';

class HijriAndGregorianDateWidget extends StatelessWidget {
  const HijriAndGregorianDateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppDateCubit, AppDateState>(
      listenWhen: (previous, current) =>
          current.showVerificationDialog && !previous.showVerificationDialog,
      listener: (context, state) {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (context) => const HijriSocialVerificationDialog(),
        );
      },
      child: BlocBuilder<AppDateCubit, AppDateState>(
        builder: (context, state) {
          final appDate = state.date;

          return GestureDetector(
            onTap: () async {
              await context.read<AppDateCubit>().clearPulse();
              if (context.mounted) {
                await showCustomBottomSheet(
                  context,
                  child: const HijriAdjustmentBottomSheet(),
                );
              }
            },

            child: HijriPulse(
              showPulse: state.showPulse,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppDateFormatter.hijriFull(appDate.hijri),
                    style: AppTextStyles.font12W500(
                      context,
                    ).copyWith(color: AppColors.textPrimary, height: 1),
                  ),
                  const SizedBox(height: 4),
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
              ),
            ),
          );
        },
      ),
    );
  }
}
