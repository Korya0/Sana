import 'package:flutter/material.dart';
import 'package:sana/core/common/overlays/dialog/custom_info_dialog.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:solar_icons/solar_icons.dart';

Future<void> showQiblaHelpDialog(BuildContext context) async {
  await showCustomInfoDialog(
    context: context,
    title: AppStrings.qiblaCompassGuidelines,
    warningIcon: SolarIconsBold.dangerTriangle,
    warningText: AppStrings.qiblaCompassNoSensor,
    instructionsTitle: AppStrings.qiblaBestAccuracy,
    instructions: [
      AppStrings.qiblaGuideline1,
      AppStrings.qiblaGuideline2,
      AppStrings.qiblaGuideline3,
    ],
  );
}
