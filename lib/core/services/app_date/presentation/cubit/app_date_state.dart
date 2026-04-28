import 'package:sana/core/services/app_date/data/models/app_date_model.dart';

sealed class AppDateState {
  const AppDateState();
}

final class AppDateInitial extends AppDateState {
  const AppDateInitial();
}

final class AppDateLoaded extends AppDateState {
  const AppDateLoaded({
    required this.date,
    this.showVerificationDialog = false,
  });
  final AppDateModel date;
  final bool showVerificationDialog;

  AppDateLoaded copyWith({
    AppDateModel? date,
    bool? showVerificationDialog,
  }) {
    return AppDateLoaded(
      date: date ?? this.date,
      showVerificationDialog:
          showVerificationDialog ?? this.showVerificationDialog,
    );
  }
}

extension AppDateStateX on AppDateState {
  AppDateModel get dateValue {
    return switch (this) {
      AppDateLoaded(:final date) => date,
      _ => throw UnimplementedError('State is not Loaded'),
    };
  }

  bool get verificationShown {
    return switch (this) {
      AppDateLoaded(showVerificationDialog: final shown) => shown,
      _ => false,
    };
  }
}
