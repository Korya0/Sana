import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/widgets/overlays/custom_confirmation_dialog.dart';
import 'package:sana/features/zakat/data/models/metal_prices.dart';
import 'package:sana/features/zakat/data/models/zakat_currency.dart';
import 'package:sana/features/zakat/data/models/zakat_input.dart';
import 'package:sana/features/zakat/data/models/zakat_result.dart';
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
  int _clearVersion = 0;

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
    if (price <= 0) return AppStrings.zakatInvalidPrice(metal);
    return null;
  }

  /// العملة الجديدة تصبح عملة الحساب نفسها؛ الأسعار القديمة كانت مُسعّرة
  /// بالعملة السابقة لذلك تُمسح ويُعاد جلب الأسعار بالعملة المختارة.
  void _onCurrencyChanged(BuildContext context, ZakatCurrency currency) {
    _form.goldPrice.clear();
    _form.silverPrice.clear();
    context.read<ZakatCalculateCubit>().updateCurrency(currency);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: AppConstants.toastDuration2s,
      ),
    );
  }

  Future<void> _onClear(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final cubit = context.read<ZakatCalculateCubit>();
    final previousState = cubit.state;
    final previousValues = _form.snapshot();

    final confirmed = await CustomConfirmationDialog.show(
      context: context,
      title: AppStrings.zakatClearDialogTitle,
      message: AppStrings.zakatClearDialogMessage,
      confirmText: AppStrings.zakatClearConfirm,
      cancelText: AppStrings.zakatClearCancel,
    );
    if (confirmed != true || !context.mounted) return;

    cubit.resetForm();
    _form.clear();
    _formKey.currentState?.reset();
    setState(() => _clearVersion++);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text(AppStrings.zakatClearedSnackbar),
          duration: AppConstants.toastDuration3s,
          action: SnackBarAction(
            label: AppStrings.zakatUndo,
            onPressed: () {
              if (!mounted) return;
              _form.restore(previousValues);
              context.read<ZakatCalculateCubit>().restoreState(previousState);
            },
          ),
        ),
      );
  }

  void _onSubmit(BuildContext context, ZakatCalculateState state) {
    if (!(_formKey.currentState?.validate() ?? false)) {
      _showMessage(AppStrings.zakatValidationError);
      return;
    }

    if (!_form.hasAnyAsset) {
      _showMessage(AppStrings.zakatEmptyAssets);
      return;
    }

    final cubit = context.read<ZakatCalculateCubit>();
    if (!state.hawlCompleted) {
      cubit.setHawlError(true);
      _showMessage(AppStrings.zakatHawlBlocked);
      return;
    }

    final input = _form.buildInput(
      currency: state.currency,
      goldKarat: state.goldKarat,
      goldPersonal: state.goldPersonal,
      includePersonalGold: state.includePersonalGold,
      hawlCompleted: state.hawlCompleted,
      standard: state.standard,
      resolvedGoldPrice: state.resolvedGoldPrice,
      resolvedSilverPrice: state.resolvedSilverPrice,
    );

    final result = cubit.calculateZakat(input);
    if (result.status == ZakatStatus.nisabUnknown) {
      cubit.setPriceError(true);
      _showMessage(AppStrings.zakatPriceMissingResult);
      return;
    }

    cubit.setPriceError(false);
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
              constraints: const BoxConstraints(
                maxWidth: AppSize.contentMaxWidth,
              ),
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
                      onCurrencyChanged: (currency) =>
                          _onCurrencyChanged(context, currency),
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
                      onRefreshPrices: cubit.fetchPrices,
                      onFetchOnlinePressed: cubit.fetchPrices,
                      onPriceFieldChanged: (_) => cubit.setPriceError(false),
                      priceValidator: _validatePrice,
                      onValidateStage: () =>
                          _formKey.currentState?.validate() ?? true,
                      onSubmit: () => _onSubmit(context, state),
                      onClear: () => _onClear(context),
                      clearVersion: _clearVersion,
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
