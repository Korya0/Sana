import 'package:hive_flutter/hive_flutter.dart';
import 'package:sana/core/services/local_storage/app_key_value_store.dart';

class AppLocalStorage implements AppKeyValueStore {
  AppLocalStorage._(this._box);

  static const String _boxName = 'app_storage';

  final Box<dynamic> _box;

  /// Opens the app box.
  static Future<AppLocalStorage> open() async {
    await Hive.initFlutter();
    final box = await Hive.openBox<dynamic>(_boxName);
    return AppLocalStorage._(box);
  }

  // Writes stored value
  @override
  Future<void> write<T>(String key, T value) => _box.put(key, value);

  // Reads stored value
  @override
  T? read<T>(String key) => _box.get(key) as T?;

  // Deletes stored value
  @override
  Future<void> delete(String key) => _box.delete(key);

  // Checks key presence
  bool contains(String key) => _box.containsKey(key);

  // Clears stored data
  Future<void> clear() async {
    await _box.clear();
  }
}
