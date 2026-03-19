import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:sana/features/developer_dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:sana/features/developer_dashboard/data/repos/dashboard_repository.dart';
import 'package:sana/features/developer_dashboard/presentation/cubit/dashboard_cubit.dart';

class DeveloperDashboardDependencyInjection {
  static void init(GetIt sl) {
    sl
      // 1) Data Sources
      ..registerLazySingleton<IDashboardRemoteDataSource>(
        () => DashboardRemoteDataSource(sl<FirebaseFirestore>()),
      )
      // 2) Repositories
      ..registerLazySingleton<IDashboardRepository>(
        () => DashboardRepoImpl(sl()),
      )
      // 3) Cubits
      ..registerFactory<DashboardCubit>(
        () => DashboardCubit(sl()),
      );
  }
}
