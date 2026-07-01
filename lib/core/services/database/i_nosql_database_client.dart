abstract class INoSqlDatabaseClient {
  Future<List<Map<String, dynamic>>> getCollection(
    String collectionPath, {
    String? orderByField,
    bool descending = false,
  });

  Future<void> deleteDocument(String collectionPath, String documentId);
}
