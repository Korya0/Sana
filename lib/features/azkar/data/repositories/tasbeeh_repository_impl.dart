import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/azkar/data/data_sources/tasbeeh_local_data_source.dart';
import 'package:sana/features/azkar/data/models/tasbeeh_item_model.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/domain/repositories/tasbeeh_repository.dart';

class TasbeehRepositoryImpl implements TasbeehRepository {
  // Creates repository
  TasbeehRepositoryImpl(this._dataSource, this._logger);

  final TasbeehLocalDataSource _dataSource;
  final AppLogger _logger;

  // Loads items
  @override
  Future<Result<List<TasbeehItemEntity>>> getTasbeehItems() async {
    try {
      final items = await _dataSource.getTasbeehItems();
      return Result.success(items);
    } on Object catch (error, stackTrace) {
      _logger.error(
        'TasbeehRepository: getTasbeehItems failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const Result.failure(
        CacheFailure(message: AppStrings.tasbeehLoadError),
      );
    }
  }

  // Saves item
  @override
  Future<Result<void>> saveTasbeehItem(TasbeehItemEntity item) async {
    try {
      await _dataSource.saveTasbeehItem(TasbeehItemModel.fromEntity(item));
      return const Result.success(null);
    } on Object catch (error, stackTrace) {
      _logger.error(
        'TasbeehRepository: saveTasbeehItem failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const Result.failure(
        CacheFailure(message: AppStrings.tasbeehSaveError),
      );
    }
  }

  // Deletes item
  @override
  Future<Result<void>> deleteTasbeehItem(String id) async {
    try {
      await _dataSource.deleteTasbeehItem(id);
      return const Result.success(null);
    } on Object catch (error, stackTrace) {
      _logger.error(
        'TasbeehRepository: deleteTasbeehItem failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const Result.failure(
        CacheFailure(message: AppStrings.tasbeehDeleteError),
      );
    }
  }
}
