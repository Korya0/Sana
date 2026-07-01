import 'package:get_it/get_it.dart';
import 'package:sana/core/services/database/i_nosql_database_client.dart';
import 'package:sana/features/developer_dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:sana/features/developer_dashboard/data/repos/dashboard_repository.dart';
import 'package:sana/features/developer_dashboard/presentation/cubit/dashboard_cubit.dart';

void setupDashboardDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<IDashboardRemoteDataSource>(
      () => DashboardRemoteDataSource(sl<INoSqlDatabaseClient>()),
    )
    ..registerLazySingleton<IDashboardRepository>(() => DashboardRepoImpl(sl()))
    ..registerFactory<DashboardCubit>(() => DashboardCubit(sl()));
}
