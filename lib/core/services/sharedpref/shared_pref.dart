import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  const SharedPref(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  /// Get the SharedPreferences instance.
  SharedPreferences get instance => _sharedPreferences;

  /// Below method is to set the boolean value in the SharedPreferences.
  Future<void> setBoolean(String key, bool booleanValue) async {
    await _sharedPreferences.setBool(key, booleanValue);
  }

  /// Below method is to get the boolean value from the SharedPreferences.
  bool? getBoolean(String key) {
    return _sharedPreferences.getBool(key);
  }

  /// Below method is to set the string value in the SharedPreferences.
  Future<void> setString(String key, String stringValue) async {
    await _sharedPreferences.setString(key, stringValue);
  }

  /// Below method is to get the string value from the SharedPreferences.
  String? getString(String key) {
    return _sharedPreferences.getString(key);
  }

  /// Set a double value
  Future<void> setDouble(String key, double value) async {
    await _sharedPreferences.setDouble(key, value);
  }

  /// Get a double value
  double? getDouble(String key) => _sharedPreferences.getDouble(key);

  /// Set an integer value
  Future<void> setInt(String key, int value) async {
    await _sharedPreferences.setInt(key, value);
  }

  /// Get an integer value
  int? getInt(String key) => _sharedPreferences.getInt(key);
}
