import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/features/zakat/data/models/metal_prices.dart';
import 'package:sana/features/zakat/data/models/zakat_input.dart';
import 'package:sana/features/zakat/data/services/nisab_calculator.dart';
import 'package:sana/features/zakat/data/utils/number_utils.dart';
import 'package:sana/features/zakat/presentation/controllers/calculate_form_controllers.dart';
import 'package:sana/features/zakat/presentation/cubits/zakat_calculate/zakat_calculate_cubit.dart';
import 'package:sana/features/zakat/presentation/cubits/zakat_calculate/zakat_calculate_state.dart';
import 'package:sana/features/zakat/presentation/widgets/calculate/calculate_screen_body.dart';

class ZakatCalculateScreen extends StatefulWidget {
  const ZakatCalculateScreen({super.key});

  @override
  State<ZakatCalculateScreen> createState() => _ZakatCalculateScreenState();
}

class _ZakatCalculateScreenState extends State<ZakatCalculateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _form = CalculateFormControllers();

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  void _syncPricesToForm(MetalPrices? prices, int goldKarat) {
    if (prices == null) return;
    _form.goldPrice.text = prices.priceForKarat(goldKarat).toStringAsFixed(2);
    _form.silverPrice.text = prices.silverPricePerGram.toStringAsFixed(2);
  }

  void _convertGoldPriceToKarat(int oldKarat, int newKarat) {
    if (oldKarat <= 0 || newKarat <= 0) return;
    final oldPrice = NumberUtils.parseAmount(_form.goldPrice.text);
    if (oldPrice == null || oldPrice <= 0) return;
    final purePrice = NisabCalculator.pureGoldPrice(oldPrice, oldKarat);
    if (purePrice == null) return;
    _form.goldPrice.text = (purePrice * newKarat / GoldKarats.pure)
        .toStringAsFixed(2);
  }

  String? _validatePrice(
    String? value, {
    required bool required,
    required String metal,
  }) {
    if (!required) return null;
    final price = NumberUtils.parseAmount(value) ?? 0;
    if (price <= 0) return 'أدخل سعر جرام $metal لحساب قيمته والنصاب.';
    return null;
  }

  void _onClear(BuildContext context) {
    FocusScope.of(context).unfocus();
    _form.clear();
    context.read<ZakatCalculateCubit>().resetForm();
    _formKey.currentState?.reset();
  }

  void _onSubmit(BuildContext context, ZakatCalculateState state) {
    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('راجع الحقول المظللة ثم حاول مرة أخرى.')),
      );
      return;
    }

    if (!state.hawlCompleted) {
      context.read<ZakatCalculateCubit>().setHawlError(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'لا يمكن عرض النتيجة إلا بعد التأكد من تمام الحول الشرعي.',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final input = _form.buildInput(
      goldKarat: state.goldKarat,
      goldPersonal: state.goldPersonal,
      includePersonalGold: state.includePersonalGold,
      hawlCompleted: state.hawlCompleted,
      standard: state.standard,
    );

    final cubit = context.read<ZakatCalculateCubit>();
    final result = cubit.calculateZakat(input);
    context.push(AppRoutes.zakatResultView, extra: result);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ZakatCalculateCubit>(
      create: (_) => sl<ZakatCalculateCubit>()..fetchPrices(),
      child: Scaffold(
        appBar: AppBar(title: const Text(AppStrings.zakatCalculate)),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Form(
                key: _formKey,
                child: BlocConsumer<ZakatCalculateCubit, ZakatCalculateState>(
                  listenWhen: (previous, current) =>
                      current.fetchedPrices != previous.fetchedPrices ||
                      current.goldKarat != previous.goldKarat ||
                      current.pricesFetchedOnline !=
                          previous.pricesFetchedOnline,
                  listener: (context, state) {
                    if (state.pricesFetchedOnline &&
                        state.fetchedPrices != null) {
                      _syncPricesToForm(state.fetchedPrices, state.goldKarat);
                    }
                  },
                  builder: (context, state) {
                    final cubit = context.read<ZakatCalculateCubit>();
                    return CalculateScreenBody(
                      state: state,
                      form: _form,
                      onStandardChanged: cubit.updateStandard,
                      onKaratChanged: (k) {
                        final newKarat = k ?? 21;
                        final oldKarat = state.goldKarat;
                        cubit.updateKarat(newKarat);
                        if (!(state.pricesFetchedOnline &&
                            state.fetchedPrices != null)) {
                          _convertGoldPriceToKarat(oldKarat, newKarat);
                        }
                      },
                      onGoldPersonalChanged: cubit.toggleGoldPersonal,
                      onIncludePersonalGoldChanged:
                          cubit.toggleIncludePersonalGold,
                      onHawlChanged: cubit.toggleHawl,
                      onRefreshPrices: () {
                        cubit.fetchPrices();
                      },
                      onFetchOnlinePressed: () {
                        cubit.fetchPrices();
                      },
                      priceValidator: _validatePrice,
                      onSubmit: () => _onSubmit(context, state),
                      onClear: () => _onClear(context),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
