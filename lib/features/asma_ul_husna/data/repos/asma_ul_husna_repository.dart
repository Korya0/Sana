import 'dart:async';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/asma_ul_husna/data/datasources/asma_ul_husna_local_data_source.dart';
import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';

abstract class IAsmaUlHusnaRepository {
  Future<Result<List<AsmaulHusnaModel>>> getNames();
  Future<Result<AsmaulHusnaModel>> getNameOfTheDay();
}

class AsmaUlHusnaRepoImpl implements IAsmaUlHusnaRepository {
  @override
  Future<Result<List<AsmaulHusnaModel>>> getNames() async {
    try {
      final names = await AsmaUlHusnaLocalDataSource.getNames();
      if (names.isEmpty) {
        return const Result.failure(
          MissingDataFailure(message: AppStrings.missingDataError),
        );
      }
      return Result.success(names);
    } on Exception catch (e, stack) {
      unawaited(AppLogger.error('GetNames Error', error: e, stackTrace: stack));
      return const Result.failure(
        CacheFailure(
          message: AppStrings.ourFault,
        ),
      );
    }
  }

  @override
  Future<Result<AsmaulHusnaModel>> getNameOfTheDay() async {
    final result = await getNames();
    return switch (result) {
      Success(data: final names) => () {
        final now = DateTime.now();
        final dayOfYear = now.difference(DateTime(now.year)).inDays;
        return Result.success(names[dayOfYear % names.length]);
      }(),
      FailureResult(failure: final f) => Result.failure(f),
    };
  }
}
