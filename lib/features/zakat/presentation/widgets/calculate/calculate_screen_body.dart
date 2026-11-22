import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/features/zakat/data/models/zakat_currency.dart';
import 'package:sana/features/zakat/data/models/zakat_input.dart';
import 'package:sana/features/zakat/data/services/zakat_calculator.dart';
import 'package:sana/features/zakat/data/utils/number_utils.dart';
import 'package:sana/features/zakat/presentation/controllers/calculate_form_controllers.dart';
import 'package:sana/features/zakat/presentation/cubits/zakat_calculate/zakat_calculate_state.dart';
import '../zakat_section_title.dart';
import '../currency_selector.dart';
import 'calculate_action_buttons.dart';
import 'debts_section.dart';
import 'gold_assets_section.dart';
import 'hawl_section.dart';
import 'nisab_and_prices_section.dart';
import 'other_assets_section.dart';

class CalculateScreenBody extends StatefulWidget {
  const CalculateScreenBody({
    super.key,
    required this.state,
    required this.form,
    required this.onCurrencyChanged,
    required this.onStandardChanged,
    required this.onKaratChanged,
    required this.onGoldPersonalChanged,
    required this.onIncludePersonalGoldChanged,
    required this.onHawlChanged,
    required this.onRefreshPrices,
    required this.onFetchOnlinePressed,
    required this.onPriceFieldChanged,
    required this.priceValidator,
    required this.onValidateStage,
    required this.onSubmit,
    required this.onClear,
    required this.clearVersion,
  });

  final ZakatCalculateState state;
  final CalculateFormControllers form;
  final ValueChanged<ZakatCurrency> onCurrencyChanged;
  final ValueChanged<NisabStandard> onStandardChanged;
  final ValueChanged<int?> onKaratChanged;
  final ValueChanged<bool> onGoldPersonalChanged;
  final ValueChanged<bool> onIncludePersonalGoldChanged;
  final ValueChanged<bool?> onHawlChanged;
  final VoidCallback onRefreshPrices;
  final VoidCallback onFetchOnlinePressed;
  final ValueChanged<String> onPriceFieldChanged;
  final String? Function(
    String?, {
    required bool required,
    required String metal,
  })
  priceValidator;
  final bool Function() onValidateStage;
  final VoidCallback onSubmit;
  final VoidCallback onClear;

  /// Increases when the screen clears the form, so this widget can return to
  /// the first guided stage and reset its scroll position.
  final int clearVersion;

  @override
  State<CalculateScreenBody> createState() => _CalculateScreenBodyState();
}

class _CalculateScreenBodyState extends State<CalculateScreenBody> {
  static const _stageCount = 3;

  int _stage = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant CalculateScreenBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.clearVersion != oldWidget.clearVersion ||
        (!oldWidget.state.priceError && widget.state.priceError)) {
      _resetToFirstStage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
  }

  void _resetToFirstStage() {
    setState(() => _stage = 0);
    _scrollToTop();
  }

  void _goNext() {
    if (widget.onValidateStage()) {
      setState(() {
        if (_stage < _stageCount - 1) _stage++;
      });
      _scrollToTop();
    }
  }

  void _goPrevious() {
    setState(() {
      if (_stage > 0) _stage--;
    });
    _scrollToTop();
  }

  static const _stageTitles = [
    AppStrings.zakatStepNisabPrices,
    AppStrings.zakatStepAssets,
    AppStrings.zakatStepReview,
  ];

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final form = widget.form;
    final goldIsCounted = !state.goldPersonal || state.includePersonalGold;
    final needsGoldPrice =
        state.standard == NisabStandard.gold ||
        (goldIsCounted && form.read(form.goldGrams) > 0);
    final needsSilverPrice =
        form.read(form.silverGrams) > 0 ||
        state.standard == NisabStandard.silver;

    final goldPrice = state.resolvedGoldPrice ?? form.goldPriceValue;
    final silverPrice = state.resolvedSilverPrice ?? form.silverPriceValue;
    final nisab = ZakatCalculator.nisabValue(
      standard: state.standard,
      goldPricePerGram: goldPrice,
      goldKarat: state.goldKarat,
      silverPricePerGram: silverPrice,
    );

    return Column(
      children: [
        _NisabSummaryStrip(
          stage: _stage,
          stageCount: _stageCount,
          standardLabel: AppStrings.zakatNisabStandardLabel(
            state.standard.label,
          ),
          currency: state.currency,
          goldPrice: goldPrice,
          nisab: nisab,
        ),
        Expanded(
          child: ListView(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: AppSize.p16),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              Semantics(
                header: true,
                child: Text(
                  _stageTitles[_stage],
                  style: AppTextStyles.font20W700Primary(context),
                ),
              ),
              AppGap.h(AppSize.p4),
              Text(
                _stage == 2
                    ? AppStrings.zakatReviewHint
                    : AppStrings.zakatStepProgress(_stage + 1, _stageCount),
                style: AppTextStyles.font14W400Relaxed(
                  context,
                  context.color.textSecondary,
                ),
              ),
              AppGap.h(AppSize.p16),
              Visibility(
                visible: _stage == 0,
                maintainState: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CurrencySelector(
                      currency: state.currency,
                      onChanged: widget.onCurrencyChanged,
                    ),
                    AppGap.h(AppSize.p16),
                    _QuickHawlPrompt(
                      completed: state.hawlCompleted,
                      onChanged: widget.onHawlChanged,
                    ),
                    AppGap.h(AppSize.p16),
                    const ZakatSectionTitle(
                      AppStrings.zakatSectionNisabPrices,
                    ),
                    NisabAndPricesSection(
                      standard: state.standard,
                      onStandardChanged: widget.onStandardChanged,
                      goldKarat: state.goldKarat,
                      onKaratChanged: widget.onKaratChanged,
                      currency: state.currency,
                      goldPrice: goldPrice,
                      silverPrice: silverPrice,
                      goldPriceController: form.goldPrice,
                      silverPriceController: form.silverPrice,
                      isLoadingPrices: state.isLoadingPrices,
                      pricesFetchedOnline: state.pricesFetchedOnline,
                      fetchedPrices: state.fetchedPrices,
                      onRefreshPrices: widget.onRefreshPrices,
                      onFetchOnlinePressed: widget.onFetchOnlinePressed,
                      priceValidator: widget.priceValidator,
                      needsGoldPrice: needsGoldPrice,
                      needsSilverPrice: needsSilverPrice,
                      onPriceFieldChanged: widget.onPriceFieldChanged,
                      priceError: state.priceError,
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _stage == 1,
                maintainState: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ZakatSectionTitle(AppStrings.zakatSectionAssets),
                    OtherAssetsSection(
                      cashController: form.cash,
                      silverGramsController: form.silverGrams,
                      silverPriceController: form.silverPrice,
                      tradeController: form.trade,
                      receivableController: form.receivable,
                      currency: state.currency,
                    ),
                    AppGap.h(AppSize.p16),
                    GoldAssetsSection(
                      goldGramsController: form.goldGrams,
                      goldPriceController: form.goldPrice,
                      goldKarat: state.goldKarat,
                      goldPersonal: state.goldPersonal,
                      onGoldPersonalChanged: widget.onGoldPersonalChanged,
                      includePersonalGold: state.includePersonalGold,
                      onIncludePersonalGoldChanged:
                          widget.onIncludePersonalGoldChanged,
                      currency: state.currency,
                    ),
                    AppGap.h(AppSize.p16),
                    const ZakatSectionTitle(AppStrings.zakatSectionDebts),
                    DebtsSection(
                      controller: form.liabilities,
                      currency: state.currency,
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _stage == 2,
                maintainState: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ZakatSectionTitle(AppStrings.zakatSectionHawl),
                    HawlSection(
                      hawlCompleted: state.hawlCompleted,
                      hawlError: state.hawlError,
                      onHawlChanged: widget.onHawlChanged,
                    ),
                    AppGap.h(AppSize.p16),
                    Center(
                      child: TextButton.icon(
                        onPressed: widget.onClear,
                        icon: Icon(
                          AppIcons.refresh,
                          size: AppSize.icon16,
                        ),
                        label: const Text(AppStrings.zakatClearAction),
                      ),
                    ),
                  ],
                ),
              ),
              AppGap.h(AppSize.p24),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: context.color.secondaryScaffoldBackgroundColor,
            border: Border(
              top: BorderSide(
                color: context.color.dividerColor,
                width: AppSize.dividerThickness,
              ),
            ),
          ),
          child: CalculateActionButtons(
            isFirstStage: _stage == 0,
            isFinalStage: _stage == _stageCount - 1,
            canSubmit:
                state.hawlCompleted &&
                !state.isLoadingPrices &&
                !state.priceError,
            onNext: _goNext,
            onPrevious: _goPrevious,
            onSubmit: widget.onSubmit,
          ),
        ),
      ],
    );
  }
}

class _QuickHawlPrompt extends StatelessWidget {
  const _QuickHawlPrompt({
    required this.completed,
    required this.onChanged,
  });

  final bool completed;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: AppStrings.zakatHawlQuickPrompt,
      child: Container(
        padding: EdgeInsets.all(AppSize.p16),
        decoration: BoxDecoration(
          color: context.color.surfaceSelected.withValues(
            alpha: AppConstants.opacityFaint,
          ),
          borderRadius: BorderRadius.circular(AppSize.r16),
          border: Border.all(
            color: context.color.borderBrand.withValues(
              alpha: AppConstants.opacitySoft,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.zakatHawlQuickPrompt,
              style: AppTextStyles.font16W700Primary(context),
            ),
            AppGap.h(AppSize.p4),
            Text(
              AppStrings.zakatHawlQuickHint,
              style: AppTextStyles.font14W400Relaxed(context),
            ),
            AppGap.h(AppSize.p12),
            Wrap(
              spacing: AppSize.p8,
              children: [
                ChoiceChip(
                  label: const Text(AppStrings.zakatYes),
                  selected: completed,
                  onSelected: (_) => onChanged(true),
                ),
                ChoiceChip(
                  label: const Text(AppStrings.zakatNo),
                  selected: !completed,
                  onSelected: (_) => onChanged(false),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NisabSummaryStrip extends StatelessWidget {
  const _NisabSummaryStrip({
    required this.stage,
    required this.stageCount,
    required this.standardLabel,
    required this.currency,
    required this.goldPrice,
    required this.nisab,
  });

  final int stage;
  final int stageCount;
  final String standardLabel;
  final ZakatCurrency currency;
  final double? goldPrice;
  final double? nisab;

  @override
  Widget build(BuildContext context) {
    final priceText = goldPrice == null
        ? AppStrings.zakatUnknown
        : NumberUtils.formatMoney(goldPrice!, currency: currency);
    final nisabText = nisab == null
        ? AppStrings.zakatUnknown
        : NumberUtils.formatMoney(nisab!, currency: currency);
    final summary =
        '${AppStrings.zakatSummaryStandard}: $standardLabel، '
        '${AppStrings.zakatSummaryGoldPrice}: $priceText، '
        '${AppStrings.zakatSummaryNisabIn(currency.label)}: $nisabText';

    return Semantics(
      container: true,
      label: '${AppStrings.zakatStepProgress(stage + 1, stageCount)}، $summary',
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.p16,
          vertical: AppSize.p12,
        ),
        color: context.color.surfaceBrand.withValues(
          alpha: AppConstants.opacityGhost,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: Row(
                children: [
                  Icon(
                    AppIcons.sparkle,
                    size: AppSize.icon16,
                    color: context.color.iconBrand,
                  ),
                  AppGap.w(AppSize.p8),
                  Text(
                    AppStrings.zakatStepProgress(stage + 1, stageCount),
                    style: AppTextStyles.font12W700Brand(context),
                  ),
                ],
              ),
            ),
            AppGap.h(AppSize.p4),
            ExcludeSemantics(
              child: Wrap(
                spacing: AppSize.p12,
                runSpacing: AppSize.p4,
                children: [
                  Text(
                    AppStrings.zakatSummaryValue(
                      AppStrings.zakatSummaryStandard,
                      standardLabel,
                    ),
                    style: AppTextStyles.font12W500Secondary(context),
                  ),
                  Text(
                    AppStrings.zakatSummaryValue(
                      AppStrings.zakatSummaryGoldPrice,
                      priceText,
                    ),
                    style: AppTextStyles.font12W500Secondary(context),
                  ),
                  Text(
                    AppStrings.zakatSummaryValue(
                      AppStrings.zakatSummaryNisabIn(currency.label),
                      nisabText,
                    ),
                    style: AppTextStyles.font12W500Secondary(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
