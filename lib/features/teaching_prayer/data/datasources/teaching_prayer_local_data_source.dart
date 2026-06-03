import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sana/core/constants/app_assets.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';

abstract class ITeachingPrayerLocalDataSource {
  Future<List<TeachingPrayerSectionModel>> getSections();
}

class TeachingPrayerLocalDataSource implements ITeachingPrayerLocalDataSource {
  List<TeachingPrayerSectionModel>? _cachedSections;

  @override
  Future<List<TeachingPrayerSectionModel>> getSections() async {
    if (_cachedSections != null) {
      return _cachedSections!;
    }

    final jsonString = await rootBundle.loadString(
      AppAssets.teachingPrayer,
    );

    final jsonList = json.decode(jsonString) as List<dynamic>;

    _cachedSections = jsonList
        .map(
          (e) => TeachingPrayerSectionModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();

    return _cachedSections!;
  }
}
