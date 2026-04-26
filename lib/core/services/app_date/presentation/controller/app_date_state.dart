import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sana/core/services/app_date/data/models/app_date_value.dart';

part 'app_date_state.freezed.dart';

@freezed
class AppDateState with _$AppDateState {
  const AppDateState._();

  const factory AppDateState.initial() = AppDateInitial;
  const factory AppDateState.loaded({
    required AppDateValue date,
    @Default(false) bool showVerificationDialog,
  }) = AppDateLoaded;

  AppDateValue get dateValue {
    return maybeWhen(
      loaded: (date, _) => date,
      orElse: () => throw UnimplementedError('State is not Loaded'),
    );
  }

  bool get verificationShown {
    return maybeWhen(
      loaded: (_, show) => show,
      orElse: () => false,
    );
  }
}
