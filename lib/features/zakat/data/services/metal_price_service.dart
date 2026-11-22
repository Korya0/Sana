import 'package:dio/dio.dart';
import 'package:sana/features/zakat/data/models/metal_prices.dart';
import 'package:sana/features/zakat/data/models/zakat_currency.dart';
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

  /// الأسعار تُطلب مباشرة بعملة الحساب [currency]، فتكون عملة الحساب نفسها
  /// هي عملة السعر المستخدم في الحساب (لا تحويل لاحق لغرض العرض فقط).
  Future<MetalPrices?> fetchMetalPrices({
    ZakatCurrency currency = ZakatCurrency.egyptianPound,
  }) async {
    try {
      final responses = await Future.wait([
        _dio.get(
          'https://goldbroker.com/api/spot-price',
          queryParameters: {'metal': 'XAU', 'currency': currency.code},
        ),
        _dio.get(
          'https://goldbroker.com/api/spot-price',
          queryParameters: {'metal': 'XAG', 'currency': currency.code},
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
          currency: currency,
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
      final rate = currency == ZakatCurrency.usDollar
          ? 1.0
          : (rates?[currency.code] as num?)?.toDouble();

      if (goldUsd != null && silverUsd != null && rate != null && rate > 0) {
        return MetalPrices(
          pureGoldPricePerGram: (goldUsd / _gramsPerTroyOunce) * rate,
          silverPricePerGram: (silverUsd / _gramsPerTroyOunce) * rate,
          fetchedAt: DateTime.now(),
          currency: currency,
        );
      }
    } catch (_) {}

    return null;
  }
}
