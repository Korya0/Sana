abstract interface class AppKeyValueStore {
  // Reads stored value
  T? read<T>(String key);

  // Writes stored value
  Future<void> write<T>(String key, T value);

  // Deletes stored value
  Future<void> delete(String key);
}
