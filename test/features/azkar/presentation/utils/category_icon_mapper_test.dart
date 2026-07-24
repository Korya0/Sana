import 'package:flutter/cupertino.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/presentation/utils/category_icon_mapper.dart';
import 'package:solar_icons/solar_icons.dart';

void main() {
  group('CategoryIconMapper.getIcon()', () {
    test('getIcon(1) should return FlutterIslamicIcons.solidTasbihHand', () {
      expect(CategoryIconMapper.getIcon(1), FlutterIslamicIcons.solidTasbihHand);
    });

    test('getIcon(2) should return SolarIconsBold.sunrise', () {
      expect(CategoryIconMapper.getIcon(2), SolarIconsBold.sunrise);
    });

    test('getIcon(3) should return SolarIconsBold.sunset', () {
      expect(CategoryIconMapper.getIcon(3), SolarIconsBold.sunset);
    });

    test('getIcon(4) should return SolarIconsBold.moonSleep', () {
      expect(CategoryIconMapper.getIcon(4), SolarIconsBold.moonSleep);
    });

    test('getIcon(5) should return SolarIconsBold.alarm', () {
      expect(CategoryIconMapper.getIcon(5), SolarIconsBold.alarm);
    });

    test('getIcon(6) should return FlutterIslamicIcons.wudhu', () {
      expect(CategoryIconMapper.getIcon(6), FlutterIslamicIcons.wudhu);
    });

    test('getIcon(7) should return FlutterIslamicIcons.solidMinaret', () {
      expect(CategoryIconMapper.getIcon(7), FlutterIslamicIcons.solidMinaret);
    });

    test('getIcon(8) should return SolarIconsBold.home', () {
      expect(CategoryIconMapper.getIcon(8), SolarIconsBold.home);
    });

    test('getIcon(9) should return FlutterIslamicIcons.mosque', () {
      expect(CategoryIconMapper.getIcon(9), FlutterIslamicIcons.mosque);
    });

    test('getIcon(10) should return SolarIconsBold.bath', () {
      expect(CategoryIconMapper.getIcon(10), SolarIconsBold.bath);
    });

    test('getIcon(11) should return SolarIconsBold.cup', () {
      expect(CategoryIconMapper.getIcon(11), SolarIconsBold.cup);
    });

    test('getIcon(12) should return SolarIconsBold.hanger', () {
      expect(CategoryIconMapper.getIcon(12), SolarIconsBold.hanger);
    });

    test('getIcon(13) should return FlutterIslamicIcons.solidIftar', () {
      expect(CategoryIconMapper.getIcon(13), FlutterIslamicIcons.solidIftar);
    });

    test('getIcon(14) should return SolarIconsBold.sadCircle', () {
      expect(CategoryIconMapper.getIcon(14), SolarIconsBold.sadCircle);
    });

    test('getIcon(15) should return FlutterIslamicIcons.solidPrayingPerson', () {
      expect(CategoryIconMapper.getIcon(15), FlutterIslamicIcons.solidPrayingPerson);
    });

    test('getIcon(16) should return FlutterIslamicIcons.solidTasbih', () {
      expect(CategoryIconMapper.getIcon(16), FlutterIslamicIcons.solidTasbih);
    });

    test('getIcon(17) should return SolarIconsBold.heart', () {
      expect(CategoryIconMapper.getIcon(17), SolarIconsBold.heart);
    });

    test('getIcon(18) should return CupertinoIcons.smiley_fill', () {
      expect(CategoryIconMapper.getIcon(18), CupertinoIcons.smiley_fill);
    });

    test('getIcon(19) should return SolarIconsBold.medicalKit', () {
      expect(CategoryIconMapper.getIcon(19), SolarIconsBold.medicalKit);
    });

    test('getIcon(20) should return FlutterIslamicIcons.solidAllah', () {
      expect(CategoryIconMapper.getIcon(20), FlutterIslamicIcons.solidAllah);
    });

    test('getIcon(21) should return SolarIconsBold.heartBroken', () {
      expect(CategoryIconMapper.getIcon(21), SolarIconsBold.heartBroken);
    });

    test('getIcon(22) should return CupertinoIcons.airplane', () {
      expect(CategoryIconMapper.getIcon(22), CupertinoIcons.airplane);
    });

    test('getIcon(23) should return FlutterIslamicIcons.solidSajadah', () {
      expect(CategoryIconMapper.getIcon(23), FlutterIslamicIcons.solidSajadah);
    });

    test('getIcon(999) should return FlutterIslamicIcons.tasbih (default)', () {
      expect(CategoryIconMapper.getIcon(999), FlutterIslamicIcons.tasbih);
    });
  });
}
