import 'dart:convert';
import 'package:sana/core/networking/api_service.dart';
import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/features/app_update/data/models/update_config_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppUpdateService {
  Future<UpdateConfigModel?> getCachedConfig();
  Future<UpdateConfigModel?> fetchRemoteConfig();
  Future<void> cacheConfig(UpdateConfigModel config);
  Future<String?> getPlayStoreUrl();
}

class AppUpdateServiceImpl implements AppUpdateService {
  final ApiService _apiService;
  final SharedPreferences _prefs;

  static const String _configUrl =
      'https://raw.githubusercontent.com/Korya0/sana_app_config/refs/heads/main/config.json';
  static const String _cacheKey = PrefKeys.cachedUpdateConfig;

  AppUpdateServiceImpl(this._apiService, this._prefs);

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
      final response = await _apiService.get(_configUrl);

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
    final remote = await fetchRemoteConfig();
    if (remote != null && remote.playStoreUrl.isNotEmpty) {
      // Cache the remote config for future calls
      await cacheConfig(remote);
      return remote.playStoreUrl;
    }
    return null;
  }
}
