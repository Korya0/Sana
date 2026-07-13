import 'dart:async';
import 'package:sana/core/networking/api_error_handler.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/hadith_search/data/datasources/i_hadith_remote_data_source.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
import 'package:sana/features/hadith_search/domain/repos/i_hadith_repository.dart';

class HadithRepoImpl implements IHadithRepository {
  HadithRepoImpl(this._remoteDataSource);
  final IHadithRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<HadithEntity>>> searchHadith(
    String query, {
    int page = 1,
  }) async {
    try {
      final results = await _remoteDataSource.searchHadith(query, page: page);
      return Result.success(results);
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.error(
          'SearchHadith Error',
          error: e,
          stackTrace: stack,
        ),
      );
      return Result.failure(handleApiError(e));
    }
  }
}
