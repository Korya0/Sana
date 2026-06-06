import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:solar_icons/solar_icons.dart';

class AzkarUIHelpers {
  static IconData getCategoryIcon(String id) {
    return _categoryIcons[id] ?? FlutterIslamicIcons.solidPrayer;
  }

  static const Map<String, IconData> _categoryIcons = {
    '1': FlutterIslamicIcons.solidTasbihHand,
    '2': SolarIconsBold.sunrise,
    '3': SolarIconsBold.sunfog,
    '4': SolarIconsBold.sleeping,
    '5': SolarIconsBold.alarm,
    '6': Icons.shower,
    '7': FlutterIslamicIcons.mosque,
    '8': SolarIconsBold.home,
    '9': FlutterIslamicIcons.solidMosque,
    '10': Icons.bathtub,
    '11': Icons.restaurant,
    '12': Icons.checkroom,
    '13': FlutterIslamicIcons.ramadan,
    '14': Icons.sentiment_dissatisfied_rounded,
    '15': FlutterIslamicIcons.prayingPerson,
    '16': FlutterIslamicIcons.tasbih3,
    '17': Icons.favorite,
    '18': Icons.child_care,
    '19': SolarIconsBold.medicalKit,
    '20': FlutterIslamicIcons.solidAllah,
    '21': Icons.heart_broken,
    '22': Icons.flight,
    '23': FlutterIslamicIcons.solidPrayingPerson,
  };
}
