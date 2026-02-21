import 'package:equatable/equatable.dart';
import 'package:sana/core/utils/date_gregorian_and_hijri/app_date_value.dart';

class AppDateState extends Equatable {

  const AppDateState(this.date);
  final AppDateValue date;

  @override
  List<Object?> get props => [date];
}
