import 'package:shared_preferences/shared_preferences.dart';

abstract class ISharedPref {
  Future<void> setBoolean(String key, bool booleanValue);
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

class SharedPref implements ISharedPref {
  const SharedPref(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  @override
  Future<void> setBoolean(String key, bool booleanValue) async {
    await _sharedPreferences.setBool(key, booleanValue);
  }

  @override
  bool? getBoolean(String key) {
    return _sharedPreferences.getBool(key);
  }

  @override
  Future<void> setString(String key, String stringValue) async {
    await _sharedPreferences.setString(key, stringValue);
  }

  @override
  String? getString(String key) {
    return _sharedPreferences.getString(key);
  }

  @override
  Future<void> setDouble(String key, double value) async {
    await _sharedPreferences.setDouble(key, value);
  }

  @override
  double? getDouble(String key) => _sharedPreferences.getDouble(key);

  @override
  Future<void> setInt(String key, int value) async {
    await _sharedPreferences.setInt(key, value);
  }

  @override
  int? getInt(String key) => _sharedPreferences.getInt(key);

  @override
  Future<void> remove(String key) async => _sharedPreferences.remove(key);

  @override
  Future<void> clear() async => _sharedPreferences.clear();

  @override
  bool containsKey(String key) => _sharedPreferences.containsKey(key);
}
