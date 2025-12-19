import 'package:equatable/equatable.dart';
import 'package:sana/core/services/date/app_data.dart';

class AppDateState extends Equatable {
  final AppDate date;

  const AppDateState(this.date);

  @override
  List<Object?> get props => [date];
}
