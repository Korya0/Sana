import 'dart:async';

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
import 'package:sana/features/app_date/presentation/widgets/hijri_social_verification_dialog.dart';

class HijriAndGregorianDateWidget extends StatefulWidget {
  const HijriAndGregorianDateWidget({super.key});

  @override
  State<HijriAndGregorianDateWidget> createState() =>
      _HijriAndGregorianDateWidgetState();
}

class _HijriAndGregorianDateWidgetState
    extends State<HijriAndGregorianDateWidget> {
  @override
  void initState() {
    super.initState();
    // التحقق من الحالة الأولية بعد بناء الـ widget tree بالكامل
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final shouldShow = context
          .read<AppDateCubit>()
          .state
          .showVerificationDialog;
      if (shouldShow) {
        unawaited(_showVerificationDialog());
      }
    });
  }

  Future<void> _showVerificationDialog() async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const HijriSocialVerificationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppDateCubit, AppDateState>(
      listenWhen: (previous, current) =>
          current.showVerificationDialog && !previous.showVerificationDialog,
      listener: (context, state) async {
        await _showVerificationDialog();
      },
      child: BlocBuilder<AppDateCubit, AppDateState>(
        builder: (context, state) {
          final appDate = state.date;

          return GestureDetector(
            onTap: () async {
              await showCustomBottomSheet(
                context,
                child: const HijriAdjustmentBottomSheet(),
              );
            },
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
          );
        },
      ),
    );
  }
}
