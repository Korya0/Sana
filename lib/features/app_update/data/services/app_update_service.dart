import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/features/app_update/data/models/update_config_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppUpdateService {
  Future<UpdateConfigModel?> getCachedConfig();
  Future<UpdateConfigModel?> fetchRemoteConfig();
  Stream<UpdateConfigModel?> listenToRemoteConfig();
  Future<void> cacheConfig(UpdateConfigModel config);
  Future<String?> getPlayStoreUrl();
}

class AppUpdateServiceImpl implements AppUpdateService {
  AppUpdateServiceImpl(this._firestore, this._prefs);
  final FirebaseFirestore _firestore;
  final SharedPreferences _prefs;

  static const String _cacheKey = PrefKeys.cachedUpdateConfig;

  @override
  Future<UpdateConfigModel?> getCachedConfig() async {
    final jsonString = _prefs.getString(_cacheKey);
    if (jsonString != null) {
      try {
        return UpdateConfigModel.fromJson(
          jsonDecode(jsonString) as Map<String, dynamic>,
        );
      } on FormatException catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<UpdateConfigModel?> fetchRemoteConfig() async {
    try {
      final docSnapshot = await _firestore
          .collection('config')
          .doc('app_update')
          .get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        return UpdateConfigModel.fromJson(docSnapshot.data()!);
      }
    } on FirebaseException catch (_) {
      return null;
    }
    return null;
  }

  @override
  Stream<UpdateConfigModel?> listenToRemoteConfig() {
    return _firestore.collection('config').doc('app_update').snapshots().map((
      docSnapshot,
    ) {
      if (docSnapshot.exists && docSnapshot.data() != null) {
        return UpdateConfigModel.fromJson(docSnapshot.data()!);
      }
      return null;
    });
  }

  @override
  Future<void> cacheConfig(UpdateConfigModel config) async {
    await _prefs.setString(_cacheKey, jsonEncode(config.toJson()));
  }

  @override
  Future<String?> getPlayStoreUrl() async {
    final remote = await fetchRemoteConfig();
    if (remote != null && remote.playStoreUrl.isNotEmpty) {
      await cacheConfig(remote);
      return remote.playStoreUrl;
    }
    return null;
  }
}
