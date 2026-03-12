import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/asma_ul_husna/data/datasources/asma_ul_husna_local_data_source.dart';
import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';

abstract class IAsmaUlHusnaRepository {
  Future<Either<Failure, List<AsmaulHusnaModel>>> getNames();
  Future<Either<Failure, AsmaulHusnaModel>> getNameOfTheDay();
}

class AsmaUlHusnaRepository implements IAsmaUlHusnaRepository {
  @override
  Future<Either<Failure, List<AsmaulHusnaModel>>> getNames() async {
    try {
      final names = await AsmaUlHusnaLocalDataSource.getNames();
      if (names.isEmpty) {
        return const Left(
          MissingDataFailure(message: AppStrings.missingDataError),
        );
      }
      return Right(names);
    } catch (e, stack) {
      unawaited(AppLogger.error('GetNames Error', error: e, stackTrace: stack));
      return const Left(
        CacheFailure(
          message: AppStrings.ourFault,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, AsmaulHusnaModel>> getNameOfTheDay() async {
    final result = await getNames();
    return result.fold(
      Left.new,
      (names) {
        final now = DateTime.now();
        final dayOfYear = now.difference(DateTime(now.year)).inDays;
        return Right(names[dayOfYear % names.length]);
      },
    );
  }
}
