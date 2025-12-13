import 'dart:async';
import 'package:adhan/adhan.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/prayer/data/get_prayers_list.dart';
import 'package:sana/features/prayer/data/models/user_prayer_times_settings.dart';
import 'package:sana/features/prayer/data/services/prayer_times_service.dart';
import 'package:sana/features/prayer/data/services/user_settings_service.dart';
part 'prayer_times_state.dart';

class PrayerTimesCubit extends Cubit<PrayerTimesState> {
  final PrayerTimesService prayerTimesService;
  final UserSettingsService settingsService;
  final Coordinates coords;
  final DateTime dateTime;
  Timer? _timer;
  DateTime? _lastCalculationDate;

  PrayerTimesCubit({
    required this.prayerTimesService,
    required this.settingsService,
    required this.dateTime,
    required this.coords,
  }) : super(PrayerTimesState.initial());

  Future<void> loadSettings() async {
    final settings = await settingsService.loadSettings();
    emit(state.copyWith(settings: settings));
    _calculatePrayerTimes();
    _startCountdownTimer();
  }

  void updateSettings(UserPrayerTimesSettings settings) async {
    await settingsService.saveSettings(settings);
    emit(state.copyWith(settings: settings));
    _calculatePrayerTimes();
  }

  void _calculatePrayerTimes() async {
    _lastCalculationDate = DateTime.now();
    final prayerTimes = prayerTimesService.calculatePrayerTimes(
      settings: state.settings,
      coords: coords,
      dateTime: dateTime,
    );
    final sunnahTimes = prayerTimesService.calculateSunnahTimes(
      prayerTimes: prayerTimes,
    );
    final current = prayerTimesService.getCurrentPrayer(prayerTimes);
    final next = prayerTimesService.getNextPrayer(prayerTimes);

    // اسم الصلاة القادمة
    final nextPrayerInfo = getPrayersList(
      prayerTimes,
    ).firstWhere((p) => p.prayer == next);

    emit(
      state.copyWith(
        prayerTimes: prayerTimes,
        sunnahTimes: sunnahTimes,
        currentPrayer: current,
        nextPrayer: next,
        nextPrayerName: nextPrayerInfo.name,
      ),
    );
  }

  void _startCountdownTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.prayerTimes == null) return;

      // Check if day changed while app was open
      final now = DateTime.now();
      if (_lastCalculationDate != null &&
          _lastCalculationDate!.day != now.day) {
        // Recalculate for the new day
        _calculatePrayerTimes();
        return;
      }

      final countdown = prayerTimesService.getCountdownToNextPrayer(
        state.prayerTimes!,
      );
      final formatted =
          "${countdown.inHours.toString().padLeft(2, '0')}:${(countdown.inMinutes % 60).toString().padLeft(2, '0')}:${(countdown.inSeconds % 60).toString().padLeft(2, '0')}";
      emit(state.copyWith(countdownNextPrayer: formatted));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
