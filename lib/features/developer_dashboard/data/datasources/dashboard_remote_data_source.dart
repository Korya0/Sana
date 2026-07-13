import 'package:sana/core/services/database/i_nosql_database_client.dart';
import 'package:sana/features/developer_dashboard/data/models/dashboard_feedback_model.dart';
import 'package:sana/features/feedback/constants/feedback_keys.dart';

abstract interface class IDashboardRemoteDataSource {
  Future<List<DashboardFeedbackModel>> getFeedbacks();
  Future<void> deleteFeedback(String id);
}

class DashboardRemoteDataSource implements IDashboardRemoteDataSource {
  DashboardRemoteDataSource(this._databaseClient);

  final INoSqlDatabaseClient _databaseClient;

  @override
  Future<List<DashboardFeedbackModel>> getFeedbacks() async {
    final docs = await _databaseClient.getCollection(
      FeedbackFirestoreKeys.feedbacks,
      orderByField: FeedbackFirestoreKeys.timestamp,
      descending: true,
    );

    return docs.map((doc) {
      final id = doc['id'] as String;
      return DashboardFeedbackModel.fromJson(doc, id);
    }).toList();
  }

  @override
  Future<void> deleteFeedback(String id) async {
    await _databaseClient.deleteDocument(
      FeedbackFirestoreKeys.feedbacks,
      id,
    );
  }
}
