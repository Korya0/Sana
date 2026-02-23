import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';
import 'package:sana/features/app_date/data/models/app_date_value.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_state.dart';

class AppDateCubit extends Cubit<AppDateState> {
  AppDateCubit(this._sharedPref) : super(_getInitialState(_sharedPref)) {
    _scheduleMidnightUpdate();
    _checkMonthlyVerification();
  }

  final SharedPref _sharedPref;
  Timer? _timer;

  static const _verificationMonths = [9, 10, 12];

  static AppDateState _getInitialState(SharedPref pref) {
    final adj = pref.getInt(PrefKeys.hijriAdjustment) ?? 0;
    return AppDateState(date: AppDateValue(adjustment: adj));
  }

  void _checkMonthlyVerification() {
    final currentMonth = state.date.hijri.hMonth;
    final lastVerified =
        _sharedPref.getInt(PrefKeys.lastVerifiedHijriMonth) ?? 0;

    if (_verificationMonths.contains(currentMonth) &&
        currentMonth != lastVerified) {
      emit(state.copyWith(showVerificationDialog: true));
    }
  }

  Future<void> confirmVerification() async {
    final currentMonth = state.date.hijri.hMonth;
    await _sharedPref.setInt(PrefKeys.lastVerifiedHijriMonth, currentMonth);
    emit(state.copyWith(showVerificationDialog: false));
  }

  Future<void> setAdjustment(int adj) async {
    await _sharedPref.setInt(PrefKeys.hijriAdjustment, adj);
    emit(state.copyWith(date: state.date.copyWith(adjustment: adj)));
  }

  Future<void> resetAdjustment() async {
    await _sharedPref.setInt(PrefKeys.hijriAdjustment, 0);
    emit(state.copyWith(date: state.date.copyWith(adjustment: 0)));
  }

  void refresh() {
    emit(state.copyWith(date: state.date.copyWith(date: DateTime.now())));
    _checkMonthlyVerification();
  }

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
