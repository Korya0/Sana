import 'package:get_it/get_it.dart';
import 'package:sana/core/services/device_info/device_info_service.dart';
import 'package:sana/features/feedback/data/datasources/feedback_remote_data_source.dart';
import 'package:sana/features/feedback/data/repos/feedback_repository.dart';
import 'package:sana/features/feedback/presentation/cubit/feedback_cubit.dart';

void setupFeedbackDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<IFeedbackRemoteDataSource>(
      FeedbackRemoteDataSource.new,
    )
    ..registerLazySingleton<IFeedbackRepository>(
      () => FeedbackRepoImpl(
        sl<IFeedbackRemoteDataSource>(),
        sl<IDeviceInfoService>(),
      ),
    )
    ..registerFactory<FeedbackCubit>(
      () => FeedbackCubit(repository: sl<IFeedbackRepository>()),
    );
}
