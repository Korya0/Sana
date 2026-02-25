import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_cubit.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_state.dart';

import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';
import 'package:sana/features/asma_ul_husna/data/repositories/asma_ul_husna_repository.dart';
import 'package:sana/features/daily_content/data/datasource/daily_content_datasource.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';
import 'package:sana/features/daily_content/data/repositories/daily_content_repository.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_state.dart';

class DailyContentCubit extends Cubit<DailyContentState> {
  DailyContentCubit(this.appDateCubit, this.repository, this.asmaRepository)
    : super(const DailyContentState()) {
    // Initial load
    unawaited(loadDailyContent());
    // Listen to date changes for automatic midnight update
    _dateSubscription = appDateCubit.stream.listen((dateState) {
      if (state.status == DailyContentStatus.success) {
        _checkAndRefreshOnNewDay();
      }
    });
  }
  final AppDateCubit appDateCubit;
  final DailyContentRepository repository;
  final IAsmaUlHusnaRepository asmaRepository;
  StreamSubscription<AppDateState>? _dateSubscription;

  Future<void> loadDailyContent() async {
    try {
      if (state.status != DailyContentStatus.success) {
        emit(state.copyWith(status: DailyContentStatus.loading));
      }

      final contentData = await DailyContentDataSource.loadDailyContent();
      final asmaResList = await asmaRepository.getNames();
      final hadithsData = contentData['dailyHadith'] ?? [];
      final sunnahsData = contentData['dailySunnah'] ?? [];

      if (hadithsData.isEmpty || sunnahsData.isEmpty || asmaResList.isLeft()) {
        emit(state.copyWith(status: DailyContentStatus.failure));
        return;
      }

      final asmaData = asmaResList.getOrElse(() => []);

      // Check if day has changed and update content
      await _checkAndUpdateForNewDay(hadithsData, sunnahsData, asmaData);

      // Get current content based on shuffled indices
      final hadithRes = await repository.getCurrentHadith(hadithsData);
      final sunnahRes = await repository.getCurrentSunnah(sunnahsData);
      final asmaRes = await asmaRepository.getCurrentDailyAsma(asmaData);

      // We need all of them to be successful for the "success" state
      if (hadithRes.isLeft() || sunnahRes.isLeft() || asmaRes.isLeft()) {
        emit(state.copyWith(status: DailyContentStatus.failure));
        return;
      }

      final currentHadith = hadithRes.getOrElse(() => throw Exception());
      final currentSunnah = sunnahRes.getOrElse(() => throw Exception());
      final currentAsma = asmaRes.getOrElse(() => throw Exception());

      emit(
        state.copyWith(
          status: DailyContentStatus.success,
          dailyHadith: currentHadith,
          dailySunnah: currentSunnah,
          dailyAsma: currentAsma,
          hadithViewedToday: repository.wasHadithViewedToday(),
          sunnahViewedToday: repository.wasSunnahViewedToday(),
          hadithProgress: repository.getHadithCurrentIndex(),
          sunnahProgress: repository.getSunnahCurrentIndex(),
          asmaProgress: asmaRepository.getAsmaCurrentIndex(),
          totalHadiths: hadithsData.length,
          totalSunnah: sunnahsData.length,
          totalAsma: asmaData.length,
          isHadithFavorite: repository.isFavorite(currentHadith),
          isSunnahFavorite: repository.isFavorite(currentSunnah),
          isAsmaFavorite: asmaRepository.isAsmaFavorite(currentAsma),
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: DailyContentStatus.failure));
    }
  }

  /// Triggered by date changes from AppDateCubit
  void _checkAndRefreshOnNewDay() {
    final currentDate = _getTodayDateString();
    final lastHadithDate = repository.getHadithLastViewedDate();

    // If the day changed, refresh the content
    if (lastHadithDate != null && lastHadithDate != currentDate) {
      unawaited(loadDailyContent());
    }
  }

  /// Check if the day has changed and update content for the new day
  Future<void> _checkAndUpdateForNewDay(
    List<DailyContentModel> hadithsData,
    List<DailyContentModel> sunnahsData,
    List<AsmaulHusnaModel> asmaData,
  ) async {
    final currentDate = _getTodayDateString();

    // Hadith
    final lastHadithViewDate = repository.getHadithLastViewedDate();
    if (lastHadithViewDate == null || lastHadithViewDate != currentDate) {
      await repository.advanceHadith(hadithsData.length);
      await repository.saveHadithLastViewedDate(currentDate);
      await repository.resetHadithViewedStatus();
    }

    // Sunnah
    final lastSunnahViewDate = repository.getSunnahLastViewedDate();
    if (lastSunnahViewDate == null || lastSunnahViewDate != currentDate) {
      await repository.advanceSunnah(sunnahsData.length);
      await repository.saveSunnahLastViewedDate(currentDate);
      await repository.resetSunnahViewedStatus();
    }

    // Asma
    final lastAsmaViewDate = asmaRepository.getAsmaLastViewedDate();
    if (lastAsmaViewDate == null || lastAsmaViewDate != currentDate) {
      await asmaRepository.advanceAsma(asmaData.length);
      await asmaRepository.saveAsmaLastViewedDate(currentDate);
    }
  }

  // ... rest of the methods remain same but I'll include them for file completeness in this contiguous block ...
  // Wait, I should use replace_file_content for the whole class effectively or at least the logic parts.
  // I will continue from line 111 in the original file.

  /// Mark hadith as viewed
  Future<void> markHadithAsViewed() async {
    if (!repository.wasHadithViewedToday()) {
      await repository.markHadithAsViewedToday();
      final currentDate = _getTodayDateString();
      await repository.saveHadithLastViewedDate(currentDate);
      emit(state.copyWith(hadithViewedToday: true));
    }
  }

  /// Mark sunnah as viewed
  Future<void> markSunnahAsViewed() async {
    if (!repository.wasSunnahViewedToday()) {
      await repository.markSunnahAsViewedToday();
      final currentDate = _getTodayDateString();
      await repository.saveSunnahLastViewedDate(currentDate);
      emit(state.copyWith(sunnahViewedToday: true));
    }
  }

  Future<void> toggleHadithFavorite() async {
    if (state.dailyHadith == null) return;
    final isFavorite = await repository.toggleFavorite(state.dailyHadith!);
    emit(state.copyWith(isHadithFavorite: isFavorite));
  }

  Future<void> toggleSunnahFavorite() async {
    if (state.dailySunnah == null) return;
    final isFavorite = await repository.toggleFavorite(state.dailySunnah!);
    emit(state.copyWith(isSunnahFavorite: isFavorite));
  }

  Future<void> toggleAsmaFavorite() async {
    if (state.dailyAsma == null) return;
    final isFavorite = await asmaRepository.toggleAsmaFavorite(
      state.dailyAsma!,
    );
    emit(state.copyWith(isAsmaFavorite: isFavorite));
  }

  String _getTodayDateString() {
    final now = appDateCubit.state.date.gregorian;
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> refresh() async {
    await loadDailyContent();
  }

  @override
  Future<void> close() async {
    await _dateSubscription?.cancel();
    return super.close();
  }
}
