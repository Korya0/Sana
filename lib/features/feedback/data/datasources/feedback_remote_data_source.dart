import 'package:sana/core/services/database/i_nosql_database_client.dart';
import 'package:sana/features/feedback/constants/feedback_keys.dart';

abstract interface class IFeedbackRemoteDataSource {
  Future<void> sendFeedback(Map<String, dynamic> feedbackData);
}

class FeedbackRemoteDataSource implements IFeedbackRemoteDataSource {
  FeedbackRemoteDataSource(this._databaseClient);

  final INoSqlDatabaseClient _databaseClient;

  @override
  Future<void> sendFeedback(Map<String, dynamic> feedbackData) async {
    await _databaseClient.addDocument(
      FeedbackFirestoreKeys.feedbacks,
      feedbackData,
    );
  }
}
