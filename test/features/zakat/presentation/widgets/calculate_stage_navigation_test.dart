import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/features/zakat/data/models/zakat_currency.dart';
import 'package:sana/features/zakat/data/services/metal_price_service.dart';
import 'package:sana/features/zakat/presentation/controllers/calculate_form_controllers.dart';
import 'package:sana/features/zakat/presentation/cubits/zakat_calculate/zakat_calculate_cubit.dart';
import 'package:sana/features/zakat/presentation/cubits/zakat_calculate/zakat_calculate_state.dart';
import 'package:sana/features/zakat/presentation/widgets/calculate/calculate_screen_body.dart';

class _FakePriceService extends MetalPriceService {
  @override
  Future<bool> checkInternetConnection() async => true;

  @override
  Future<MetalPrices?> fetchMetalPrices({
    ZakatCurrency currency = ZakatCurrency.egyptianPound,
  }) async {
    return MetalPrices(
      pureGoldPricePerGram: 1000,
      silverPricePerGram: 10,
      fetchedAt: DateTime(2026),
      currency: currency,
    );
  }
}

void main() {
  late ZakatCalculateCubit cubit;
  late CalculateFormControllers form;

  setUp(() async {
    cubit = ZakatCalculateCubit(priceService: _FakePriceService());
    form = CalculateFormControllers();
    await cubit.fetchPrices();
  });

  tearDown(() {
    form.dispose();
    cubit.close();
  });

  Future<ScrollController> pumpBody(
    WidgetTester tester, {
    int clearVersion = 0,
  }) async {
    late ScrollController listController;
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
                  clearVersion: clearVersion,
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    listController = tester.widget<ListView>(find.byType(ListView)).controller!;
    return listController;
  }

  testWidgets('every step after the first has Previous and opens at the top', (
    tester,
  ) async {
    final listController = await pumpBody(tester);

    expect(find.text(AppStrings.zakatPrevious), findsNothing);
    expect(find.text(AppStrings.zakatNext), findsOneWidget);

    listController.jumpTo(400);
    await tester.pump();

    await tester.tap(find.text(AppStrings.zakatNext));
    await tester.pumpAndSettle();

    expect(listController.offset, 0);
    expect(find.text(AppStrings.zakatPrevious), findsOneWidget);

    await tester.tap(find.text(AppStrings.zakatNext));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.zakatPrevious), findsOneWidget);
    expect(find.text(AppStrings.zakatCalculateAction), findsOneWidget);
  });

  testWidgets('a clear returns the guided flow to the first step', (
    tester,
  ) async {
    await pumpBody(tester);

    await tester.tap(find.text(AppStrings.zakatNext));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.zakatNext));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.zakatPrevious), findsOneWidget);
    expect(find.text(AppStrings.zakatStepReview), findsOneWidget);

    await pumpBody(tester, clearVersion: 1);

    expect(find.text(AppStrings.zakatPrevious), findsNothing);
    expect(find.text(AppStrings.zakatStepNisabPrices), findsOneWidget);
  });
}
