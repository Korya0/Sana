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
