import 'package:equatable/equatable.dart';
import 'package:sana/features/app_date/data/models/app_date_value.dart';

sealed class AppDateState extends Equatable {
  const AppDateState();

  AppDateValue get date => throw UnimplementedError('State is not Loaded');
  bool get showVerificationDialog => false;

  @override
  List<Object?> get props => [];
}

class AppDateInitial extends AppDateState {
  const AppDateInitial();
}

class AppDateLoaded extends AppDateState {
  const AppDateLoaded({
    required this.date,
    this.showVerificationDialog = false,
  });

  @override
  final AppDateValue date;
  @override
  final bool showVerificationDialog;

  AppDateLoaded copyWith({
    AppDateValue? date,
    bool? showVerificationDialog,
  }) {
    return AppDateLoaded(
      date: date ?? this.date,
      showVerificationDialog:
          showVerificationDialog ?? this.showVerificationDialog,
    );
  }

  @override
  List<Object?> get props => [date, showVerificationDialog];
}
