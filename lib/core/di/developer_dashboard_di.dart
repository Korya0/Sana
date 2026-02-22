import 'package:get_it/get_it.dart';
import 'package:sana/features/developer_dashboard/data/services/developer_dashboard_service.dart';
import 'package:sana/features/developer_dashboard/presentation/cubit/developer_dashboard_cubit.dart';

void setupDeveloperDashboardDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<DeveloperDashboardService>(
      () => DeveloperDashboardService(firestore: sl()),
    )
    ..registerFactory<DeveloperDashboardCubit>(
      () => DeveloperDashboardCubit(sl()),
    );
}
