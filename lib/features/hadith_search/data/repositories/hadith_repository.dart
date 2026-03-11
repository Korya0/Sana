import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:sana/core/error/error_mapper.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/hadith_search/data/datasources/i_hadith_remote_data_source.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
import 'package:sana/features/hadith_search/domain/repositories/i_hadith_repository.dart';

class HadithRepository implements IHadithRepository {
  HadithRepository(this._remoteDataSource);
  final IHadithRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<HadithEntity>>> searchHadith(
    String query, {
    int page = 1,
  }) async {
    try {
      final results = await _remoteDataSource.searchHadith(query, page: page);
      return Right(results);
    } catch (e, stack) {
      unawaited(
        AppLogger.error('SearchHadith Error', error: e, stackTrace: stack),
      );
      return Left(ErrorMapper.map(e));
    }
  }
}
