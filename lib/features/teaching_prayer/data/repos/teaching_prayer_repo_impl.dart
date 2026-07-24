import 'dart:async';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/teaching_prayer/data/data_sources/teaching_prayer_local_data_source.dart';
import 'package:sana/features/teaching_prayer/domain/entities/teaching_prayer_entity.dart';
import 'package:sana/features/teaching_prayer/domain/repos/teaching_prayer_repository.dart';
import 'package:sana/features/teaching_prayer/domain/use_cases/parse_teaching_points_use_case.dart';

class TeachingPrayerRepoImpl implements TeachingPrayerRepository {
  TeachingPrayerRepoImpl(this._localDataSource);
  final TeachingPrayerLocalDataSource _localDataSource;

  @override
  Future<Result<List<TeachingPrayerSectionEntity>>> getSections() async {
    try {
      final sections = await _localDataSource.getSections();
      if (sections.isEmpty) {
        return const Result.failure(
          MissingDataFailure(message: AppStrings.missingDataError),
        );
      }

      final entities = sections.map((section) {
        return TeachingPrayerSectionEntity(
          id: section.id,
          title: section.title,
          topics: section.topics.map((topic) {
            return TeachingPrayerTopicEntity(
              id: topic.id,
              title: topic.title,
              content: topic.content,
              points: const ParseTeachingPointsUseCase().call(topic.content),
            );
          }).toList(),
        );
      }).toList();

      return Result.success(entities);
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.localError('GetSections Error', error: e, stackTrace: stack),
      );
      return const Result.failure(
        CacheFailure(
          message: AppStrings.ourFault,
        ),
      );
    }
  }
}
