import 'package:get_it/get_it.dart';
import 'package:sana/core/services/device_info/device_info_service.dart';
import 'package:sana/features/feedback/data/datasources/feedback_remote_data_source.dart';
import 'package:sana/features/feedback/data/repos/feedback_repository.dart';
import 'package:sana/features/feedback/presentation/cubit/feedback_cubit.dart';

class FeedbackDependencyInjection {
  static void init(GetIt sl) {
    sl
      // 1) Remote Data Source
      ..registerLazySingleton<FeedbackRemoteDataSource>(
        FeedbackRemoteDataSource.new,
      )
      // 2) Repository
      ..registerLazySingleton<IFeedbackRepository>(
        () => FeedbackRepoImpl(
          sl<FeedbackRemoteDataSource>(),
          sl<IDeviceInfoService>(),
        ),
      )
      // 4) Cubit
      ..registerFactory<FeedbackCubit>(
        () => FeedbackCubit(repository: sl<IFeedbackRepository>()),
      );
  }
}
