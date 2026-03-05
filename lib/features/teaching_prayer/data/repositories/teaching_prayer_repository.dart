import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/teaching_prayer/data/datasources/teaching_prayer_local_data_source.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';

abstract class ITeachingPrayerRepository {
  Future<Either<Failure, List<TeachingPrayerSection>>> getSections();
}

class TeachingPrayerRepository implements ITeachingPrayerRepository {
  TeachingPrayerRepository(this._localDataSource);
  final TeachingPrayerLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, List<TeachingPrayerSection>>> getSections() async {
    try {
      final sections = await _localDataSource.getSections();
      if (sections.isEmpty) {
        return const Left(
          MissingDataFailure(message: AppStrings.missingDataError),
        );
      }
      return Right(sections);
    } catch (e, stack) {
      unawaited(
        AppLogger.error('GetSections Error', error: e, stackTrace: stack),
      );
      return const Left(
        CacheFailure(
          message: AppStrings.ourFault,
        ),
      );
    }
  }
}
