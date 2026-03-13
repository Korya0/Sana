import 'dart:async';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/api_result.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/teaching_prayer/data/datasources/teaching_prayer_local_data_source.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';

abstract class ITeachingPrayerRepository {
  Future<ApiResult<List<TeachingPrayerSection>>> getSections();
}

class TeachingPrayerRepository implements ITeachingPrayerRepository {
  TeachingPrayerRepository(this._localDataSource);
  final TeachingPrayerLocalDataSource _localDataSource;

  @override
  Future<ApiResult<List<TeachingPrayerSection>>> getSections() async {
    try {
      final sections = await _localDataSource.getSections();
      if (sections.isEmpty) {
        return const ApiResult.failure(
          Failure.missingData(message: AppStrings.missingDataError),
        );
      }
      return ApiResult.success(sections);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('GetSections Error', error: e, stackTrace: stack),
      );
      return const ApiResult.failure(
        Failure.cache(
          message: AppStrings.ourFault,
        ),
      );
    }
  }
}
