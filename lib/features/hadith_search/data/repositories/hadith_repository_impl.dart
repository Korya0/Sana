import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/features/hadith_search/data/data_sources/hadith_remote_data_source.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
import 'package:sana/features/hadith_search/domain/repositories/hadith_repository.dart';

class HadithRepositoryImpl implements HadithRepository {
  final HadithRemoteDataSource _remoteDataSource;

  HadithRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<HadithEntity>>> searchHadith(
    String query, {
    int page = 1,
  }) async {
    try {
      final results = await _remoteDataSource.searchHadith(query, page: page);
      return Right(results);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        return Left(
          NetworkFailure(
            message: AppErrorStrings.noInternetConnection,
            technicalMessage: e.message,
          ),
        );
      }
      return Left(
        ServerFailure(
          message: AppErrorStrings.serverError,
          technicalMessage: e.message,
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(
          message: AppErrorStrings.serverError,
          technicalMessage: e.toString(),
        ),
      );
    }
  }
}
