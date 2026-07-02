import 'package:hive_flutter/hive_flutter.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';

class LocalStorageServiceImpl implements ILocalStorageService {
  const LocalStorageServiceImpl(this._box);

  final Box<dynamic> _box;

  @override
  Future<void> setBoolean(String key, bool value) async {
    await _box.put(key, value);
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
  bool containsKey(String key) => _box.containsKey(key);

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
  Future<void> clear() async => _box.clear();

  @override
  int? getInt(String key) => _box.get(key) as int?;

  @override
  Future<void> remove(String key) async => _box.delete(key);
}
