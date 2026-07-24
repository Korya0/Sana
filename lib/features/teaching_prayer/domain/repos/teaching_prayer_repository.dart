import 'package:sana/core/network/result.dart';
import 'package:sana/features/teaching_prayer/domain/entities/teaching_prayer_entity.dart';

abstract interface class TeachingPrayerRepository {
  Future<Result<List<TeachingPrayerSectionEntity>>> getSections();
}
