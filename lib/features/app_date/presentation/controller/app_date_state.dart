import 'package:equatable/equatable.dart';
import 'package:sana/features/app_date/data/models/app_date_value.dart';

class AppDateState extends Equatable {
  const AppDateState({
    required this.date,
    this.showVerificationDialog = false,
  });

  final AppDateValue date;
  final bool showVerificationDialog;

  AppDateState copyWith({
    AppDateValue? date,
    bool? showVerificationDialog,
  }) {
    return AppDateState(
      date: date ?? this.date,
      showVerificationDialog:
          showVerificationDialog ?? this.showVerificationDialog,
    );
  }

  @override
  List<Object?> get props => [date, showVerificationDialog];
}
