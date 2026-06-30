import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/failure_mapper.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/services/app_date/data/models/app_date_model.dart';
import 'package:sana/core/services/app_date/domain/repositories/i_app_date_repository.dart';
import 'package:sana/core/services/app_date/presentation/cubit/app_date_state.dart';
import 'package:sana/core/utils/utils.dart';

class AppDateCubit extends Cubit<AppDateState> {
  AppDateCubit(this._repository) : super(const AppDateInitial()) {
    init();
    _scheduleMidnightUpdate();
  }

  final IAppDateRepository _repository;
  Timer? _timer;

  /// Initializes the state with saved values.
  void init() {
    final adj = _repository.getHijriAdjustment();
    emit(AppDateLoaded(date: AppDateModel.now(adjustment: adj)));
  }

  /// Public method to trigger verification check.
  void checkMonthlyVerification() {
    unawaited(_checkMonthlyVerification());
  }

  /// Checks if the current Hijri month requires user verification.
  Future<void> _checkMonthlyVerification() async {
    final currentState = state;
    if (currentState is AppDateLoaded) {
      final currentMonth = currentState.date.hijri.hMonth;
      final currentYear = currentState.date.hijri.hYear;
      final currentYearMonth = (currentYear * 100) + currentMonth;

      final lastVerified = _repository.getLastVerifiedHijriMonth();
      const verificationMonths = [
        9,
        11,
        12,
      ]; // Ramadan, Dhu al-Qi'dah, Dhu al-Hijjah

      if (verificationMonths.contains(currentMonth) &&
          currentYearMonth != lastVerified) {
        if (!currentState.showVerificationDialog) {
          emit(
            currentState.copyWith(
              showVerificationDialog: true,
            ),
          );
        }

        // Mark as verified internally
        final result =
            await _repository.setLastVerifiedHijriMonth(currentYearMonth);
        switch (result) {
          case FailureResult(:final failure):
            unawaited(
              AppLogger.error(
                'ConfirmVerification Failure: ${failure.message}',
              ),
            );
          case Success():
            break;
        }
      } else {
        if (currentState.showVerificationDialog) {
          emit(
            currentState.copyWith(
              showVerificationDialog: false,
            ),
          );
        }
      }
    }
  }

  /// Saves a new Hijri day adjustment value.
  Future<void> setAdjustment(int adj) async {
    final currentState = state;
    if (currentState is AppDateLoaded) {
      try {
        final result = await _repository.setHijriAdjustment(adj);

        switch (result) {
          case Success():
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
          case FailureResult(:final failure):
            unawaited(
              AppLogger.error('SetAdjustment Failure: ${failure.message}'),
            );
            if (!isClosed) {
              emit(
                currentState.copyWith(
                  errorMessage: FailureMapper.mapFailureToMessage(failure),
                ),
              );
              emit(currentState.copyWith(clearError: true));
            }
        }
      } on Exception catch (e, stack) {
        unawaited(
          AppLogger.error('SetAdjustment Error', error: e, stackTrace: stack),
        );
        if (!isClosed) {
          emit(
            currentState.copyWith(
              errorMessage: FailureMapper.mapFailureToMessage(
                UnknownFailure(message: e.toString()),
              ),
            ),
          );
          emit(currentState.copyWith(clearError: true));
        }
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
      unawaited(_checkMonthlyVerification());
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
