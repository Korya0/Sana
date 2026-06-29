import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/prayer/data/models/prayer_calculation_settings.dart';
import 'package:sana/features/prayer/data/models/user_prayer_times_settings.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_cubit.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_settings/calculation_method_widget.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_settings/madhab_widget.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_settings/prayer_location_widget.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_settings/settings_title.dart';

class PrayerTimesSettingsView extends StatefulWidget {
  const PrayerTimesSettingsView({super.key});

  @override
  State<PrayerTimesSettingsView> createState() =>
      _PrayerTimesSettingsViewState();
}

class _PrayerTimesSettingsViewState extends State<PrayerTimesSettingsView> {
  late CalculationMethodEntity _selectedMethod;
  late MadhabEntity _selectedMadhab;
  late PrayerAdjustmentsEntity _adjustments;

  @override
  void initState() {
    super.initState();
    final settings = context.read<PrayerTimesCubit>().state.settings;
    _selectedMethod = settings.method;
    _selectedMadhab = settings.madhab;
    _adjustments = settings.adjustments;
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

                const SettingsTitleSection(title: 'الموقع'),
                const SizedBox(height: 12),
                const PrayerLocationWidget(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
