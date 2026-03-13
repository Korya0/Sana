import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sana/features/developer_dashboard/data/models/dashboard_feedback_model.dart';
import 'package:sana/features/feedback/data/constants/feedback_keys.dart';

abstract class IDashboardRemoteDataSource {
  Future<List<DashboardFeedbackModel>> getFeedbacks();
  Future<void> deleteFeedback(String id);
}

class DashboardRemoteDataSource implements IDashboardRemoteDataSource {
  DashboardRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<List<DashboardFeedbackModel>> getFeedbacks() async {
    final snapshot = await _firestore
        .collection(FeedbackFirestoreKeys.feedbacks)
        .orderBy(FeedbackFirestoreKeys.timestamp, descending: true)
        .get();

    return snapshot.docs
        .map((doc) => DashboardFeedbackModel.fromJson(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> deleteFeedback(String id) async {
    await _firestore
        .collection(FeedbackFirestoreKeys.feedbacks)
        .doc(id)
        .delete();
  }
}
