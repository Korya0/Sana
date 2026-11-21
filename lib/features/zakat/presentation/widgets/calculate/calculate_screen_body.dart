import 'package:flutter/material.dart';
import 'package:sana/features/zakat/data/models/zakat_input.dart';
import 'package:sana/features/zakat/presentation/controllers/calculate_form_controllers.dart';
import 'package:sana/features/zakat/presentation/cubits/zakat_calculate/zakat_calculate_state.dart';
import '../zakat_section_title.dart';
import 'calculate_action_buttons.dart';
import 'debts_section.dart';
import 'gold_assets_section.dart';
import 'hawl_section.dart';
import 'nisab_and_prices_section.dart';
import 'other_assets_section.dart';

class CalculateScreenBody extends StatelessWidget {
  const CalculateScreenBody({
    super.key,
    required this.state,
    required this.form,
    required this.onStandardChanged,
    required this.onKaratChanged,
    required this.onGoldPersonalChanged,
    required this.onIncludePersonalGoldChanged,
    required this.onHawlChanged,
    required this.onRefreshPrices,
    required this.onFetchOnlinePressed,
    required this.priceValidator,
    required this.onSubmit,
    required this.onClear,
  });

  final ZakatCalculateState state;
  final CalculateFormControllers form;
  final ValueChanged<NisabStandard> onStandardChanged;
  final ValueChanged<int?> onKaratChanged;
  final ValueChanged<bool> onGoldPersonalChanged;
  final ValueChanged<bool> onIncludePersonalGoldChanged;
  final ValueChanged<bool?> onHawlChanged;
  final VoidCallback onRefreshPrices;
  final VoidCallback onFetchOnlinePressed;
  final String? Function(
    String?, {
    required bool required,
    required String metal,
  })
  priceValidator;
  final VoidCallback onSubmit;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final goldIsCounted = !state.goldPersonal || state.includePersonalGold;
    final needsGoldPrice =
        state.standard == NisabStandard.gold ||
        (goldIsCounted && form.read(form.goldGrams) > 0);
    final needsSilverPrice =
        form.read(form.silverGrams) > 0 ||
        state.standard == NisabStandard.silver;

    return ListView(
      padding: const EdgeInsets.all(16),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        const ZakatSectionTitle('أولًا: النصاب والأسعار'),
        NisabAndPricesSection(
          standard: state.standard,
          onStandardChanged: (s) => onStandardChanged(s),
          goldKarat: state.goldKarat,
          onKaratChanged: onKaratChanged,
          goldPriceController: form.goldPrice,
          silverPriceController: form.silverPrice,
          isLoadingPrices: state.isLoadingPrices,
          pricesFetchedOnline: state.pricesFetchedOnline,
          fetchedPrices: state.fetchedPrices,
          onRefreshPrices: onRefreshPrices,
          onFetchOnlinePressed: onFetchOnlinePressed,
          priceValidator: priceValidator,
          needsGoldPrice: needsGoldPrice,
          needsSilverPrice: needsSilverPrice,
        ),
        const SizedBox(height: 16),
        const ZakatSectionTitle('ثانيًا: أموالك'),
        OtherAssetsSection(
          cashController: form.cash,
          silverGramsController: form.silverGrams,
          silverPriceController: form.silverPrice,
          tradeController: form.trade,
          receivableController: form.receivable,
        ),
        const SizedBox(height: 14),
        GoldAssetsSection(
          goldGramsController: form.goldGrams,
          goldPriceController: form.goldPrice,
          goldKarat: state.goldKarat,
          goldPersonal: state.goldPersonal,
          onGoldPersonalChanged: onGoldPersonalChanged,
          includePersonalGold: state.includePersonalGold,
          onIncludePersonalGoldChanged: onIncludePersonalGoldChanged,
        ),
        const SizedBox(height: 16),
        DebtsSection(controller: form.liabilities),
        const SizedBox(height: 16),
        const ZakatSectionTitle('رابعًا: الحول'),
        HawlSection(
          hawlCompleted: state.hawlCompleted,
          hawlError: state.hawlError,
          onHawlChanged: onHawlChanged,
        ),
        const SizedBox(height: 24),
        CalculateActionButtons(onSubmit: onSubmit, onClear: onClear),
        const SizedBox(height: 16),
      ],
    );
  }
}
