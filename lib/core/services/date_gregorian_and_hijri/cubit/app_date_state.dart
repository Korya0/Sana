import 'package:equatable/equatable.dart';
import 'package:sana/core/services/date_gregorian_and_hijri/app_date_value.dart';

class AppDateState extends Equatable {
  final AppDateValue date;

  const AppDateState(this.date);

  @override
  List<Object?> get props => [date];
}
