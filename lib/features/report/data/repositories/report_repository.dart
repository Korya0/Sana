import 'package:dartz/dartz.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/core/utils/device_info_service.dart';
import 'package:sana/features/report/data/datasources/report_remote_data_source.dart';

abstract class IReportRepository {
  Future<Either<Failure, bool>> sendReport({
    required String message,
    String? errorDetails,
    String? contactInfo,
    bool isSuggestion = false,
  });
}

class ReportRepository implements IReportRepository {
  ReportRepository(this._remoteDataSource, this._deviceInfoService);

  final ReportRemoteDataSource _remoteDataSource;
  final DeviceInfoService _deviceInfoService;

  @override
  Future<Either<Failure, bool>> sendReport({
    required String message,
    String? errorDetails,
    String? contactInfo,
    bool isSuggestion = false,
  }) async {
    try {
      final timestamp = DateTime.now().toIso8601String();
      final type = errorDetails != null ? 'system' : 'user';
      final metadata = await _deviceInfoService.getDeviceInfo();

      final reportData = {
        'message': message,
        'contactInfo': contactInfo ?? 'غير متوفر',
        'errorDetails': (errorDetails == null || errorDetails.isEmpty)
            ? 'لا يوجد'
            : errorDetails,
        'isSuggestion': isSuggestion,
        'type': type,
        'timestamp': timestamp,
        'metadata': metadata,
      };

      await _remoteDataSource.sendReport(reportData);
      AppLogger.success('Report sent successfully with metadata!');
      return const Right(true);
    } catch (e, stack) {
      AppLogger.error(
        'Error sending report',
        error: e,
        stackTrace: stack,
      );
      return Left(
        ServerFailure(
          message: AppStrings.serverError,
          technicalMessage: 'Firestore Error: $e',
        ),
      );
    }
  }
}
