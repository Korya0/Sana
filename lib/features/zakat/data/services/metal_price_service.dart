import 'package:dio/dio.dart';
import 'package:sana/features/zakat/data/models/metal_prices.dart';
import 'network_connection_checker.dart';

export 'package:sana/features/zakat/data/models/metal_prices.dart';

/// خدمة جلب أسعار المعادن والتحقق من الاتصال بالإنترنت باستخدام Dio.
class MetalPriceService {
  MetalPriceService({
    Dio? dio,
    NetworkConnectionChecker? connectionChecker,
  }) : _dio =
           dio ??
           Dio(
             BaseOptions(
               connectTimeout: const Duration(seconds: 6),
               receiveTimeout: const Duration(seconds: 6),
               headers: {'Accept': 'application/json'},
             ),
           ),
       _connectionChecker =
           connectionChecker ?? const NetworkConnectionChecker();

  final Dio _dio;
  final NetworkConnectionChecker _connectionChecker;
  static const double _gramsPerTroyOunce = 31.1034768;

  Future<bool> checkInternetConnection() => _connectionChecker.hasConnection();

  Future<MetalPrices?> fetchMetalPrices() async {
    try {
      final responses = await Future.wait([
        _dio.get(
          'https://goldbroker.com/api/spot-price',
          queryParameters: {'metal': 'XAU', 'currency': 'EGP'},
        ),
        _dio.get(
          'https://goldbroker.com/api/spot-price',
          queryParameters: {'metal': 'XAG', 'currency': 'EGP'},
        ),
      ]);
      final goldOunce = (responses[0].data['value'] as num?)?.toDouble();
      final silverOunce = (responses[1].data['value'] as num?)?.toDouble();
      if (goldOunce != null &&
          goldOunce > 0 &&
          silverOunce != null &&
          silverOunce > 0) {
        return MetalPrices(
          pureGoldPricePerGram: goldOunce / _gramsPerTroyOunce,
          silverPricePerGram: silverOunce / _gramsPerTroyOunce,
          fetchedAt: DateTime.now(),
        );
      }
    } catch (_) {}

    try {
      final responses = await Future.wait([
        _dio.get('https://api.gold-api.com/price/XAU'),
        _dio.get('https://api.gold-api.com/price/XAG'),
        _dio.get('https://open.er-api.com/v6/latest/USD'),
      ]);
      final goldUsd = (responses[0].data['price'] as num?)?.toDouble();
      final silverUsd = (responses[1].data['price'] as num?)?.toDouble();
      final rates = responses[2].data['rates'] as Map<String, dynamic>?;
      final egpRate = (rates?['EGP'] as num?)?.toDouble();

      if (goldUsd != null &&
          silverUsd != null &&
          egpRate != null &&
          egpRate > 0) {
        return MetalPrices(
          pureGoldPricePerGram: (goldUsd / _gramsPerTroyOunce) * egpRate,
          silverPricePerGram: (silverUsd / _gramsPerTroyOunce) * egpRate,
          fetchedAt: DateTime.now(),
        );
      }
    } catch (_) {}

    return null;
  }
}
