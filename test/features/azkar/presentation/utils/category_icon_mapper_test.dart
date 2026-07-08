import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:sana/features/azkar/presentation/utils/category_icon_mapper.dart';

void main() {
  group('CategoryIconMapper', () {
    test('should map all 23 known category IDs to correct icons', () {
      expect(CategoryIconMapper.getIcon(1), FlutterIslamicIcons.solidTasbihHand);
      expect(CategoryIconMapper.getIcon(2), SolarIconsBold.sunrise);
      expect(CategoryIconMapper.getIcon(3), SolarIconsBold.sunset);
      expect(CategoryIconMapper.getIcon(4), SolarIconsBold.moonSleep);
      expect(CategoryIconMapper.getIcon(5), SolarIconsBold.alarm);
      expect(CategoryIconMapper.getIcon(6), FlutterIslamicIcons.wudhu);
      expect(CategoryIconMapper.getIcon(7), FlutterIslamicIcons.solidMinaret);
      expect(CategoryIconMapper.getIcon(8), SolarIconsBold.home);
      expect(CategoryIconMapper.getIcon(9), FlutterIslamicIcons.mosque);
      expect(CategoryIconMapper.getIcon(10), SolarIconsBold.bath);
      expect(CategoryIconMapper.getIcon(11), SolarIconsBold.cup);
      expect(CategoryIconMapper.getIcon(12), SolarIconsBold.hanger);
      expect(CategoryIconMapper.getIcon(13), FlutterIslamicIcons.solidIftar);
      expect(CategoryIconMapper.getIcon(14), SolarIconsBold.sadCircle);
      expect(CategoryIconMapper.getIcon(15), FlutterIslamicIcons.solidPrayingPerson);
      expect(CategoryIconMapper.getIcon(16), FlutterIslamicIcons.solidTasbih);
      expect(CategoryIconMapper.getIcon(17), SolarIconsBold.heart);
      expect(CategoryIconMapper.getIcon(18), CupertinoIcons.smiley_fill);
      expect(CategoryIconMapper.getIcon(19), SolarIconsBold.medicalKit);
      expect(CategoryIconMapper.getIcon(20), FlutterIslamicIcons.solidAllah);
      expect(CategoryIconMapper.getIcon(21), SolarIconsBold.heartBroken);
      expect(CategoryIconMapper.getIcon(22), CupertinoIcons.airplane);
      expect(CategoryIconMapper.getIcon(23), FlutterIslamicIcons.solidSajadah);
    });

    test('should return default tasbih icon for unknown category IDs', () {
      expect(CategoryIconMapper.getIcon(99), FlutterIslamicIcons.tasbih);
      expect(CategoryIconMapper.getIcon(-1), FlutterIslamicIcons.tasbih);
    });
  });
}
