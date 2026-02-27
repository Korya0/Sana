import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/features/hadith_search/data/data_sources/hadith_remote_data_source.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
import 'package:sana/features/hadith_search/domain/repositories/hadith_repository.dart';

class HadithRepositoryImpl implements HadithRepository {
  HadithRepositoryImpl(this._remoteDataSource);
  final HadithRemoteDataSource _remoteDataSource;

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
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return const Left(
          NetworkFailure(
            message: AppStrings.noInternet,
          ),
        );
      }
      return const Left(
        ServerFailure(
          message: AppStrings.serverError,
        ),
      );
    } catch (e) {
      return const Left(
        ServerFailure(
          message: AppStrings.serverError,
        ),
      );
    }
  }
}
