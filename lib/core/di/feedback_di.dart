import 'package:get_it/get_it.dart';
import 'package:sana/core/services/device_info/device_info_service.dart';
import 'package:sana/features/feedback/data/datasources/feedback_remote_data_source.dart';
import 'package:sana/features/feedback/data/repositories/feedback_repository.dart';
import 'package:sana/features/feedback/presentation/controller/feedback_cubit.dart';

void setupFeedbackDependencies(GetIt sl) {
  sl
    // 1) Utils
    ..registerLazySingleton<DeviceInfoService>(DeviceInfoService.new)
    // 2) Remote Data Source
    ..registerLazySingleton<FeedbackRemoteDataSource>(
      FeedbackRemoteDataSource.new,
    )
    // 3) Repository
    ..registerLazySingleton<IFeedbackRepository>(
      () => FeedbackRepository(
        sl<FeedbackRemoteDataSource>(),
        sl<DeviceInfoService>(),
      ),
    )
    // 4) Cubit
    ..registerFactory<FeedbackCubit>(
      () => FeedbackCubit(repository: sl<IFeedbackRepository>()),
    );
}
