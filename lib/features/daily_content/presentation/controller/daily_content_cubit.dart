import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_cubit.dart';

import 'package:sana/features/asma_ul_husna/data/datasources/asma_ul_husna_local_data_source.dart';
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
      final asmaData = await AsmaUlHusnaLocalDataSource.getNames();
      final hadithsData = contentData['dailyHadith'] ?? [];
      final sunnahsData = contentData['dailySunnah'] ?? [];

      if (hadithsData.isEmpty || sunnahsData.isEmpty || asmaData.isEmpty) {
        emit(state.copyWith(status: DailyContentStatus.failure));
        return;
      }

      // Check if day has changed and update content if user viewed it yesterday
      await _checkAndUpdateForNewDay(hadithsData, sunnahsData, asmaData);

      // Get current content based on shuffled indices
      final currentHadithResult = await repository.getCurrentHadith(
        hadithsData,
      );
      final currentSunnahResult = await repository.getCurrentSunnah(
        sunnahsData,
      );
      final currentAsmaResult = await repository.getCurrentAsma(asmaData);

      currentHadithResult.fold(
        (failure) => emit(state.copyWith(status: DailyContentStatus.failure)),
        (currentHadith) => currentSunnahResult.fold(
          (failure) => emit(state.copyWith(status: DailyContentStatus.failure)),
          (currentSunnah) => currentAsmaResult.fold(
            (failure) =>
                emit(state.copyWith(status: DailyContentStatus.failure)),
            (currentAsma) => emit(
              state.copyWith(
                status: DailyContentStatus.success,
                dailyHadith: currentHadith,
                dailySunnah: currentSunnah,
                dailyAsma: currentAsma,
                hadithViewedToday: repository.wasHadithViewedToday(),
                sunnahViewedToday: repository.wasSunnahViewedToday(),
                hadithProgress: repository.getHadithCurrentIndex(),
                sunnahProgress: repository.getSunnahCurrentIndex(),
                asmaProgress: repository.getAsmaCurrentIndex(),
                totalHadiths: hadithsData.length,
                totalSunnah: sunnahsData.length,
                totalAsma: asmaData.length,
                isHadithFavorite: repository.isFavorite(currentHadith),
                isSunnahFavorite: repository.isFavorite(currentSunnah),
                isAsmaFavorite: repository.isAsmaFavorite(currentAsma),
              ),
            ),
          ),
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: DailyContentStatus.failure));
    }
  }

  /// Check if the day has changed and update content for the new day
  Future<void> _checkAndUpdateForNewDay(
    List<dynamic> hadithsData,
    List<dynamic> sunnahsData,
    List<dynamic> asmaData,
  ) async {
    final currentDate = _getTodayDateString();

    // Check Hadith: Advance if day changed
    final lastHadithViewDate = repository.getHadithLastViewedDate();
    if (lastHadithViewDate == null || lastHadithViewDate != currentDate) {
      await repository.advanceHadith(hadithsData.length);
      await repository.saveHadithLastViewedDate(currentDate);
      await repository.resetHadithViewedStatus();
    }

    // Check Sunnah: Advance if day changed
    final lastSunnahViewDate = repository.getSunnahLastViewedDate();
    if (lastSunnahViewDate == null || lastSunnahViewDate != currentDate) {
      await repository.advanceSunnah(sunnahsData.length);
      await repository.saveSunnahLastViewedDate(currentDate);
      await repository.resetSunnahViewedStatus();
    }

    // Check Asma: Advance if day changed
    final lastAsmaViewDate = repository.getAsmaLastViewedDate();
    if (lastAsmaViewDate == null || lastAsmaViewDate != currentDate) {
      await repository.advanceAsma(asmaData.length);
      await repository.saveAsmaLastViewedDate(currentDate);
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

  /// Toggle favorite for current Asma
  Future<void> toggleAsmaFavorite() async {
    if (state.dailyAsma == null) return;
    final isFavorite = await repository.toggleAsmaFavorite(state.dailyAsma!);
    emit(state.copyWith(isAsmaFavorite: isFavorite));
  }

  /// Get today's date as a string (YYYY-MM-DD format)
  String _getTodayDateString() {
    final now = appDateCubit.state.date.gregorian;
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// Force refresh content (useful for testing)
  Future<void> refresh() async {
    await loadDailyContent();
  }
}
