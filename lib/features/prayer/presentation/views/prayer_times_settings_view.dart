import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/slivers/common_sliver_app_bar.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/prayer/data/models/user_prayer_times_settings.dart';
import 'package:sana/features/prayer/presentation/controller/prayer_times_cubit.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_settings/calculation_method_widget.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_settings/madhab_widget.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_settings/settings_title.dart';

class PrayerTimesSettingsView extends StatefulWidget {
  const PrayerTimesSettingsView({super.key});

  @override
  State<PrayerTimesSettingsView> createState() =>
      _PrayerTimesSettingsViewState();
}

class _PrayerTimesSettingsViewState extends State<PrayerTimesSettingsView> {
  late CalculationMethod _selectedMethod;
  late Madhab _selectedMadhab;
  late PrayerAdjustments _adjustments;

  @override
  void initState() {
    super.initState();
    final state = context.read<PrayerTimesCubit>().state;
    _selectedMethod = state.settings.method;
    _selectedMadhab = state.settings.madhab;
    _adjustments = state.settings.adjustments;
  }

  Future<void> _saveSettings() async {
    final newSettings = UserPrayerTimesSettings(
      method: _selectedMethod,
      madhab: _selectedMadhab,
      adjustments: _adjustments,
    );
    await context.read<PrayerTimesCubit>().updateSettings(newSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CommonSliverAppBar(title: AppStrings.prayerSettingsTitle),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // طريقة الحساب
                const SettingsTitleSection(
                  title: AppStrings.calculationMethodTitle,
                ),
                const SizedBox(height: 12),
                CalculationMethodWidget(
                  selectedMethod: _selectedMethod,
                  onMethodSelected: (method) async {
                    setState(() => _selectedMethod = method);
                    await _saveSettings();
                  },
                ),
                const SizedBox(height: 24),

                // المذهب الفقهي
                const SettingsTitleSection(title: AppStrings.madhabTitle),
                const SizedBox(height: 12),
                MadhabWidget(
                  selectedMadhab: _selectedMadhab,
                  onMadhabSelected: (madhab) async {
                    setState(() => _selectedMadhab = madhab);
                    await _saveSettings();
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension PrayerAdjustmentsCopy on PrayerAdjustments {
  PrayerAdjustments copyWith({
    int? fajr,
    int? sunrise,
    int? dhuhr,
    int? asr,
    int? maghrib,
    int? isha,
  }) {
    return PrayerAdjustments(
      fajr: fajr ?? this.fajr,
      sunrise: sunrise ?? this.sunrise,
      dhuhr: dhuhr ?? this.dhuhr,
      asr: asr ?? this.asr,
      maghrib: maghrib ?? this.maghrib,
      isha: isha ?? this.isha,
    );
  }
}
