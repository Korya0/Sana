import 'package:flutter/cupertino.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:solar_icons/solar_icons.dart';

class CategoryIconMapper {
  const CategoryIconMapper._();

  static IconData getIcon(int categoryId) {
    switch (categoryId) {
      case 1:
        return FlutterIslamicIcons.solidTasbihHand;
      case 2:
        return SolarIconsBold.sunrise;
      case 3:
        return SolarIconsBold.sunset;
      case 4:
        return SolarIconsBold.moonSleep;
      case 5:
        return SolarIconsBold.alarm;
      case 6:
        return FlutterIslamicIcons.wudhu;
      case 7:
        return FlutterIslamicIcons.solidMinaret;
      case 8:
        return SolarIconsBold.home;
      case 9:
        return FlutterIslamicIcons.mosque;
      case 10:
        return SolarIconsBold.bath;
      case 11:
        return SolarIconsBold.cup;
      case 12:
        return SolarIconsBold.hanger;
      case 13:
        return FlutterIslamicIcons.solidIftar;
      case 14:
        return SolarIconsBold.sadCircle;
      case 15:
        return FlutterIslamicIcons.solidPrayingPerson;
      case 16:
        return FlutterIslamicIcons.solidTasbih;
      case 17:
        return SolarIconsBold.heart;
      case 18:
        return CupertinoIcons.smiley_fill;
      case 19:
        return SolarIconsBold.medicalKit;
      case 20:
        return FlutterIslamicIcons.solidAllah;
      case 21:
        return SolarIconsBold.heartBroken;
      case 22:
        return CupertinoIcons.airplane;
      case 23:
        return FlutterIslamicIcons.solidSajadah;
      default:
        return FlutterIslamicIcons.tasbih;
    }
  }
}
