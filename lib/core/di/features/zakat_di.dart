import 'package:get_it/get_it.dart';
import 'package:sana/features/zakat/data/services/metal_price_service.dart';
import 'package:sana/features/zakat/data/services/network_connection_checker.dart';
import 'package:sana/features/zakat/presentation/cubits/zakat_calculate/zakat_calculate_cubit.dart';

void setupZakatDependencies(GetIt sl) {
  // Services
  sl
    ..registerLazySingleton<NetworkConnectionChecker>(
      () => const NetworkConnectionChecker(),
    )
    ..registerLazySingleton<MetalPriceService>(
      () =>
          MetalPriceService(connectionChecker: sl<NetworkConnectionChecker>()),
    )
    // Cubits (factory — new instance per screen)
    ..registerFactory<ZakatCalculateCubit>(
      () => ZakatCalculateCubit(priceService: sl<MetalPriceService>()),
    );
}
