import 'package:get_it/get_it.dart';
import 'package:sana/core/services/database/i_nosql_database_client.dart';
import 'package:sana/core/services/device_info/device_info_service.dart';
import 'package:sana/features/feedback/data/datasources/feedback_remote_data_source.dart';
import 'package:sana/features/feedback/data/repos/feedback_repository.dart';
import 'package:sana/features/feedback/domain/repos/i_feedback_repository.dart';
import 'package:sana/features/feedback/presentation/cubit/feedback_cubit.dart';

void setupFeedbackDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<IFeedbackRemoteDataSource>(
      () => FeedbackRemoteDataSource(sl<INoSqlDatabaseClient>()),
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
