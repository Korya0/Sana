import 'package:get_it/get_it.dart';
import 'package:sana/core/utils/device_info_service.dart';
import 'package:sana/features/feedback/data/datasources/feedback_remote_data_source.dart';
import 'package:sana/features/feedback/data/repositories/feedback_repository.dart';
import 'package:sana/features/feedback/presentation/controller/feedback_cubit.dart';

void setupFeedbackDependencies(GetIt sl) {
  // 1) Utils
  sl.registerLazySingleton<DeviceInfoService>(DeviceInfoService.new);

  // 2) Remote Data Source
  sl.registerLazySingleton<FeedbackRemoteDataSource>(
    FeedbackRemoteDataSource.new,
  );

  // 3) Repository
  sl.registerLazySingleton<IFeedbackRepository>(
    () => FeedbackRepository(
      sl<FeedbackRemoteDataSource>(),
      sl<DeviceInfoService>(),
    ),
  );

  // 4) Cubit
  sl.registerFactory<FeedbackCubit>(
    () => FeedbackCubit(repository: sl<IFeedbackRepository>()),
  );
}
