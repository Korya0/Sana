import 'package:sana/features/app_date/data/models/app_date_model.dart';

sealed class AppDateState {
  const AppDateState({this.date});
  final AppDateModel? date;
}

final class AppDateInitial extends AppDateState {
  const AppDateInitial() : super();
}

final class AppDateLoaded extends AppDateState {
  const AppDateLoaded(AppDateModel date) : super(date: date);
  @override
  AppDateModel get date => super.date!;
}

final class AppDateVerificationDialogRequested extends AppDateState {
  const AppDateVerificationDialogRequested(AppDateModel date)
    : super(date: date);
  @override
  AppDateModel get date => super.date!;
}

final class AppDateErrorState extends AppDateState {
  const AppDateErrorState(AppDateModel date, this.errorMessage)
    : super(date: date);
  @override
  AppDateModel get date => super.date!;
  final String errorMessage;
}

extension AppDateStateX on AppDateState {
  AppDateModel get dateValue {
    if (date != null) return date!;
    throw UnimplementedError('State does not contain a date');
  }
}
