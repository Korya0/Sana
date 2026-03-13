import 'package:hive_flutter/hive_flutter.dart';

abstract class ILocalStorageService {
  Future<void> setBoolean({required String key, required bool booleanValue});
  bool? getBoolean(String key);
  Future<void> setString(String key, String stringValue);
  String? getString(String key);
  Future<void> setDouble(String key, double value);
  double? getDouble(String key);
  Future<void> setInt(String key, int value);
  int? getInt(String key);
  Future<void> remove(String key);
  Future<void> clear();
  bool containsKey(String key);
}

class LocalStorageService implements ILocalStorageService {
  const LocalStorageService(this._box);

  final Box<dynamic> _box;

  @override
  Future<void> setBoolean({
    required String key,
    required bool booleanValue,
  }) async {
    await _box.put(key, booleanValue);
  }

  @override
  bool? getBoolean(String key) {
    return _box.get(key) as bool?;
  }

  @override
  Future<void> setString(String key, String stringValue) async {
    await _box.put(key, stringValue);
  }

  @override
  String? getString(String key) {
    return _box.get(key) as String?;
  }

  @override
  Future<void> setDouble(String key, double value) async {
    await _box.put(key, value);
  }

  @override
  double? getDouble(String key) => _box.get(key) as double?;

  @override
  Future<void> setInt(String key, int value) async {
    await _box.put(key, value);
  }

  @override
  int? getInt(String key) => _box.get(key) as int?;

  @override
  Future<void> remove(String key) async => _box.delete(key);

  @override
  Future<void> clear() async => _box.clear();

  @override
  bool containsKey(String key) => _box.containsKey(key);
}
