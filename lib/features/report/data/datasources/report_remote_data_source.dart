import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sana/features/report/constant/firestore_keys.dart';

abstract class IReportRemoteDataSource {
  Future<void> sendReport(Map<String, dynamic> reportData);
}

class ReportRemoteDataSource implements IReportRemoteDataSource {
  ReportRemoteDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<void> sendReport(Map<String, dynamic> reportData) async {
    await _firestore.collection(FirestoreKeys.reports).add(reportData);
  }
}
