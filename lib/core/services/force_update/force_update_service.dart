import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sana/core/services/force_update/update_config_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ForceUpdateService {
  Future<UpdateConfigModel?> getCachedConfig();
  Future<UpdateConfigModel?> fetchRemoteConfig();
  Future<void> cacheConfig(UpdateConfigModel config);

  /// Returns the Play Store URL from the remote config (cached if available).
  Future<String?> getPlayStoreUrl();
}

class ForceUpdateServiceImpl implements ForceUpdateService {
  final Dio _dio;
  final SharedPreferences _prefs;

  static const String _configUrl =
      'https://raw.githubusercontent.com/Korya0/sana_app_config/refs/heads/main/config.json';
  static const String _cacheKey = 'cached_update_config';

  ForceUpdateServiceImpl(this._dio, this._prefs);

  @override
  Future<UpdateConfigModel?> getCachedConfig() async {
    final jsonString = _prefs.getString(_cacheKey);
    if (jsonString != null) {
      try {
        return UpdateConfigModel.fromJson(jsonDecode(jsonString));
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<UpdateConfigModel?> fetchRemoteConfig() async {
    try {
      final response = await _dio.get(
        _configUrl,
        options: Options(
          responseType: ResponseType.plain,
          // [Web Support] إزالة Cache-Control في الويب لتجنب مشاكل الـ CORS (Preflight requests)
          headers: kIsWeb ? null : {'Cache-Control': 'no-cache'},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data is String
            ? jsonDecode(response.data)
            : response.data;
        return UpdateConfigModel.fromJson(data);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  @override
  Future<void> cacheConfig(UpdateConfigModel config) async {
    await _prefs.setString(_cacheKey, jsonEncode(config.toJson()));
  }

  @override
  Future<String?> getPlayStoreUrl() async {
    // Try cached config first
    final cached = await getCachedConfig();
    if (cached != null && cached.playStoreUrl.isNotEmpty) {
      return cached.playStoreUrl;
    }
    // Fallback to remote fetch
    final remote = await fetchRemoteConfig();
    if (remote != null && remote.playStoreUrl.isNotEmpty) {
      // Cache the remote config for future calls
      await cacheConfig(remote);
      return remote.playStoreUrl;
    }
    return null;
  }
}
