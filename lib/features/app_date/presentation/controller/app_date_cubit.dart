import 'dart:async';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/app_date/data/models/app_date_value.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_state.dart';

class AppDateCubit extends Cubit<AppDateState> {
  AppDateCubit(this._sharedPref, this._remoteConfig)
    : super(AppDateState(AppDateValue())) {
    unawaited(_init());
  }

  final SharedPref _sharedPref;
  final FirebaseRemoteConfig _remoteConfig;
  Timer? _timer;

  Future<void> _init() async {
    _loadStoredSettings();
    _scheduleMidnightUpdate();

    // محاولة جلب البيانات فوراً عند التشغيل
    await syncWithRemoteConfig();

    // التحقق من الحاجة لإظهار السؤال
    _checkSocialVerification();
  }

  void _loadStoredSettings() {
    final adj = _sharedPref.getInt(PrefKeys.hijriAdjustment) ?? 0;
    final isManual =
        _sharedPref.getBoolean(PrefKeys.isManualAdjustment) ?? false;
    final showPulse = _sharedPref.getBoolean(PrefKeys.showHijriPulse) ?? false;

    emit(
      AppDateState(
        AppDateValue(adjustment: adj, isManual: isManual),
        showPulse: showPulse,
      ),
    );
  }

  void _checkSocialVerification() {
    final isEnabled = _remoteConfig.getBool('enable_hijri_verification_dialog');
    final monthsStr = _remoteConfig.getString('hijri_verification_months');

    AppLogger.debug('AppDate [Test]: enabled=$isEnabled, months=$monthsStr');

    if (!isEnabled) return;

    final allowedMonths = monthsStr
        .split(',')
        .where((e) => e.isNotEmpty)
        .map((e) => int.tryParse(e.trim()) ?? 0)
        .toList();

    final currentHijri = HijriCalendar.now();
    final lastVerified =
        _sharedPref.getInt(PrefKeys.lastVerifiedHijriMonth) ?? 0;

    AppLogger.debug(
      'AppDate [Test]: CurrentHijri=${currentHijri.hMonth}, LastVerified=$lastVerified',
    );

    if (allowedMonths.contains(currentHijri.hMonth)) {
      if (currentHijri.hMonth != lastVerified) {
        AppLogger.success('AppDate [Test]: Showing Verification Dialog!');
        emit(
          AppDateState(
            state.date,
            showPulse: state.showPulse,
            showVerificationDialog: true,
          ),
        );
      } else {
        AppLogger.debug('AppDate [Test]: Already verified for this month.');
      }
    } else {
      AppLogger.debug(
        'AppDate [Test]: Current month not in verification list.',
      );
    }
  }

  Future<void> syncWithRemoteConfig() async {
    if (state.date.isManual) return;

    try {
      await _remoteConfig.fetchAndActivate();
      final remoteAdj = _remoteConfig.getInt('hijri_adjustment');

      AppLogger.debug(
        'AppDate [Sync]: remoteAdj=$remoteAdj, localAdj=${state.date.adjustment}',
      );

      if (remoteAdj != state.date.adjustment) {
        await _sharedPref.setInt(PrefKeys.hijriAdjustment, remoteAdj);
        await _sharedPref.setBoolean(PrefKeys.showHijriPulse, true);

        emit(
          AppDateState(
            state.date.copyWith(adjustment: remoteAdj),
            showPulse: true,
            showVerificationDialog: state.showVerificationDialog,
          ),
        );
      }
    } on Exception catch (e) {
      AppLogger.warn('AppDate Remote Config Fail: $e');
    }
  }

  Future<void> confirmSocialVerification(bool isCorrect) async {
    final currentHijri = HijriCalendar.now();
    await _sharedPref.setInt(
      PrefKeys.lastVerifiedHijriMonth,
      currentHijri.hMonth,
    );

    emit(
      AppDateState(
        state.date,
        showPulse: state.showPulse,
      ),
    );
  }

  /// دالة خاصة للاختبار (تقوم بمسح حالة التحقق) لتتمكن من رؤية الدايلوج مرة أخرى
  Future<void> resetVerificationForTesting() async {
    await _sharedPref.setInt(PrefKeys.lastVerifiedHijriMonth, 0);
    _checkSocialVerification();
  }

  Future<void> setManualAdjustment(int adj) async {
    await _sharedPref.setInt(PrefKeys.hijriAdjustment, adj);
    await _sharedPref.setBoolean(PrefKeys.isManualAdjustment, true);
    await _sharedPref.setBoolean(PrefKeys.showHijriPulse, false);
    emit(
      AppDateState(
        state.date.copyWith(adjustment: adj, isManual: true),
        showVerificationDialog: state.showVerificationDialog,
      ),
    );
  }

  Future<void> resetToAuto() async {
    await _sharedPref.setBoolean(PrefKeys.isManualAdjustment, false);
    emit(
      AppDateState(
        state.date.copyWith(isManual: false),
        showPulse: state.showPulse,
        showVerificationDialog: state.showVerificationDialog,
      ),
    );
    await syncWithRemoteConfig();
  }

  Future<void> clearPulse() async {
    if (state.showPulse) {
      await _sharedPref.setBoolean(PrefKeys.showHijriPulse, false);
      emit(
        AppDateState(
          state.date,
          showVerificationDialog: state.showVerificationDialog,
        ),
      );
    }
  }

  void refresh() {
    _checkSocialVerification();
    emit(
      AppDateState(
        state.date.copyWith(date: DateTime.now()),
        showPulse: state.showPulse,
        showVerificationDialog: state.showVerificationDialog,
      ),
    );
  }

  DateTime get currentDate => state.date.gregorian;

  void _scheduleMidnightUpdate() {
    _timer?.cancel();
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final duration = nextMidnight.difference(now);

    _timer = Timer(duration + const Duration(seconds: 1), () {
      refresh();
      _scheduleMidnightUpdate();
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
