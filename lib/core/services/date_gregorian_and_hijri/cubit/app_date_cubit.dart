import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/services/date_gregorian_and_hijri/app_date_value.dart';
import 'package:sana/core/services/date_gregorian_and_hijri/cubit/app_date_state.dart';

class AppDateCubit extends Cubit<AppDateState> {
  AppDateCubit() : super(AppDateState(AppDateValue()));

  /// تحديث التاريخ الحالي (مثلاً بعد نص الليل)
  void refresh() => emit(AppDateState(AppDateValue()));

  /// تحديث بتاريخ معين
  void updateWithDate(DateTime date) =>
      emit(AppDateState(AppDateValue(date: date)));

  DateTime get currentDate => state.date.gregorian;
}
