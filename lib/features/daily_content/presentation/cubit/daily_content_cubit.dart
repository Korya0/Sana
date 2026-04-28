import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/services/app_date/presentation/cubit/app_date_cubit.dart';
import 'package:sana/core/services/app_date/presentation/cubit/app_date_state.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/daily_content/constants/daily_content_keys.dart';
import 'package:sana/features/daily_content/data/datasources/daily_content_datasource.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';
import 'package:sana/features/daily_content/data/repos/daily_content_repository.dart';
import 'package:sana/features/daily_content/presentation/cubit/daily_content_state.dart';

class DailyContentCubit extends Cubit<DailyContentState> {
  DailyContentCubit(this.appDateCubit, this.repository)
    : super(const DailyContentState()) {
    unawaited(loadDailyContent());
    _dateSubscription = appDateCubit.stream.listen((_) => _checkRefresh());
  }

  final AppDateCubit appDateCubit;
  final IDailyContentRepository repository;
  StreamSubscription<AppDateState>? _dateSubscription;

  Future<void> loadDailyContent() async {
    try {
      if (state.status != DailyContentStatus.success) {
        emit(state.copyWith(status: DailyContentStatus.loading));
      }

      final contentData = await DailyContentDataSource.loadDailyContent();

      final hadithsData =
          contentData[DailyContentKeys.dailyHadith] ?? <DailyContentModel>[];
      final sunnahsData =
          contentData[DailyContentKeys.dailySunnah] ?? <DailyContentModel>[];

      if (hadithsData.isEmpty || sunnahsData.isEmpty) {
        emit(state.copyWith(status: DailyContentStatus.failure));
        return;
      }

      final today = _getTodayDateString();

      // Advancing Day Logic
      await repository.advanceCategoryIfNewDay(
        DailyContentKeys.categoryHadith,
        hadithsData.length,
        today,
      );
      await repository.advanceCategoryIfNewDay(
        DailyContentKeys.categorySunnah,
        sunnahsData.length,
        today,
      );

      // Fetch Current Items
      final hadithRes = await repository.getDailyItem(
        category: DailyContentKeys.categoryHadith,
        all: hadithsData,
      );
      final sunnahRes = await repository.getDailyItem(
        category: DailyContentKeys.categorySunnah,
        all: sunnahsData,
      );

      var hasFailure = false;
      hadithRes.maybeWhen(failure: (_) => hasFailure = true, orElse: () {});
      sunnahRes.maybeWhen(failure: (_) => hasFailure = true, orElse: () {});

      if (hasFailure) {
        emit(state.copyWith(status: DailyContentStatus.failure));
        return;
      }

      DailyContentModel? hadith;
      hadithRes.when(
        success: (val) => hadith = val,
        failure: (_) => null,
      );

      DailyContentModel? sunnah;
      sunnahRes.when(
        success: (val) => sunnah = val,
        failure: (_) => null,
      );

      if (hadith == null || sunnah == null) {
        emit(state.copyWith(status: DailyContentStatus.failure));
        return;
      }

      emit(
        state.copyWith(
          status: DailyContentStatus.success,
          dailyHadith: hadith,
          dailySunnah: sunnah,
          hadithViewedToday: repository.wasViewedToday(
            DailyContentKeys.categoryHadith,
          ),
          sunnahViewedToday: repository.wasViewedToday(
            DailyContentKeys.categorySunnah,
          ),
          isHadithFavorite: repository.isFavorite(hadith),
          isSunnahFavorite: repository.isFavorite(sunnah),
        ),
      );
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('LoadDailyContent Error', error: e, stackTrace: stack),
      );
      emit(state.copyWith(status: DailyContentStatus.failure));
    }
  }

  void _checkRefresh() {
    if (state.status == DailyContentStatus.success) {
      final today = _getTodayDateString();
      if (repository.getLastViewedDate(DailyContentKeys.categoryHadith) !=
          today) {
        unawaited(loadDailyContent());
      }
    }
  }

  Future<void> markHadithAsViewed() async {
    if (!repository.wasViewedToday(DailyContentKeys.categoryHadith)) {
      await repository.markViewed(
        DailyContentKeys.categoryHadith,
        _getTodayDateString(),
      );
      emit(state.copyWith(hadithViewedToday: true));
    }
  }

  Future<void> markSunnahAsViewed() async {
    if (!repository.wasViewedToday(DailyContentKeys.categorySunnah)) {
      await repository.markViewed(
        DailyContentKeys.categorySunnah,
        _getTodayDateString(),
      );
      emit(state.copyWith(sunnahViewedToday: true));
    }
  }

  Future<void> toggleHadithFavorite() async {
    if (state.dailyHadith == null) return;
    final isFav = await repository.toggleFavorite(state.dailyHadith!);
    emit(state.copyWith(isHadithFavorite: isFav));
  }

  Future<void> toggleSunnahFavorite() async {
    if (state.dailySunnah == null) return;
    final isFav = await repository.toggleFavorite(state.dailySunnah!);
    emit(state.copyWith(isSunnahFavorite: isFav));
  }

  String _getTodayDateString() {
    final state = appDateCubit.state;
    final now = state is AppDateLoaded ? state.date.gregorian : DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> refresh() => loadDailyContent();

  @override
  Future<void> close() async {
    await _dateSubscription?.cancel();
    return super.close();
  }
}
