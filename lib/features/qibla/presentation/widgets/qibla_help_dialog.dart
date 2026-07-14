import 'package:flutter/material.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';

Future<void> showQiblaHelpDialog(BuildContext context) async {
  await showCustomInfoDialog(
    context: context,
    title: AppStrings.qiblaCompassGuidelines,
    warningText: AppStrings.qiblaCompassNoSensor,
    instructionsTitle: AppStrings.qiblaBestAccuracy,
    instructions: [
      AppStrings.qiblaGuideline1,
      AppStrings.qiblaGuideline2,
      AppStrings.qiblaGuideline3,
    ],
  );
}
