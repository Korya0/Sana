import 'package:dartz/dartz.dart';
import 'package:sana/core/constants/app_assets.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/features/teaching_prayer/data/datasources/teaching_prayer_local_data_source.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';

abstract class ITeachingPrayerRepository {
  Future<Either<Failure, List<TeachingPrayerSection>>> getSections();
}

class TeachingPrayerRepository implements ITeachingPrayerRepository {
  @override
  Future<Either<Failure, List<TeachingPrayerSection>>> getSections() async {
    try {
      final sections = await TeachingPrayerLocalDataSource.getSections();
      if (sections.isEmpty) {
        return const Left(
          MissingDataFailure(message: AppStrings.missingDataError),
        );
      }
      return Right(sections);
    } catch (e) {
      return Left(
        CacheFailure(
          message: AppStrings.cacheError,
          technicalMessage: 'File: ${AppAssetsJson.teachingPrayer} - Error: $e',
        ),
      );
    }
  }
}
