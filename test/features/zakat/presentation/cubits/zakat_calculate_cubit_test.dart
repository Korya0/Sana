import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/zakat/data/models/zakat_currency.dart';
import 'package:sana/features/zakat/data/models/zakat_input.dart';
import 'package:sana/features/zakat/data/services/metal_price_service.dart';
import 'package:sana/features/zakat/presentation/cubits/zakat_calculate/zakat_calculate_cubit.dart';

class FakePriceService extends MetalPriceService {
  FakePriceService({
    required Future<bool> Function() onCheckConnection,
    required Future<MetalPrices?> Function({ZakatCurrency currency})
    onFetchPrices,
  }) : _onCheckConnection = onCheckConnection,
       _onFetchPrices = onFetchPrices,
       super();

  final Future<bool> Function() _onCheckConnection;
  final Future<MetalPrices?> Function({ZakatCurrency currency}) _onFetchPrices;

  @override
  Future<bool> checkInternetConnection() => _onCheckConnection();

  @override
  Future<MetalPrices?> fetchMetalPrices({
    ZakatCurrency currency = ZakatCurrency.egyptianPound,
  }) => _onFetchPrices(currency: currency);
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
          onFetchPrices: ({ZakatCurrency? currency}) => Future.value(prices),
        ),
      );

      final result = await cubit.fetchPrices();

      expect(result, same(prices));
      expect(cubit.state.fetchedPrices, same(prices));
      expect(cubit.state.pricesFetchedOnline, isTrue);
      expect(cubit.state.isLoadingPrices, isFalse);
      await cubit.close();
    });

    test(
      'clears the price recovery flag after a refetch following reset',
      () async {
        final cubit = ZakatCalculateCubit(
          priceService: FakePriceService(
            onCheckConnection: () => Future.value(true),
            onFetchPrices: ({ZakatCurrency? currency}) => Future.value(prices),
          ),
        );

        await cubit.fetchPrices();
        cubit.setPriceError(true);
        expect(cubit.state.priceError, isTrue);

        cubit.resetForm();
        expect(cubit.state.fetchedPrices, isNull);
        expect(cubit.state.priceError, isFalse);

        await cubit.fetchPrices();

        expect(cubit.state.fetchedPrices, same(prices));
        expect(cubit.state.priceError, isFalse);
        expect(cubit.state.resolvedGoldPrice, prices.priceForKarat(21));
        expect(cubit.state.resolvedSilverPrice, prices.silverPricePerGram);
        await cubit.close();
      },
    );

    test('does not emit after the cubit is closed during a fetch', () async {
      final connection = Completer<bool>();
      final fetchedPrices = Completer<MetalPrices?>();
      final cubit = ZakatCalculateCubit(
        priceService: FakePriceService(
          onCheckConnection: () => connection.future,
          onFetchPrices: ({ZakatCurrency? currency}) => fetchedPrices.future,
        ),
      );

      final fetch = cubit.fetchPrices();
      connection.complete(true);
      await Future<void>.delayed(Duration.zero);

      cubit.close();
      fetchedPrices.complete(prices);

      await expectLater(fetch, completion(isNull));
    });

    test('changing currency refetches prices in the new currency', () async {
      final requested = <ZakatCurrency>[];
      final riyalPrices = MetalPrices(
        pureGoldPricePerGram: 700,
        silverPricePerGram: 6,
        fetchedAt: DateTime(2026),
        currency: ZakatCurrency.saudiRiyal,
      );
      final cubit = ZakatCalculateCubit(
        priceService: FakePriceService(
          onCheckConnection: () => Future.value(true),
          onFetchPrices: ({ZakatCurrency? currency}) {
            final selected = currency ?? ZakatCurrency.egyptianPound;
            requested.add(selected);
            return Future.value(
              selected == ZakatCurrency.saudiRiyal ? riyalPrices : prices,
            );
          },
        ),
      );

      await cubit.fetchPrices();
      expect(cubit.state.currency, ZakatCurrency.egyptianPound);

      cubit.updateCurrency(ZakatCurrency.saudiRiyal);
      expect(cubit.state.currency, ZakatCurrency.saudiRiyal);
      expect(cubit.state.fetchedPrices, isNull);

      await Future<void>.delayed(Duration.zero);

      expect(requested, [
        ZakatCurrency.egyptianPound,
        ZakatCurrency.saudiRiyal,
      ]);
      expect(cubit.state.fetchedPrices, same(riyalPrices));
      expect(cubit.state.fetchedPrices!.currency, ZakatCurrency.saudiRiyal);
      expect(
        cubit.state.resolvedGoldPrice,
        riyalPrices.priceForKarat(cubit.state.goldKarat),
      );
      await cubit.close();
    });

    test('ignores a stale response priced in the previous currency', () async {
      final staleResponse = Completer<MetalPrices?>();
      final dollarPrices = MetalPrices(
        pureGoldPricePerGram: 200,
        silverPricePerGram: 2,
        fetchedAt: DateTime(2026),
        currency: ZakatCurrency.usDollar,
      );
      final cubit = ZakatCalculateCubit(
        priceService: FakePriceService(
          onCheckConnection: () => Future.value(true),
          onFetchPrices: ({ZakatCurrency? currency}) =>
              currency == ZakatCurrency.egyptianPound
              ? staleResponse.future
              : Future.value(dollarPrices),
        ),
      );

      final firstFetch = cubit.fetchPrices();
      await Future<void>.delayed(Duration.zero);

      cubit.updateCurrency(ZakatCurrency.usDollar);
      await Future<void>.delayed(Duration.zero);

      staleResponse.complete(prices);
      await firstFetch;
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.currency, ZakatCurrency.usDollar);
      expect(cubit.state.fetchedPrices, same(dollarPrices));
      await cubit.close();
    });

    test(
      'uses the fetched prices in the selected currency to compute nisab',
      () async {
        final riyalPrices = MetalPrices(
          pureGoldPricePerGram: 700,
          silverPricePerGram: 6,
          fetchedAt: DateTime(2026),
          currency: ZakatCurrency.saudiRiyal,
        );
        final requested = <ZakatCurrency>[];
        final cubit = ZakatCalculateCubit(
          priceService: FakePriceService(
            onCheckConnection: () => Future.value(true),
            onFetchPrices: ({ZakatCurrency? currency}) {
              final selected = currency ?? ZakatCurrency.egyptianPound;
              requested.add(selected);
              return Future.value(riyalPrices);
            },
          ),
        );

        cubit.updateCurrency(ZakatCurrency.saudiRiyal);
        await Future<void>.delayed(Duration.zero);

        expect(requested, [ZakatCurrency.saudiRiyal]);
        expect(cubit.state.currency, ZakatCurrency.saudiRiyal);
        expect(cubit.state.fetchedPrices, same(riyalPrices));

        final input = ZakatInput(
          currency: cubit.state.currency,
          goldKarat: cubit.state.goldKarat,
          goldPricePerGram: cubit.state.resolvedGoldPrice,
          silverPricePerGram: cubit.state.resolvedSilverPrice,
          hawlCompleted: true,
          priceDate: DateTime(2026),
        );
        final result = cubit.calculateZakat(input);

        expect(result.currency, ZakatCurrency.saudiRiyal);
        expect(result.input.goldPricePerGram, riyalPrices.priceForKarat(21));
        // 85 جرام × سعر الخالص 700 ريال.
        expect(result.nisabValue, 59500);
        await cubit.close();
      },
    );
  });
}
