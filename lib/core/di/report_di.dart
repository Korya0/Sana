import 'package:get_it/get_it.dart';
import 'package:sana/core/utils/device_info_service.dart';
import 'package:sana/features/report/data/datasources/report_remote_data_source.dart';
import 'package:sana/features/report/data/repositories/report_repository.dart';
import 'package:sana/features/report/presentation/controller/report_cubit.dart';

void setupReportDependencies(GetIt sl) {
  // 1) Utils
  sl.registerLazySingleton<DeviceInfoService>(DeviceInfoService.new);

  // 2) Remote Data Source
  sl.registerLazySingleton<ReportRemoteDataSource>(
    () => ReportRemoteDataSource(),
  );

  // 3) Repository
  sl.registerLazySingleton<IReportRepository>(
    () => ReportRepository(
      sl<ReportRemoteDataSource>(),
      sl<DeviceInfoService>(),
    ),
  );

  // 4) Cubit
  sl.registerFactory<ReportCubit>(
    () => ReportCubit(repository: sl<IReportRepository>()),
  );
}
