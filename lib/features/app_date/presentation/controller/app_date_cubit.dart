import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/app_date/data/models/app_date_value.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_state.dart';

class AppDateCubit extends Cubit<AppDateState> {
  AppDateCubit(this._sharedPref) : super(_getInitialState(_sharedPref)) {
    _scheduleMidnightUpdate();
  }

  final SharedPref _sharedPref;
  Timer? _timer;

  static const _verificationMonths = [
    9, // رمضان (Ramadan)
    11, // ذو القعدة (Dhu al-Qi'dah)
    12, // ذو الحجة (Dhu al-Hijjah)
  ];

  /// Loads the saved Hijri adjustment from SharedPreferences and returns the initial state.
  static AppDateState _getInitialState(SharedPref pref) {
    final adj = pref.getInt(PrefKeys.hijriAdjustment) ?? 0;
    return AppDateState(date: AppDateValue(adjustment: adj));
  }

  /// Public method to trigger verification check.
  void checkMonthlyVerification() {
    _checkMonthlyVerification();
  }

  /// Checks if the current Hijri month requires user verification and shows the dialog if needed.
  void _checkMonthlyVerification() {
    final currentMonth = state.date.hijri.hMonth;
    final lastVerified =
        _sharedPref.getInt(PrefKeys.lastVerifiedHijriMonth) ?? 0;

    if (_verificationMonths.contains(currentMonth) &&
        currentMonth != lastVerified) {
      if (!state.showVerificationDialog) {
        emit(state.copyWith(showVerificationDialog: true));
      }
    }
  }

  /// Marks the current Hijri month as verified and dismisses the verification dialog.
  Future<void> confirmVerification() async {
    try {
      final currentMonth = state.date.hijri.hMonth;
      await _sharedPref.setInt(PrefKeys.lastVerifiedHijriMonth, currentMonth);
      if (!isClosed) emit(state.copyWith(showVerificationDialog: false));
    } catch (e, stack) {
      unawaited(
        AppLogger.error(
          'ConfirmVerification Error',
          error: e,
          stackTrace: stack,
        ),
      );
    }
  }

  /// Saves a new Hijri day adjustment value and updates the state.
  Future<void> setAdjustment(int adj) async {
    try {
      await _sharedPref.setInt(PrefKeys.hijriAdjustment, adj);
      if (!isClosed) {
        emit(state.copyWith(date: state.date.copyWith(adjustment: adj)));
      }
    } catch (e, stack) {
      unawaited(
        AppLogger.error('SetAdjustment Error', error: e, stackTrace: stack),
      );
    }
  }

  /// Resets the Hijri day adjustment back to zero.
  Future<void> resetAdjustment() async {
    try {
      await _sharedPref.setInt(PrefKeys.hijriAdjustment, 0);
      if (!isClosed) {
        emit(state.copyWith(date: state.date.copyWith(adjustment: 0)));
      }
    } catch (e, stack) {
      unawaited(
        AppLogger.error('ResetAdjustment Error', error: e, stackTrace: stack),
      );
    }
  }

  /// Refreshes the date to the current time and re-checks monthly verification.
  void refresh() {
    emit(state.copyWith(date: state.date.copyWith(date: DateTime.now())));
    _checkMonthlyVerification();
  }

  /// Schedules an automatic date refresh at midnight to keep the displayed date up-to-date.
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

  /// Cancels the midnight timer when the cubit is disposed.
  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
