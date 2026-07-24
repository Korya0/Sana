import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sana/core/services/database/nosql_database_client.dart';

class FirestoreDatabaseClient implements NoSqlDatabaseClient {
  FirestoreDatabaseClient(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<List<Map<String, dynamic>>> getCollection(
    String collectionPath, {
    String? orderByField,
    bool descending = false,
  }) async {
    var query =
        _firestore.collection(collectionPath) as Query<Map<String, dynamic>>;

    if (orderByField != null) {
      query = query.orderBy(orderByField, descending: descending);
    }

    final snapshot = await query.get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Inject ID into the map so caller can use it
      return data;
    }).toList();
  }

  @override
  Future<void> deleteDocument(String collectionPath, String documentId) async {
    await _firestore.collection(collectionPath).doc(documentId).delete();
  }

  @override
  Future<String> addDocument(
    String collectionPath,
    Map<String, dynamic> data,
  ) async {
    final docRef = await _firestore.collection(collectionPath).add(data);
    return docRef.id;
  }
}
