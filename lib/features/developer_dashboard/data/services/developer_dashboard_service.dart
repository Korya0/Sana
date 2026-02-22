import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sana/features/developer_dashboard/data/models/report_model.dart';

class DeveloperDashboardService {
  DeveloperDashboardService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<List<ReportModel>> fetchReports() async {
    try {
      final querySnapshot = await _firestore
          .collection('reports')
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return ReportModel.fromJson(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      throw Exception('فشل جلب البيانات من السيرفر: $e');
    }
  }

  Future<void> deleteReport(String id) async {
    try {
      await _firestore.collection('reports').doc(id).delete();
    } catch (e) {
      throw Exception('حدث خطأ أثناء الحذف: $e');
    }
  }
}
