import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/features/zakat/data/models/zakat_currency.dart';
import 'package:sana/features/zakat/data/services/metal_price_service.dart';
import 'package:sana/features/zakat/presentation/controllers/calculate_form_controllers.dart';
import 'package:sana/features/zakat/presentation/cubits/zakat_calculate/zakat_calculate_cubit.dart';
import 'package:sana/features/zakat/presentation/cubits/zakat_calculate/zakat_calculate_state.dart';
import 'package:sana/features/zakat/presentation/screens/zakat_calculate_screen.dart';
import 'package:sana/features/zakat/presentation/widgets/calculate/calculate_screen_body.dart';

class _FakePriceService extends MetalPriceService {
  @override
  Future<bool> checkInternetConnection() async => true;

  @override
  Future<MetalPrices?> fetchMetalPrices({
    ZakatCurrency currency = ZakatCurrency.egyptianPound,
  }) async {
    return MetalPrices(
      pureGoldPricePerGram: currency == ZakatCurrency.saudiRiyal ? 700 : 1000,
      silverPricePerGram: currency == ZakatCurrency.saudiRiyal ? 6 : 10,
      fetchedAt: DateTime(2026),
      currency: currency,
    );
  }
}

class _OfflinePriceService extends MetalPriceService {
  @override
  Future<bool> checkInternetConnection() async => false;

  @override
  Future<MetalPrices?> fetchMetalPrices({
    ZakatCurrency currency = ZakatCurrency.egyptianPound,
  }) async => null;
}

void main() {
  testWidgets('changing the dropdown updates every currency label and price', (
    tester,
  ) async {
    final cubit = ZakatCalculateCubit(priceService: _FakePriceService());
    final form = CalculateFormControllers();
    await cubit.fetchPrices();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        builder: (context, child) {
          AppSize.init(context);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        home: Scaffold(
          body: BlocProvider<ZakatCalculateCubit>.value(
            value: cubit,
            child: BlocBuilder<ZakatCalculateCubit, ZakatCalculateState>(
              builder: (context, state) {
                return CalculateScreenBody(
                  state: state,
                  form: form,
                  onCurrencyChanged: cubit.updateCurrency,
                  onStandardChanged: cubit.updateStandard,
                  onKaratChanged: cubit.updateKarat,
                  onGoldPersonalChanged: cubit.toggleGoldPersonal,
                  onIncludePersonalGoldChanged: cubit.toggleIncludePersonalGold,
                  onHawlChanged: cubit.toggleHawl,
                  onRefreshPrices: cubit.fetchPrices,
                  onFetchOnlinePressed: cubit.fetchPrices,
                  onPriceFieldChanged: (_) => cubit.setPriceError(false),
                  priceValidator:
                      (value, {required required, required metal}) => null,
                  onValidateStage: () => true,
                  onSubmit: () {},
                  onClear: () {},
                  clearVersion: 0,
                );
              },
            ),
          ),
        ),
      ),
    );

    expect(find.textContaining('جنيه'), findsWidgets);
    expect(find.textContaining('ريال'), findsNothing);

    await tester.tap(find.byType(DropdownButtonFormField<ZakatCurrency>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ريال سعودي (SAR)').last);
    await tester.pumpAndSettle();

    expect(cubit.state.currency, ZakatCurrency.saudiRiyal);
    expect(cubit.state.fetchedPrices!.currency, ZakatCurrency.saudiRiyal);
    expect(find.textContaining('ريال'), findsWidgets);
    expect(find.textContaining('جنيه'), findsNothing);

    form.dispose();
    await cubit.close();
  });

  testWidgets(
    'changing currency also updates the offline manual price fields',
    (tester) async {
      final cubit = ZakatCalculateCubit(priceService: _OfflinePriceService());
      final form = CalculateFormControllers();
      await cubit.fetchPrices();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          builder: (context, child) {
            AppSize.init(context);
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            );
          },
          home: Scaffold(
            body: BlocProvider<ZakatCalculateCubit>.value(
              value: cubit,
              child: BlocBuilder<ZakatCalculateCubit, ZakatCalculateState>(
                builder: (context, state) {
                  return CalculateScreenBody(
                    state: state,
                    form: form,
                    onCurrencyChanged: cubit.updateCurrency,
                    onStandardChanged: cubit.updateStandard,
                    onKaratChanged: cubit.updateKarat,
                    onGoldPersonalChanged: cubit.toggleGoldPersonal,
                    onIncludePersonalGoldChanged:
                        cubit.toggleIncludePersonalGold,
                    onHawlChanged: cubit.toggleHawl,
                    onRefreshPrices: cubit.fetchPrices,
                    onFetchOnlinePressed: cubit.fetchPrices,
                    onPriceFieldChanged: (_) => cubit.setPriceError(false),
                    priceValidator:
                        (value, {required required, required metal}) => null,
                    onValidateStage: () => true,
                    onSubmit: () {},
                    onClear: () {},
                    clearVersion: 0,
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.textContaining('جنيه'), findsWidgets);

      await tester.tap(find.byType(DropdownButtonFormField<ZakatCurrency>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ريال سعودي (SAR)').last);
      await tester.pumpAndSettle();

      expect(cubit.state.currency, ZakatCurrency.saudiRiyal);
      expect(find.textContaining('ريال'), findsWidgets);
      expect(find.textContaining('جنيه'), findsNothing);

      form.dispose();
      await cubit.close();
    },
  );

  testWidgets('the real ZakatCalculateScreen updates currency everywhere', (
    tester,
  ) async {
    await sl.reset();
    sl.registerFactory<ZakatCalculateCubit>(
      () => ZakatCalculateCubit(priceService: _FakePriceService()),
    );
    addTearDown(() => sl.reset());

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        builder: (context, child) {
          AppSize.init(context);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        home: const ZakatCalculateScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('جنيه'), findsWidgets);

    await tester.tap(find.byType(DropdownButtonFormField<ZakatCurrency>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ريال سعودي (SAR)').last);
    await tester.pumpAndSettle();

    expect(find.textContaining('ريال'), findsWidgets);
    expect(find.textContaining('جنيه'), findsNothing);
  });
}
