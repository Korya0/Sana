import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_cubit.dart';

import 'package:sana/features/daily_content/data/datasource/daily_content_datasource.dart';
import 'package:sana/features/daily_content/data/repositories/daily_content_repository.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_state.dart';

class DailyContentCubit extends Cubit<DailyContentState> {
  DailyContentCubit(this.appDateCubit, this.repository)
    : super(const DailyContentState()) {
    // Load daily content in the background after the first frame
    unawaited(Future.microtask(loadDailyContent));
  }
  final AppDateCubit appDateCubit;
  final DailyContentRepository repository;

  Future<void> loadDailyContent() async {
    try {
      emit(state.copyWith(status: DailyContentStatus.loading));

      final contentData = await DailyContentDataSource.loadDailyContent();
      final hadithsData = contentData['dailyHadith'] ?? [];
      final sunnahsData = contentData['dailySunnah'] ?? [];

      if (hadithsData.isEmpty || sunnahsData.isEmpty) {
        emit(state.copyWith(status: DailyContentStatus.failure));
        return;
      }

      // Check if day has changed and update content if user viewed it yesterday
      await _checkAndUpdateForNewDay(hadithsData, sunnahsData);

      // Get current content based on shuffled indices
      final currentHadith = await repository.getCurrentHadith(hadithsData);
      final currentSunnah = await repository.getCurrentSunnah(sunnahsData);

      emit(
        state.copyWith(
          status: DailyContentStatus.success,
          dailyHadith: currentHadith,
          dailySunnah: currentSunnah,
          hadithViewedToday: repository.wasHadithViewedToday(),
          sunnahViewedToday: repository.wasSunnahViewedToday(),
          hadithProgress: repository.getHadithCurrentIndex(),
          sunnahProgress: repository.getSunnahCurrentIndex(),
          totalHadiths: hadithsData.length,
          totalSunnah: sunnahsData.length,
          isHadithFavorite: repository.isFavorite(currentHadith),
          isSunnahFavorite: repository.isFavorite(currentSunnah),
        ),
      );
    } on Exception catch (_) {
      emit(state.copyWith(status: DailyContentStatus.failure));
    }
  }

  /// Check if the day has changed and update content if needed
  Future<void> _checkAndUpdateForNewDay(
    List<dynamic> hadithsData,
    List<dynamic> sunnahsData,
  ) async {
    final currentDate = _getTodayDateString();

    // Check hadith
    final lastHadithViewDate = repository.getHadithLastViewedDate();
    if (lastHadithViewDate != null &&
        lastHadithViewDate != currentDate &&
        repository.wasHadithViewedToday()) {
      // Day changed and user viewed hadith yesterday, move to next
      await repository.advanceHadith(hadithsData.length);
    } else if (lastHadithViewDate == null ||
        lastHadithViewDate != currentDate) {
      // New day, reset viewed status
      await repository.resetHadithViewedStatus();
    }

    // Check sunnah
    final lastSunnahViewDate = repository.getSunnahLastViewedDate();
    if (lastSunnahViewDate != null &&
        lastSunnahViewDate != currentDate &&
        repository.wasSunnahViewedToday()) {
      // Day changed and user viewed sunnah yesterday, move to next
      await repository.advanceSunnah(sunnahsData.length);
    } else if (lastSunnahViewDate == null ||
        lastSunnahViewDate != currentDate) {
      // New day, reset viewed status
      await repository.resetSunnahViewedStatus();
    }
  }

  /// Mark hadith as viewed (called when user clicks to view it)
  Future<void> markHadithAsViewed() async {
    if (!repository.wasHadithViewedToday()) {
      await repository.markHadithAsViewedToday();
      final currentDate = _getTodayDateString();
      await repository.saveHadithLastViewedDate(currentDate);

      emit(state.copyWith(hadithViewedToday: true));
    }
  }

  /// Mark sunnah as viewed (called when user clicks to view it)
  Future<void> markSunnahAsViewed() async {
    if (!repository.wasSunnahViewedToday()) {
      await repository.markSunnahAsViewedToday();
      final currentDate = _getTodayDateString();
      await repository.saveSunnahLastViewedDate(currentDate);

      emit(state.copyWith(sunnahViewedToday: true));
    }
  }

  /// Toggle favorite for current hadith
  Future<void> toggleHadithFavorite() async {
    if (state.dailyHadith == null) return;
    final isFavorite = await repository.toggleFavorite(state.dailyHadith!);
    emit(state.copyWith(isHadithFavorite: isFavorite));
  }

  /// Toggle favorite for current sunnah
  Future<void> toggleSunnahFavorite() async {
    if (state.dailySunnah == null) return;
    final isFavorite = await repository.toggleFavorite(state.dailySunnah!);
    emit(state.copyWith(isSunnahFavorite: isFavorite));
  }

  /// Get today's date as a string (YYYY-MM-DD format)
  String _getTodayDateString() {
    final now = appDateCubit.currentDate;
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// Force refresh content (useful for testing)
  Future<void> refresh() async {
    await loadDailyContent();
  }
}
