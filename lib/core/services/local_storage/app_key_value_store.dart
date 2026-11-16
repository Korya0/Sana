abstract interface class AppKeyValueStore {
  T? read<T>(String key);

  Future<void> write<T>(String key, T value);

  Future<void> delete(String key);
}
