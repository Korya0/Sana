import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/failure_mapper.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/core/services/timer/midnight_timer_service.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/app_date/data/models/app_date_model.dart';
import 'package:sana/features/app_date/data/repositories/app_date_repository.dart';
import 'package:sana/features/app_date/presentation/cubit/app_date_state.dart';

class AppDateCubit extends Cubit<AppDateState> with WidgetsBindingObserver {
  AppDateCubit(
    this._repository,
    this._midnightTimerService,
  ) : super(const AppDateInitial());

  final IAppDateRepository _repository;
  final IMidnightTimerService _midnightTimerService;
  StreamSubscription<void>? _midnightSubscription;

  void init() {
    WidgetsBinding.instance.addObserver(this);
    final adj = _repository.getHijriAdjustment();
    emit(AppDateLoaded(AppDateModel.now(adjustment: adj)));

    _midnightSubscription = _midnightTimerService.midnightStream.listen((_) {
      refresh();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final currentDate = this.state.date;
      if (currentDate != null) {
        final now = DateTime.now();
        // If the day has changed since we last checked, refresh the date
        if (now.day != currentDate.gregorian.day ||
            now.month != currentDate.gregorian.month ||
            now.year != currentDate.gregorian.year) {
          refresh();
        }
      }
    }
  }

  void checkMonthlyVerification() {
    unawaited(_checkMonthlyVerification());
  }

  Future<void> _checkMonthlyVerification() async {
    final currentDate = state.date;
    if (currentDate != null) {
      final currentMonth = currentDate.hijri.month;
      final currentYearMonth = currentDate.hijriMonthId;

      final lastVerified = _repository.getLastVerifiedHijriMonth();
      const verificationMonths = [
        9,
        11,
        12,
      ];

      if (verificationMonths.contains(currentMonth) &&
          currentYearMonth != lastVerified) {
        emit(AppDateVerificationDialogRequested(currentDate));
        emit(AppDateLoaded(currentDate));
      }
    }
  }

  Future<void> confirmMonthlyVerification() async {
    final currentDate = state.date;
    if (currentDate != null) {
      final currentYearMonth = currentDate.hijriMonthId;
      final result = await _repository.setLastVerifiedHijriMonth(
        currentYearMonth,
      );
      switch (result) {
        case FailureResult(:final failure):
          unawaited(
            AppLogger.localError(
              'ConfirmVerification Failure: ${failure.message}',
            ),
          );
        case Success():
          break;
      }
    }
  }

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
              AppLogger.localError('SetAdjustment Failure: ${failure.message}'),
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
      } on Object catch (e, stack) {
        unawaited(
          AppLogger.reportToFirebase(
            'SetAdjustment Error',
            error: e,
            stackTrace: stack,
          ),
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

  Future<void> resetAdjustment() async {
    await setAdjustment(0);
  }

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
    WidgetsBinding.instance.removeObserver(this);
    await _midnightSubscription?.cancel();
    return super.close();
  }
}
