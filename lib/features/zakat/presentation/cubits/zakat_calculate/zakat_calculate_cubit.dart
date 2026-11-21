import 'package:flutter_bloc/flutter_bloc.dart';
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

  Future<MetalPrices?> fetchPrices() async {
    if (isClosed) return null;
    emit(state.copyWith(isLoadingPrices: true));
    try {
      final isConnected = await _priceService.checkInternetConnection();
      if (isClosed) return null;
      if (!isConnected) {
        emit(
          state.copyWith(
            isLoadingPrices: false,
            pricesFetchedOnline: false,
            clearFetchedPrices: true,
          ),
        );
        return null;
      }

      final prices = await _priceService.fetchMetalPrices();
      if (isClosed) return null;
      if (prices != null) {
        emit(
          state.copyWith(
            isLoadingPrices: false,
            pricesFetchedOnline: true,
            fetchedPrices: prices,
          ),
        );
        return prices;
      } else {
        emit(
          state.copyWith(
            isLoadingPrices: false,
            pricesFetchedOnline: false,
            clearFetchedPrices: true,
          ),
        );
        return null;
      }
    } catch (_) {
      if (isClosed) return null;
      emit(
        state.copyWith(
          isLoadingPrices: false,
          pricesFetchedOnline: false,
          clearFetchedPrices: true,
        ),
      );
      return null;
    }
  }

  void updateStandard(NisabStandard standard) {
    emit(state.copyWith(standard: standard));
  }

  void updateKarat(int? karat) {
    emit(state.copyWith(goldKarat: karat ?? 21));
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

  void resetForm() {
    emit(const ZakatCalculateState());
  }

  ZakatResult calculateZakat(ZakatInput input) {
    return ZakatCalculator.calculate(input);
  }
}
