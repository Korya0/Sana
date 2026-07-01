import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:solar_icons/solar_icons.dart';

import 'package:sana/features/azkar/constants/azkar_keys.dart';

class AzkarUIHelpers {
  static IconData getCategoryIcon(String id) {
    return _categoryIcons[id] ?? FlutterIslamicIcons.solidPrayer;
  }

  static const Map<String, IconData> _categoryIcons = {
    AzkarKeys.catAfterPrayer: FlutterIslamicIcons.solidTasbihHand,
    AzkarKeys.catMorning: SolarIconsBold.sunrise,
    AzkarKeys.catEvening: SolarIconsBold.sunfog,
    AzkarKeys.catSleep: SolarIconsBold.sleeping,
    AzkarKeys.catWakeup: SolarIconsBold.alarm,
    AzkarKeys.catWudu: Icons.shower,
    AzkarKeys.catMosque: FlutterIslamicIcons.mosque,
    AzkarKeys.catHome: SolarIconsBold.home,
    AzkarKeys.catAthan: FlutterIslamicIcons.solidMosque,
    AzkarKeys.catToilet: Icons.bathtub,
    AzkarKeys.catFood: Icons.restaurant,
    AzkarKeys.catDress: Icons.checkroom,
    AzkarKeys.catFasting: FlutterIslamicIcons.ramadan,
    AzkarKeys.catSadness: Icons.sentiment_dissatisfied_rounded,
    AzkarKeys.catPrayer: FlutterIslamicIcons.prayingPerson,
    AzkarKeys.catTasbih: FlutterIslamicIcons.tasbih3,
    AzkarKeys.catMarriage: Icons.favorite,
    AzkarKeys.catChildren: Icons.child_care,
    AzkarKeys.catSick: SolarIconsBold.medicalKit,
    AzkarKeys.catAllah: FlutterIslamicIcons.solidAllah,
    AzkarKeys.catAnger: Icons.heart_broken,
    AzkarKeys.catTravel: Icons.flight,
    AzkarKeys.catDua: FlutterIslamicIcons.solidPrayingPerson,
  };
}
