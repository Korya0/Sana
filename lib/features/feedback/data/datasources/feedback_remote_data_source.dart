import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sana/features/feedback/constant/firestore_keys.dart';

abstract class IFeedbackRemoteDataSource {
  Future<void> sendFeedback(Map<String, dynamic> feedbackData);
}

class FeedbackRemoteDataSource implements IFeedbackRemoteDataSource {
  FeedbackRemoteDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<void> sendFeedback(Map<String, dynamic> feedbackData) async {
    await _firestore.collection(FirestoreKeys.feedbacks).add(feedbackData);
  }
}
