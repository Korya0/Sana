import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:sana/features/azkar/data/models/zikr_model.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category.dart';
import 'package:sana/features/home/data/model/category_model.dart';
import 'package:solar_icons/solar_icons.dart';

class AzkarCategoryModel extends AzkarCategory implements CategoryModel {
  const AzkarCategoryModel({
    required super.id,
    required super.title,
    required super.icon,
    required List<ZikrModel> super.azkar,
  });

  factory AzkarCategoryModel.fromJson(Map<String, dynamic> json) {
    return AzkarCategoryModel(
      id: json['id'].toString(),
      title: json['category'] as String? ?? 'أذكار',
      icon: _getIconForCategory(json['id']),
      azkar:
          (json['array'] as List<dynamic>?)
              ?.map((e) => ZikrModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  static IconData _getIconForCategory(dynamic id) {
    final intId = (id is int) ? id : int.tryParse(id.toString()) ?? 0;

    switch (intId) {
      case 1: // أذكار بعد الصلاة
        return FlutterIslamicIcons.solidPrayingPerson;

      case 2: // أذكار الصباح
        return SolarIconsBold.sunfog;

      case 3: // أذكار المساء
        return SolarIconsBold.moon;

      case 4: // أذكار النوم
        return SolarIconsBold.bed;

      case 5: // أذكار الاستيقاظ
        return SolarIconsBold.alarm;

      case 6: // أذكار الوضوء
        return SolarIconsBold.waterSun; // أو SolarIconsBold.water

      case 7: // أذكار الآذان
        return FlutterIslamicIcons.solidMosque;

      case 8: // أذكار المنزل
        return SolarIconsBold.home;

      case 9: // أذكار المسجد
        return FlutterIslamicIcons.solidMosque;

      case 10: // أذكار الخلاء
        return SolarIconsBold.bath;

      case 11: // أذكار الطعام والشراب
        return SolarIconsBold.cupHot;

      case 12: // أذكار اللباس
        return SolarIconsBold.tShirt;

      case 13: // أذكار الصائم
        return FlutterIslamicIcons.ramadan;

      case 14: // أدعية الكرب والهم
        return SolarIconsBold.heart;

      case 15: // الاستغفار و التوبة
        return FlutterIslamicIcons.solidTasbih2;

      case 16: // فضل التسبيح و التحميد، و التهليل، و التكبير
        return FlutterIslamicIcons.solidTasbih;

      case 17: // أذكار الزواج
        return SolarIconsBold.usersGroupRounded;

      case 18: // أذكار الأولاد
        return SolarIconsBold.user; // أو SolarIconsBold.usersGroupTwoRounded

      case 19: // أذكار المرض
        return SolarIconsBold.heartPulse;

      case 20: // أذكار الموت
        return SolarIconsBold.heartBroken;

      case 21: // أذكار الجنازة
        return FlutterIslamicIcons.solidKaaba;

      case 22: // أذكار السفر
        return SolarIconsBold.mapPoint; // أو SolarIconsBold.suitcase

      default:
        return FlutterIslamicIcons.solidQuran2;
    }
  }
}
