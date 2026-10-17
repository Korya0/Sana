import 'package:hive_flutter/hive_flutter.dart';

class AppLocalStorage {
  AppLocalStorage._(this._box);

  static const String _boxName = 'app_storage';

  final Box<dynamic> _box;

  /// Opens the app box.
  static Future<AppLocalStorage> open() async {
    await Hive.initFlutter();
    final box = await Hive.openBox<dynamic>(_boxName);
    return AppLocalStorage._(box);
  }

  Future<void> write<T>(String key, T value) => _box.put(key, value);

  T? read<T>(String key) => _box.get(key) as T?;

  Future<void> delete(String key) => _box.delete(key);

  bool contains(String key) => _box.containsKey(key);

  Future<void> clear() async {
    await _box.clear();
  }
}
