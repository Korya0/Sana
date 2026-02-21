import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/utils/date_gregorian_and_hijri/app_date_value.dart';
import 'package:sana/core/utils/date_gregorian_and_hijri/cubit/app_date_state.dart';

class AppDateCubit extends Cubit<AppDateState> {

  AppDateCubit() : super(AppDateState(AppDateValue())) {
    _scheduleMidnightUpdate();
  }
  Timer? _timer;

  /// تحديث التاريخ الحالي (مثلاً بعد نص الليل)
  void refresh() => emit(AppDateState(AppDateValue()));

  /// تحديث بتاريخ معين
  void updateWithDate(DateTime date) =>
      emit(AppDateState(AppDateValue(date: date)));

  DateTime get currentDate => state.date.gregorian;

  void _scheduleMidnightUpdate() {
    _timer?.cancel();
    final now = DateTime.now();
    // Next midnight: tomorrow 00:00:00
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final duration = nextMidnight.difference(now);

    // Add small buffer (1 sec) to be sure we are in the new day
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
