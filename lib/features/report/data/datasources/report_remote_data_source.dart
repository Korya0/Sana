import 'package:cloud_firestore/cloud_firestore.dart';

class ReportRemoteDataSource {
  ReportRemoteDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<void> sendReport(Map<String, dynamic> reportData) async {
    await _firestore.collection('reports').add(reportData);
  }
}
