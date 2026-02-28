import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:sana/features/developer_dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:sana/features/developer_dashboard/data/repositories/dashboard_repository.dart';
import 'package:sana/features/developer_dashboard/presentation/controller/dashboard_cubit.dart';

void setupDeveloperDashboardDependencies(GetIt sl) {
  // Data sources
  sl.registerLazySingleton<IDashboardRemoteDataSource>(
    () => DashboardRemoteDataSource(FirebaseFirestore.instance),
  );

  // Repositories
  sl.registerLazySingleton<IDashboardRepository>(
    () => DashboardRepository(sl()),
  );

  // Cubits
  sl.registerFactory<DashboardCubit>(
    () => DashboardCubit(sl()),
  );
}
