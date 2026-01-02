import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sana/core/models/update_config_model.dart';
import 'package:sana/core/constants/app_constants.dart';

abstract class ForceUpdateService {
  Future<UpdateConfigModel?> getCachedConfig();
  Future<UpdateConfigModel?> fetchRemoteConfig();
  Future<void> cacheConfig(UpdateConfigModel config);
}

class ForceUpdateServiceImpl implements ForceUpdateService {
  final Dio _dio;
  final SharedPreferences _prefs;

  // URL should ideally be in constants or passed in, but hardcoding here as per current context is fine,
  // or moving it from constants if possible. The user had it in the widget.
  // I'll keep the one we agreed on.
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
          headers: {'Cache-Control': 'no-cache'},
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
}
