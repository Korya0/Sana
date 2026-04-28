import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/services/app_date/data/models/app_date_model.dart';
import 'package:sana/core/services/app_date/data/repositories/app_date_repository.dart';
import 'package:sana/core/services/app_date/presentation/cubit/app_date_state.dart';
import 'package:sana/core/utils/app_logger.dart';

class AppDateCubit extends Cubit<AppDateState> {
  AppDateCubit(this._repository) : super(const AppDateInitial()) {
    init();
    _scheduleMidnightUpdate();
  }

  final IAppDateRepository _repository;
  Timer? _timer;

  static const _verificationMonths = [
    9, // رمضان (Ramadan)
    11, // ذو القعدة (Dhu al-Qi'dah)
    12, // ذو الحجة (Dhu al-Hijjah)
  ];

  /// Initializes the state with saved values.
  void init() {
    final adj = _repository.getHijriAdjustment();
    emit(AppDateLoaded(date: AppDateModel.now(adjustment: adj)));
  }

  /// Public method to trigger verification check.
  void checkMonthlyVerification() {
    _checkMonthlyVerification();
  }

  /// Checks if the current Hijri month requires user verification.
  void _checkMonthlyVerification() {
    final currentState = state;
    if (currentState is AppDateLoaded) {
      final currentMonth = currentState.date.hijri.hMonth;
      final lastVerified = _repository.getLastVerifiedHijriMonth();

      if (_verificationMonths.contains(currentMonth) &&
          currentMonth != lastVerified) {
        if (!currentState.showVerificationDialog) {
          emit(
            currentState.copyWith(
              showVerificationDialog: true,
            ),
          );
        }
      }
    }
  }

  /// Marks the current Hijri month as verified.
  Future<void> confirmVerification() async {
    final currentState = state;
    if (currentState is AppDateLoaded) {
      try {
        final currentMonth = currentState.date.hijri.hMonth;
        final result = await _repository.setLastVerifiedHijriMonth(
          currentMonth,
        );

        result.when(
          success: (_) {
            if (!isClosed) {
              emit(
                currentState.copyWith(
                  showVerificationDialog: false,
                ),
              );
            }
          },
          failure: (failure) => unawaited(
            AppLogger.error(
              'ConfirmVerification Failure: ${failure.message}',
            ),
          ),
        );
      } on Exception catch (e, stack) {
        unawaited(
          AppLogger.error(
            'ConfirmVerification Error',
            error: e,
            stackTrace: stack,
          ),
        );
      }
    }
  }

  /// Saves a new Hijri day adjustment value.
  Future<void> setAdjustment(int adj) async {
    final currentState = state;
    if (currentState is AppDateLoaded) {
      try {
        final result = await _repository.setHijriAdjustment(adj);

        result.when(
          success: (_) {
            if (!isClosed) {
              emit(
                currentState.copyWith(
                  date: AppDateModel.fromDate(
                    currentState.date.gregorian,
                    adjustment: adj,
                  ),
                ),
              );
            }
          },
          failure: (failure) => unawaited(
            AppLogger.error('SetAdjustment Failure: ${failure.message}'),
          ),
        );
      } on Exception catch (e, stack) {
        unawaited(
          AppLogger.error('SetAdjustment Error', error: e, stackTrace: stack),
        );
      }
    }
  }

  /// Resets the Hijri day adjustment.
  Future<void> resetAdjustment() async {
    await setAdjustment(0);
  }

  /// Refreshes the date to current time.
  void refresh() {
    final currentState = state;
    if (currentState is AppDateLoaded) {
      emit(
        currentState.copyWith(
          date: AppDateModel.now(adjustment: currentState.date.adjustment),
        ),
      );
      _checkMonthlyVerification();
    }
  }

  /// Schedules an automatic date refresh at midnight.
  void _scheduleMidnightUpdate() {
    _timer?.cancel();
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final duration = nextMidnight.difference(now);

    _timer = Timer(duration + const Duration(seconds: 1), () {
      refresh();
      _scheduleMidnightUpdate();
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
