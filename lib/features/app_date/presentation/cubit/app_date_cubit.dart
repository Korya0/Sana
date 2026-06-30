import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/failure_mapper.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/features/app_date/data/models/app_date_model.dart';
import 'package:sana/features/app_date/domain/repositories/i_app_date_repository.dart';
import 'package:sana/features/app_date/presentation/cubit/app_date_state.dart';
import 'package:sana/core/services/time/domain/services/i_midnight_timer_service.dart';
import 'package:sana/core/utils/utils.dart';

class AppDateCubit extends Cubit<AppDateState> {
  AppDateCubit(
    this._repository,
    this._midnightTimerService,
  ) : super(const AppDateInitial());

  final IAppDateRepository _repository;
  final IMidnightTimerService _midnightTimerService;
  StreamSubscription<void>? _midnightSubscription;

  /// Initializes the state with saved values.
  void init() {
    final adj = _repository.getHijriAdjustment();
    emit(AppDateLoaded(AppDateModel.now(adjustment: adj)));

    // Listen to midnight timer to refresh the date automatically
    _midnightSubscription = _midnightTimerService.midnightStream.listen((_) {
      refresh();
    });

    // Check monthly verification after a short delay to allow UI to mount
    Future.delayed(const Duration(seconds: 1), checkMonthlyVerification);
  }

  /// Public method to trigger verification check.
  void checkMonthlyVerification() {
    unawaited(_checkMonthlyVerification());
  }

  /// Checks if the current Hijri month requires user verification.
  Future<void> _checkMonthlyVerification() async {
    final currentDate = state.date;
    if (currentDate != null) {
      final currentMonth = currentDate.hijri.month;
      final currentYearMonth = currentDate.hijriMonthId;

      final lastVerified = _repository.getLastVerifiedHijriMonth();
      const verificationMonths = [
        1,
        9,
        11,
        12,
      ]; // Ramadan, Dhu al-Qi'dah, Dhu al-Hijjah

      if (verificationMonths.contains(currentMonth) &&
          currentYearMonth != lastVerified) {
        
        emit(AppDateVerificationDialogRequested(currentDate));
        emit(AppDateLoaded(currentDate)); // Return to normal state
      }
    }
  }

  /// Marks the current month as verified by the user.
  Future<void> confirmMonthlyVerification() async {
    final currentDate = state.date;
    if (currentDate != null) {
      final currentYearMonth = currentDate.hijriMonthId;
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
    }
  }

  /// Saves a new Hijri day adjustment value.
  Future<void> setAdjustment(int adj) async {
    final currentDate = state.date;
    if (currentDate != null) {
      try {
        final result = await _repository.setHijriAdjustment(adj);

        switch (result) {
          case Success():
            if (!isClosed) {
              emit(
                AppDateLoaded(
                  AppDateModel.fromDate(
                    currentDate.gregorian,
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
                AppDateErrorState(
                  currentDate,
                  FailureMapper.mapFailureToMessage(failure),
                ),
              );
              emit(AppDateLoaded(currentDate));
            }
        }
      } on Exception catch (e, stack) {
        unawaited(
          AppLogger.error('SetAdjustment Error', error: e, stackTrace: stack),
        );
        if (!isClosed) {
          emit(
            AppDateErrorState(
              currentDate,
              FailureMapper.mapFailureToMessage(
                UnknownFailure(message: e.toString()),
              ),
            ),
          );
          emit(AppDateLoaded(currentDate));
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
    final currentDate = state.date;
    if (currentDate != null) {
      emit(
        AppDateLoaded(
          AppDateModel.now(adjustment: currentDate.adjustment),
        ),
      );
      unawaited(_checkMonthlyVerification());
    }
  }

  @override
  Future<void> close() async {
    await _midnightSubscription?.cancel();
    return super.close();
  }
}
