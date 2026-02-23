import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/app_date/data/models/app_date_value.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_state.dart';

class AppDateCubit extends Cubit<AppDateState> {
  AppDateCubit() : super(AppDateState(AppDateValue())) {
    _scheduleMidnightUpdate();
  }

  Timer? _timer;

  /// تحديث التاريخ الحالي (مثلاً بعد منتصف الليل)
  void refresh() => emit(AppDateState(AppDateValue()));

  /// تحديث بتاريخ معين
  void updateWithDate(DateTime date) =>
      emit(AppDateState(AppDateValue(date: date)));

  DateTime get currentDate => state.date.gregorian;

  void _scheduleMidnightUpdate() {
    _timer?.cancel();
    final now = DateTime.now();

    // اليوم القادم عند الساعة 00:00:00
    // Dart handles overflow accurately (e.g., month end)
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final duration = nextMidnight.difference(now);

    // إضافة ثانية احتياطية لضمان الانتقال الكامل لليوم الجديد
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
