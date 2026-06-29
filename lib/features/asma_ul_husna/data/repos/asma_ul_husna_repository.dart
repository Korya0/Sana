import 'dart:async';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/networking/api_result.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/asma_ul_husna/data/datasources/asma_ul_husna_local_data_source.dart';
import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';

abstract class IAsmaUlHusnaRepository {
  Future<ApiResult<List<AsmaulHusnaModel>>> getNames();
  Future<ApiResult<AsmaulHusnaModel>> getNameOfTheDay();
}

class AsmaUlHusnaRepoImpl implements IAsmaUlHusnaRepository {
  @override
  Future<ApiResult<List<AsmaulHusnaModel>>> getNames() async {
    try {
      final names = await AsmaUlHusnaLocalDataSource.getNames();
      if (names.isEmpty) {
        return const ApiResult.failure(
          MissingDataFailure(message: AppStrings.missingDataError),
        );
      }
      return ApiResult.success(names);
    } on Exception catch (e, stack) {
      unawaited(AppLogger.error('GetNames Error', error: e, stackTrace: stack));
      return const ApiResult.failure(
        CacheFailure(
          message: AppStrings.ourFault,
        ),
      );
    }
  }

  @override
  Future<ApiResult<AsmaulHusnaModel>> getNameOfTheDay() async {
    final result = await getNames();
    return switch (result) {
      Success(data: final names) => () {
        final now = DateTime.now();
        final dayOfYear = now.difference(DateTime(now.year)).inDays;
        return ApiResult.success(names[dayOfYear % names.length]);
      }(),
      ApiFailure(failure: final f) => ApiResult.failure(f),
    };
  }
}
