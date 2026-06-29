import 'dart:async';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/networking/api_result.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/teaching_prayer/data/datasources/teaching_prayer_local_data_source.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';

abstract class ITeachingPrayerRepository {
  Future<ApiResult<List<TeachingPrayerSectionModel>>> getSections();
}

class TeachingPrayerRepoImpl implements ITeachingPrayerRepository {
  TeachingPrayerRepoImpl(this._localDataSource);
  final ITeachingPrayerLocalDataSource _localDataSource;

  @override
  Future<ApiResult<List<TeachingPrayerSectionModel>>> getSections() async {
    try {
      final sections = await _localDataSource.getSections();
      if (sections.isEmpty) {
        return const ApiResult.failure(
          MissingDataFailure(message: AppStrings.missingDataError),
        );
      }
      return ApiResult.success(sections);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('GetSections Error', error: e, stackTrace: stack),
      );
      return const ApiResult.failure(
        CacheFailure(
          message: AppStrings.ourFault,
        ),
      );
    }
  }
}
