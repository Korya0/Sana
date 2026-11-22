import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/zakat/data/models/zakat_currency.dart';
import 'package:sana/features/zakat/data/models/zakat_input.dart';
import 'package:sana/features/zakat/data/models/zakat_result.dart';
import 'package:sana/features/zakat/data/services/metal_price_service.dart';
import 'package:sana/features/zakat/data/services/zakat_calculator.dart';
import 'zakat_calculate_state.dart';

class ZakatCalculateCubit extends Cubit<ZakatCalculateState> {
  ZakatCalculateCubit({
    MetalPriceService? priceService,
  }) : _priceService = priceService ?? MetalPriceService(),
       super(const ZakatCalculateState());

  final MetalPriceService _priceService;

  /// Invalidates in-flight price fetches when the currency or the whole form
  /// changes, so a stale response can never overwrite the current currency.
  int _fetchGeneration = 0;

  Future<MetalPrices?> fetchPrices() async {
    if (isClosed) return null;
    final generation = ++_fetchGeneration;
    final currency = state.currency;
    emit(state.copyWith(isLoadingPrices: true, priceError: false));

    try {
      final isConnected = await _priceService.checkInternetConnection();
      if (isClosed || generation != _fetchGeneration) return null;
      if (!isConnected) {
        _emitNoPrices();
        return null;
      }

      final prices = await _priceService.fetchMetalPrices(currency: currency);
      if (isClosed || generation != _fetchGeneration) return null;
      if (prices != null && prices.currency == state.currency) {
        emit(
          state.copyWith(
            isLoadingPrices: false,
            pricesFetchedOnline: true,
            priceError: false,
            fetchedPrices: prices,
          ),
        );
        return prices;
      }
      _emitNoPrices();
      return null;
    } catch (_) {
      if (isClosed || generation != _fetchGeneration) return null;
      _emitNoPrices();
      return null;
    }
  }

  void _emitNoPrices() {
    if (isClosed) return;
    emit(
      state.copyWith(
        isLoadingPrices: false,
        pricesFetchedOnline: false,
        priceError: false,
        clearFetchedPrices: true,
      ),
    );
  }

  /// Changing the calculation currency drops the old-currency prices and
  /// fetches new ones. The screen clears the manual price fields alongside.
  void updateCurrency(ZakatCurrency currency) {
    if (isClosed || currency == state.currency) return;
    _fetchGeneration++;
    emit(
      state.copyWith(
        currency: currency,
        isLoadingPrices: true,
        pricesFetchedOnline: false,
        priceError: false,
        clearFetchedPrices: true,
      ),
    );
    unawaited(fetchPrices());
  }

  void updateStandard(NisabStandard standard) {
    emit(state.copyWith(standard: standard));
  }

  void updateKarat(int? karat) {
    emit(state.copyWith(goldKarat: karat ?? 21, priceError: false));
  }

  void toggleGoldPersonal(bool isPersonal) {
    emit(
      state.copyWith(
        goldPersonal: isPersonal,
        includePersonalGold: isPersonal ? state.includePersonalGold : false,
      ),
    );
  }

  void toggleIncludePersonalGold(bool include) {
    emit(state.copyWith(includePersonalGold: include));
  }

  void toggleHawl(bool? completed) {
    final isCompleted = completed ?? false;
    emit(
      state.copyWith(
        hawlCompleted: isCompleted,
        hawlError: isCompleted ? false : state.hawlError,
      ),
    );
  }

  void setHawlError(bool hasError) {
    emit(state.copyWith(hawlError: hasError));
  }

  void setPriceError(bool hasError) {
    if (isClosed) return;
    emit(state.copyWith(priceError: hasError));
  }

  void resetForm() {
    _fetchGeneration++;
    emit(const ZakatCalculateState());
  }

  /// Restores the exact pre-clear state when the user undoes a clear.
  void restoreState(ZakatCalculateState snapshot) {
    if (isClosed) return;
    _fetchGeneration++;
    emit(snapshot);
  }

  ZakatResult calculateZakat(ZakatInput input) {
    return ZakatCalculator.calculate(input);
  }
}
