import 'dart:async';
import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:sana/core/services/local_storage/storage_keys.dart';
import 'package:sana/core/services/local_storage/local_storage_service.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/app_update/data/constants/remote_config_keys.dart';
import 'package:sana/features/app_update/data/models/update_config_model.dart';

abstract class AppUpdateService {
  Future<UpdateConfigModel?> getCachedConfig();
  Future<UpdateConfigModel?> fetchRemoteConfig();
  Future<void> cacheConfig(UpdateConfigModel config);
  Future<String?> getUpdateUrl();
}

class AppUpdateServiceImpl implements AppUpdateService {
  AppUpdateServiceImpl(this._remoteConfig, this._prefs);
  final FirebaseRemoteConfig _remoteConfig;
  final ILocalStorageService _prefs;

  @override
  Future<UpdateConfigModel?> getCachedConfig() async {
    final jsonString = _prefs.getString(StorageKeys.cachedUpdateConfig);
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
          RemoteConfigKeys.latestVersion,
        ),
        isForceUpdate: _remoteConfig.getBool(RemoteConfigKeys.isForceUpdate),
        updateUrl: _remoteConfig.getString(RemoteConfigKeys.updateUrl),
        updateMessage: _remoteConfig.getString(
          RemoteConfigKeys.updateMessage,
        ),
      );
    } on Exception catch (e, stackTrace) {
      final errorStr = e.toString().toLowerCase();
      final isTransient =
          errorStr.contains('remote-config-service-unavailable') ||
          errorStr.contains('network_error') ||
          errorStr.contains('deadline-exceeded') ||
          errorStr.contains('fetch error') ||
          errorStr.contains('internal remote config');

      if (isTransient) {
        AppLogger.warn('Transient remote config error: $e');
      } else {
        unawaited(
          AppLogger.error(
            'Error fetching App Update config',
            error: e,
            stackTrace: stackTrace,
          ),
        );
      }

      // Fallback to cached config if fetch fails
      return getCachedConfig();
    }
  }

  @override
  Future<void> cacheConfig(UpdateConfigModel config) async {
    await _prefs.setString(
      StorageKeys.cachedUpdateConfig,
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
