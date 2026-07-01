import 'package:sana/core/networking/result.dart';
import 'package:sana/features/teaching_prayer/domain/entities/teaching_prayer_entity.dart';

abstract interface class ITeachingPrayerRepository {
  Future<Result<List<TeachingPrayerSectionEntity>>> getSections();
}
