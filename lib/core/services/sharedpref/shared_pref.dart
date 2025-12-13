// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  factory SharedPref() {
    return preferences;
  }

  SharedPref._internal();
  static final SharedPref preferences = SharedPref._internal();

  static late SharedPreferences sharedPreferences;

  ///Below method is to initialize the SharedPreference instance.
  Future<dynamic> instantiatePreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  ///Below method is to return the SharedPreference instance.
  SharedPreferences getPreferenceInstance() {
    return sharedPreferences;
  }

  ///Below method is to set the boolean value in the SharedPreferences.
  Future<dynamic> setBoolean(String key, bool booleanValue) async {
    await sharedPreferences.setBool(key, booleanValue);
  }

  ///Below method is to get the boolean value from the SharedPreferences.
  bool? getBoolean(String key) {
    return sharedPreferences.getBool(key);
  }

  ///Below method is to set the string value in the SharedPreferences.
  Future<dynamic> setString(String key, String stringValue) async {
    await sharedPreferences.setString(key, stringValue);
  }

  ///Below method is to get the string value from the SharedPreferences.
  String? getString(String key) {
    return sharedPreferences.getString(key);
  }

  /// Set a double value
  Future<void> setDouble(String key, double value) async {
    await sharedPreferences.setDouble(key, value);
  }

  /// Get a double value
  double? getDouble(String key) => sharedPreferences.getDouble(key);

  /// Set an integer value
  Future<void> setInt(String key, int value) async {
    await sharedPreferences.setInt(key, value);
  }

  /// Get an integer value
  int? getInt(String key) => sharedPreferences.getInt(key);
}
