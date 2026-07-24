import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/app_date/presentation/cubits/app_date_cubit.dart';
import 'package:sana/features/app_date/presentation/cubits/app_date_state.dart';
import 'package:sana/features/app_date/presentation/widgets/hijri_adjustment_bottom_sheet.dart';
import 'package:sana/core/common/overlays/bottom_sheet/app_bottom_sheet.dart';

Future<void> showHijriVerificationDialog(
  BuildContext context,
  String hijriStr,
) async {
  await showCustomInfoDialog(
    context: context,
    title: AppStrings.hijriAdjustmentDialogTitle(hijriStr),
    warningText: AppStrings.hijriAdjustmentDialogMessage,
    instructionsTitle: AppStrings.hijriEditAtAnyTime,
    instructions: [
      AppStrings.hijriClickToEditHint,
      AppStrings.hijriAdjustmentBottomSheetTitle,
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
        return current is AppDateVerificationDialogRequested;
      },
      listener: (context, state) async {
        if (state is! AppDateVerificationDialogRequested) {
          return;
        }

        final hijriStr = state.date.hijri.toHijriFull();

        await showHijriVerificationDialog(context, hijriStr);
        if (context.mounted) {
          unawaited(context.read<AppDateCubit>().confirmMonthlyVerification());
        }
      },
      child: BlocBuilder<AppDateCubit, AppDateState>(
        builder: (context, state) {
          if (state.date == null) return const SizedBox.shrink();

          final appDate = state.date!;

          return GestureDetector(
            onTap: () async {
              final cubit = context.read<AppDateCubit>();
              await AppBottomSheet.show<void>(
                context: context,
                child: BlocProvider.value(
                  value: cubit,
                  child: const HijriAdjustmentBottomSheet(),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${appDate.hijri.toHijriFull()} ${AppStrings.hijriSymbol}',
                  style: AppTextStyles.font12W700(context).copyWith(
                    color: context.color.textAccent,
                  ),
                  maxLines: 1,
                ),
                Text(
                  appDate.gregorian.toGregorianFull(
                    AppConstants.ar,
                  ),
                  maxLines: 1,
                  style: AppTextStyles.font12W700(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
