import 'package:sana/core/services/database/nosql_database_client.dart';
import 'package:sana/features/developer_dashboard/data/models/dashboard_feedback_model.dart';
import 'package:sana/features/feedback/constants/feedback_keys.dart';

abstract interface class DashboardRemoteDataSource {
  Future<List<DashboardFeedbackModel>> getFeedbacks();
  Future<void> deleteFeedback(String id);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  DashboardRemoteDataSourceImpl(this._databaseClient);

  final NoSqlDatabaseClient _databaseClient;

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
