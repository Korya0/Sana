import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/overlays/bottom_sheet/show_custom_bottom_sheet.dart';
import 'package:sana/core/common/overlays/dialog/custom_info_dialog.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/services/app_date/presentation/controller/app_date_cubit.dart';
import 'package:sana/core/services/app_date/presentation/controller/app_date_state.dart';
import 'package:sana/core/services/app_date/presentation/widgets/hijri_adjustment_bottom_sheet.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/utils/app_date_formatter.dart';

Future<void> showHijriVerificationDialog(
  BuildContext context,
  String hijriStr,
) async {
  await showCustomInfoDialog(
    context: context,
    title: AppStrings.hijriAdjustmtDialogTitle(hijriStr),
    warningText: AppStrings.hijriAdjustmtDialogMessage,
    instructionsTitle: 'للتعديل في أي وقت:',
    instructions: [
      'اضغط على التاريخ الهجري في الشاشة الرئيسية.',
      'اختر تصحيح التاريخ بزيادة أو نقصان يوم ليتوافق مع الرؤية في بلدك.',
    ],
  );
}

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AppDateCubit>().checkMonthlyVerification();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppDateCubit, AppDateState>(
      listenWhen: (previous, current) {
        final prevShow = previous.maybeWhen(
          loaded: (_, show) => show,
          orElse: () => false,
        );
        final currShow = current.maybeWhen(
          loaded: (_, show) => show,
          orElse: () => false,
        );
        return currShow && !prevShow;
      },
      listener: (context, state) async {
        final loadedState = state.mapOrNull(loaded: (s) => s);
        if (loadedState == null) return;

        final hijriStr = AppDateFormatter.hijriFull(loadedState.date.hijri);

        await showHijriVerificationDialog(context, hijriStr);

        if (context.mounted) {
          unawaited(context.read<AppDateCubit>().confirmVerification());
        }
      },
      child: BlocBuilder<AppDateCubit, AppDateState>(
        builder: (context, state) {
          final loadedState = state.mapOrNull(loaded: (s) => s);
          if (loadedState == null) return const SizedBox.shrink();

          final appDate = loadedState.date;

          return GestureDetector(
            onTap: () async {
              await showCustomBottomSheet(
                context,
                child: const HijriAdjustmentBottomSheet(),
              );
            },
            child: Column(
              spacing: AppSpacing.v4,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${AppDateFormatter.hijriFull(appDate.hijri)} هـ',
                  style: AppTextStyles.font12W500primary(context),
                ),
                Text(
                  AppDateFormatter.gregorianFull(
                    appDate.gregorian,
                    AppConstants.locale,
                  ),
                  style: AppTextStyles.font12W500white(context).copyWith(
                    height: 1,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
