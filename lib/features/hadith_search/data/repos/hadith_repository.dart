import 'dart:async';
import 'package:sana/core/networking/api_error_handler.dart';
import 'package:sana/core/networking/api_result.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/hadith_search/data/datasources/i_hadith_remote_data_source.dart';
import 'package:sana/features/hadith_search/data/models/hadith_model.dart';
import 'package:sana/features/hadith_search/data/repos/i_hadith_repository.dart';

class HadithRepoImpl implements IHadithRepository {
  HadithRepoImpl(this._remoteDataSource);
  final IHadithRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<List<HadithModel>>> searchHadith(
    String query, {
    int page = 1,
  }) async {
    try {
      final results = await _remoteDataSource.searchHadith(query, page: page);
      return ApiResult.success(results);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('SearchHadith Error', error: e, stackTrace: stack),
      );
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }
}
