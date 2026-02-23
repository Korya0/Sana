import 'package:equatable/equatable.dart';
import 'package:sana/features/app_date/data/models/app_date_value.dart';

class AppDateState extends Equatable {
  const AppDateState(
    this.date, {
    this.showPulse = false,
    this.showVerificationDialog = false,
  });

  final AppDateValue date;
  final bool showPulse;
  final bool showVerificationDialog;

  @override
  List<Object?> get props => [date, showPulse, showVerificationDialog];
}
