import 'package:sana/core/services/database/nosql_database_client.dart';
import 'package:sana/features/feedback/constants/feedback_keys.dart';

abstract interface class FeedbackRemoteDataSource {
  Future<void> sendFeedback(Map<String, dynamic> feedbackData);
}

class FeedbackRemoteDataSourceImpl implements FeedbackRemoteDataSource {
  FeedbackRemoteDataSourceImpl(this._databaseClient);

  final NoSqlDatabaseClient _databaseClient;

  @override
  Future<void> sendFeedback(Map<String, dynamic> feedbackData) async {
    await _databaseClient.addDocument(
      FeedbackFirestoreKeys.feedbacks,
      feedbackData,
    );
  }
}
