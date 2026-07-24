import 'package:get_it/get_it.dart';
import 'package:sana/core/services/database/nosql_database_client.dart';
import 'package:sana/core/services/device_info/device_info_service.dart';
import 'package:sana/features/feedback/data/data_sources/feedback_remote_data_source.dart';
import 'package:sana/features/feedback/data/repos/feedback_repository.dart';
import 'package:sana/features/feedback/domain/repos/feedback_repository.dart';
import 'package:sana/features/feedback/presentation/cubits/feedback_cubit.dart';

void setupFeedbackDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<FeedbackRemoteDataSource>(
      () => FeedbackRemoteDataSourceImpl(sl<NoSqlDatabaseClient>()),
    )
    ..registerLazySingleton<FeedbackRepository>(
      () => FeedbackRepoImpl(
        sl<FeedbackRemoteDataSource>(),
        sl<DeviceInfoService>(),
      ),
    )
    ..registerFactory<FeedbackCubit>(
      () => FeedbackCubit(repository: sl<FeedbackRepository>()),
    );
}
