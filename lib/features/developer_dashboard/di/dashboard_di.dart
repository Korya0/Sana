import 'package:get_it/get_it.dart';
import 'package:sana/core/services/database/nosql_database_client.dart';
import 'package:sana/features/developer_dashboard/data/data_sources/dashboard_remote_data_source.dart';
import 'package:sana/features/developer_dashboard/data/repos/dashboard_repository.dart';
import 'package:sana/features/developer_dashboard/presentation/cubits/dashboard_cubit.dart';

void setupDashboardDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<DashboardRemoteDataSource>(
      () => DashboardRemoteDataSourceImpl(sl<NoSqlDatabaseClient>()),
    )
    ..registerLazySingleton<DashboardRepository>(() => DashboardRepoImpl(sl()))
    ..registerFactory<DashboardCubit>(() => DashboardCubit(sl()));
}
