import 'package:get_it/get_it.dart';
import 'package:sana/features/asma_ul_husna/data/repos/asma_ul_husna_repository.dart';
import 'package:sana/features/asma_ul_husna/presentation/cubit/asma_ul_husna_cubit.dart';

void setupAsmaUlHusnaDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<IAsmaUlHusnaRepository>(AsmaUlHusnaRepoImpl.new)
    ..registerFactory<AsmaUlHusnaCubit>(
      () => AsmaUlHusnaCubit(sl<IAsmaUlHusnaRepository>()),
    );
}
