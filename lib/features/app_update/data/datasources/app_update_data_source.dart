import 'dart:async';
import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/app_update/data/constants/remote_config_keys.dart';
import 'package:sana/features/app_update/data/models/update_config_model.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';
import 'package:sana/core/services/local_storage/storage_keys.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

abstract interface class IAppUpdateService {
  Future<UpdateConfigModel?> getCachedConfig();
  Future<UpdateConfigModel?> fetchRemoteConfig();
  Future<void> cacheConfig(UpdateConfigModel config);
  Future<String> getCurrentVersion();
  Future<void> launchUpdateUrl(UpdateConfigModel? config);
}

class AppUpdateServiceImpl implements IAppUpdateService {
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
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: kDebugMode
              ? Duration.zero
              : const Duration(hours: 12),
        ),
      );

      await _remoteConfig.fetchAndActivate().timeout(
        const Duration(seconds: 5),
        onTimeout: () => false,
      );

      return UpdateConfigModel(
        latestVersion: _remoteConfig.getString(RemoteConfigKeys.latestVersion),
        minVersion: _remoteConfig.getString(RemoteConfigKeys.minVersion),
        updateUrl: _remoteConfig.getString(RemoteConfigKeys.updateUrl),
        updateMessage: _remoteConfig.getString(RemoteConfigKeys.updateMessage),
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
  Future<String> getCurrentVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final build = info.buildNumber.isNotEmpty ? info.buildNumber : '0';
      return '${info.version}+$build';
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error(
          'Error getting package info',
          error: e,
          stackTrace: stack,
        ),
      );
      return AppConstants.defaultVersion;
    }
  }

  @override
  Future<void> launchUpdateUrl(UpdateConfigModel? config) async {
    String url;
    if (config != null) {
      url = config.updateUrl.isNotEmpty ? config.updateUrl : AppLinks.storeLink;
    } else {
      url = AppLinks.storeLink;
    }

    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } on Exception catch (e) {
      unawaited(AppLogger.error('Could not launch update URL: $url', error: e));
    }
  }
}
