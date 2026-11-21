import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/zakat/data/services/metal_price_service.dart';
import 'package:sana/features/zakat/presentation/cubits/zakat_calculate/zakat_calculate_cubit.dart';

class FakePriceService extends MetalPriceService {
  FakePriceService({
    required Future<bool> Function() onCheckConnection,
    required Future<MetalPrices?> Function() onFetchPrices,
  }) : _onCheckConnection = onCheckConnection,
       _onFetchPrices = onFetchPrices,
       super();

  final Future<bool> Function() _onCheckConnection;
  final Future<MetalPrices?> Function() _onFetchPrices;

  @override
  Future<bool> checkInternetConnection() => _onCheckConnection();

  @override
  Future<MetalPrices?> fetchMetalPrices() => _onFetchPrices();
}

void main() {
  final prices = MetalPrices(
    pureGoldPricePerGram: 6000,
    silverPricePerGram: 50,
    fetchedAt: DateTime(2026),
  );

  group('ZakatCalculateCubit', () {
    test('fetchPrices stores prices returned by the service', () async {
      final cubit = ZakatCalculateCubit(
        priceService: FakePriceService(
          onCheckConnection: () => Future.value(true),
          onFetchPrices: () => Future.value(prices),
        ),
      );

      final result = await cubit.fetchPrices();

      expect(result, same(prices));
      expect(cubit.state.fetchedPrices, same(prices));
      expect(cubit.state.pricesFetchedOnline, isTrue);
      expect(cubit.state.isLoadingPrices, isFalse);
      await cubit.close();
    });

    test('does not emit after the cubit is closed during a fetch', () async {
      final connection = Completer<bool>();
      final fetchedPrices = Completer<MetalPrices?>();
      final cubit = ZakatCalculateCubit(
        priceService: FakePriceService(
          onCheckConnection: () => connection.future,
          onFetchPrices: () => fetchedPrices.future,
        ),
      );

      final fetch = cubit.fetchPrices();
      connection.complete(true);
      await Future<void>.delayed(Duration.zero);

      cubit.close();
      fetchedPrices.complete(prices);

      await expectLater(fetch, completion(isNull));
    });
  });
}
