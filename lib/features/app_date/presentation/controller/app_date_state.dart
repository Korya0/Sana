import 'package:equatable/equatable.dart';
import 'package:sana/features/app_date/data/models/app_date_value.dart';

class AppDateState extends Equatable {
  const AppDateState(this.date);

  final AppDateValue date;

  @override
  List<Object?> get props => [date];
}
