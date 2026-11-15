/// Minimal key-value contract used by local data sources.
///
/// [AppLocalStorage] is the production implementation; tests use an in-memory
/// fake so data sources can be exercised without Hive.
abstract interface class AppKeyValueStore {
  T? read<T>(String key);

  Future<void> write<T>(String key, T value);

  Future<void> delete(String key);
}
