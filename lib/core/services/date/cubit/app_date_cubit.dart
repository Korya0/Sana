import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/services/date/app_data.dart';
import 'app_date_state.dart';

class AppDateCubit extends Cubit<AppDateState> {
  AppDateCubit() : super(AppDateState(AppDate()));

  /// تحديث التاريخ الحالي (مثلاً بعد نص الليل)
  void refresh() => emit(AppDateState(AppDate()));

  /// تحديث بتاريخ معين
  void updateWithDate(DateTime date) => emit(AppDateState(AppDate(date: date)));

  /// Helper to get current underlying DateTime
  DateTime get currentDate => state.date.gregorian;
}
