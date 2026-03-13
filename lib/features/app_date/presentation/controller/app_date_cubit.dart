import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/app_date/data/models/app_date_value.dart';
import 'package:sana/features/app_date/data/repositories/app_date_repository.dart';

import 'package:sana/features/app_date/presentation/controller/app_date_state.dart';

class AppDateCubit extends Cubit<AppDateState> {
  AppDateCubit(this._repository) : super(const AppDateState.initial()) {
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
    emit(AppDateState.loaded(date: AppDateValue.now(adjustment: adj)));
  }

  /// Public method to trigger verification check.
  void checkMonthlyVerification() {
    _checkMonthlyVerification();
  }

  /// Checks if the current Hijri month requires user verification.
  void _checkMonthlyVerification() {
    state.maybeWhen(
      loaded: (date, showVerificationDialog) {
        final currentMonth = date.hijri.hMonth;
        final lastVerified = _repository.getLastVerifiedHijriMonth();

        if (_verificationMonths.contains(currentMonth) &&
            currentMonth != lastVerified) {
          if (!showVerificationDialog) {
            emit(
              AppDateState.loaded(
                date: date,
                showVerificationDialog: true,
              ),
            );
          }
        }
      },
      orElse: () {},
    );
  }

  /// Marks the current Hijri month as verified.
  Future<void> confirmVerification() async {
    await state.maybeWhen(
      loaded: (date, _) async {
        try {
          final currentMonth = date.hijri.hMonth;
          final result = await _repository.setLastVerifiedHijriMonth(
            currentMonth,
          );

          result.when(
            success: (_) {
              if (!isClosed) {
                emit(
                  AppDateState.loaded(
                    date: date,
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
      },
      orElse: () async {},
    );
  }

  /// Saves a new Hijri day adjustment value.
  Future<void> setAdjustment(int adj) async {
    await state.maybeWhen(
      loaded: (date, showVerificationDialog) async {
        try {
          final result = await _repository.setHijriAdjustment(adj);

          result.when(
            success: (_) {
              if (!isClosed) {
                emit(
                  AppDateState.loaded(
                    date: AppDateValue.fromDate(
                      date.gregorian,
                      adjustment: adj,
                    ),
                    showVerificationDialog: showVerificationDialog,
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
      },
      orElse: () async {},
    );
  }

  /// Resets the Hijri day adjustment.
  Future<void> resetAdjustment() async {
    await setAdjustment(0);
  }

  /// Refreshes the date to current time.
  void refresh() {
    state.maybeWhen(
      loaded: (date, showVerificationDialog) {
        emit(
          AppDateState.loaded(
            date: AppDateValue.now(adjustment: date.adjustment),
            showVerificationDialog: showVerificationDialog,
          ),
        );
        _checkMonthlyVerification();
      },
      orElse: () {},
    );
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
