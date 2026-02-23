import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/widgets/custom_bottom_sheet.dart';
import 'package:sana/core/common/widgets/custom_confirmation_dialog.dart';
import 'package:sana/core/utils/app_date_formatter.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_cubit.dart';
import 'package:sana/features/app_date/presentation/widgets/hijri_adjustment_bottom_sheet.dart';

class HijriSocialVerificationDialog extends StatelessWidget {
  const HijriSocialVerificationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final hijri = context.read<AppDateCubit>().state.date.hijri;
    final hijriStr = AppDateFormatter.hijriFull(hijri);

    return CustomConfirmationDialog(
      title: 'تأكيد التاريخ الهجري',
      message:
          'هل اليوم هو $hijriStr في بلدك؟\n'
          'تأكيدك في بداية كل شهر يضمن دقة التاريخ هجرياً حسب رؤية بلدك.',
      confirmText: 'التاريخ صحيح',
      cancelText: 'التعديل الان',
      onConfirm: () {
        unawaited(context.read<AppDateCubit>().confirmVerification());
      },
      onCancel: () async {
        unawaited(context.read<AppDateCubit>().confirmVerification());
        if (context.mounted) {
          await showCustomBottomSheet(
            context,
            child: const HijriAdjustmentBottomSheet(),
          );
        }
      },
    );
  }
}
