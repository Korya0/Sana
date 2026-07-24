import 'dart:async';
import 'dart:convert';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/services/assets/asset_loader.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';

abstract interface class TeachingPrayerLocalDataSource {
  Future<List<TeachingPrayerSectionModel>> getSections();
}

class TeachingPrayerLocalDataSourceImpl implements TeachingPrayerLocalDataSource {
  TeachingPrayerLocalDataSourceImpl(this._assetLoader);
  final AssetLoader _assetLoader;

  List<TeachingPrayerSectionModel>? _cachedSections;

  @override
  Future<List<TeachingPrayerSectionModel>> getSections() async {
    if (_cachedSections != null) {
      return _cachedSections!;
    }

    final jsonString = await _assetLoader.loadString(
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
