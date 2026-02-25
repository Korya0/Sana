import 'package:dartz/dartz.dart';
import 'package:sana/core/constants/app_assets.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
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
    } catch (e) {
      return Left(
        CacheFailure(
          message: AppStrings.cacheError,
          technicalMessage: 'File: ${AppAssetsJson.asmaUlHusna} - Error: $e',
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
        if (names.isEmpty) {
          return const Left(
            MissingDataFailure(message: AppStrings.missingDataError),
          );
        }
        // اختيار اسم بناءً على اليوم من السنة (Seed) لضمان ثباته طوال اليوم لجميع المستخدمين
        final now = DateTime.now();
        final dayOfYear = now.difference(DateTime(now.year)).inDays;
        final index = dayOfYear % names.length;
        return Right(names[index]);
      },
    );
  }
}
