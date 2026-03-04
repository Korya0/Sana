import 'dart:async';
import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/core/constants/config_keys.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/app_update/data/models/update_config_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppUpdateService {
  Future<UpdateConfigModel?> getCachedConfig();
  Future<UpdateConfigModel?> fetchRemoteConfig();
  Future<void> cacheConfig(UpdateConfigModel config);
  Future<String?> getUpdateUrl();
}

class AppUpdateServiceImpl implements AppUpdateService {
  AppUpdateServiceImpl(this._remoteConfig, this._prefs);
  final FirebaseRemoteConfig _remoteConfig;
  final SharedPreferences _prefs;

  @override
  Future<UpdateConfigModel?> getCachedConfig() async {
    final jsonString = _prefs.getString(PrefKeys.cachedUpdateConfig);
    if (jsonString != null) {
      try {
        return UpdateConfigModel.fromJson(
          jsonDecode(jsonString) as Map<String, dynamic>,
        );
      } on FormatException catch (e, stackTrace) {
        unawaited(
          AppLogger.error(
            'Error loading App Update JSON',
            error: e,
            stackTrace: stackTrace,
          ),
        );
        return null;
      }
    }
    return null;
  }

  @override
  Future<UpdateConfigModel?> fetchRemoteConfig() async {
    try {
      // Set settings for fetching
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: kDebugMode
              ? Duration.zero
              : const Duration(hours: 1),
        ),
      );

      // Fetch and activate
      await _remoteConfig.fetchAndActivate();

      return UpdateConfigModel(
        latestVersion: _remoteConfig.getString(
          ConfigKeys.latestVersion,
        ),
        isForceUpdate: _remoteConfig.getBool(ConfigKeys.isForceUpdate),
        updateUrl: _remoteConfig.getString(ConfigKeys.updateUrl),
        updateMessage: _remoteConfig.getString(
          ConfigKeys.updateMessage,
        ),
      );
    } on Exception catch (e, stackTrace) {
      unawaited(
        AppLogger.error(
          'Error loading App Update JSON',
          error: e,
          stackTrace: stackTrace,
        ),
      );
      return null;
    }
  }

  @override
  Future<void> cacheConfig(UpdateConfigModel config) async {
    await _prefs.setString(
      PrefKeys.cachedUpdateConfig,
      jsonEncode(config.toJson()),
    );
  }

  @override
  Future<String?> getUpdateUrl() async {
    final remote = await fetchRemoteConfig();
    if (remote != null && remote.updateUrl.isNotEmpty) {
      await cacheConfig(remote);
      return remote.updateUrl;
    }
    return null;
  }
}
