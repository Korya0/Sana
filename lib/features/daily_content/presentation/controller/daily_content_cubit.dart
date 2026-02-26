import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_cubit.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_state.dart';

import 'package:sana/features/asma_ul_husna/data/repositories/asma_ul_husna_repository.dart';
import 'package:sana/features/daily_content/data/datasources/daily_content_datasource.dart';
import 'package:sana/features/daily_content/data/repositories/daily_content_repository.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_state.dart';

class DailyContentCubit extends Cubit<DailyContentState> {
  DailyContentCubit(this.appDateCubit, this.repository, this.asmaRepository)
    : super(const DailyContentState()) {
    unawaited(loadDailyContent());
    _dateSubscription = appDateCubit.stream.listen((_) => _checkRefresh());
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
      final asmaData = asmaResList.getOrElse(() => []);

      if (hadithsData.isEmpty || sunnahsData.isEmpty || asmaData.isEmpty) {
        emit(state.copyWith(status: DailyContentStatus.failure));
        return;
      }

      final today = _getTodayDateString();

      // Advancing Day Logic
      await repository.advanceCategoryIfNewDay(
        'hadith',
        hadithsData.length,
        today,
      );
      await repository.advanceCategoryIfNewDay(
        'sunnah',
        sunnahsData.length,
        today,
      );
      await repository.advanceCategoryIfNewDay('asma', asmaData.length, today);

      // Fetch Current Items
      final hadithRes = await repository.getDailyItem(
        category: 'hadith',
        all: hadithsData,
      );
      final sunnahRes = await repository.getDailyItem(
        category: 'sunnah',
        all: sunnahsData,
      );
      final asmaRes = await repository.getDailyItem(
        category: 'asma',
        all: asmaData,
      );

      if (hadithRes.isLeft() || sunnahRes.isLeft() || asmaRes.isLeft()) {
        emit(state.copyWith(status: DailyContentStatus.failure));
        return;
      }

      final hadith = hadithRes.getOrElse(() => throw Exception());
      final sunnah = sunnahRes.getOrElse(() => throw Exception());
      final asma = asmaRes.getOrElse(() => throw Exception());

      emit(
        state.copyWith(
          status: DailyContentStatus.success,
          dailyHadith: hadith,
          dailySunnah: sunnah,
          dailyAsma: asma,
          hadithViewedToday: repository.wasViewedToday('hadith'),
          sunnahViewedToday: repository.wasViewedToday('sunnah'),
          isHadithFavorite: repository.isFavorite(hadith),
          isSunnahFavorite: repository.isFavorite(sunnah),
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: DailyContentStatus.failure));
    }
  }

  void _checkRefresh() {
    if (state.status == DailyContentStatus.success) {
      final today = _getTodayDateString();
      if (repository.getLastViewedDate('hadith') != today) {
        unawaited(loadDailyContent());
      }
    }
  }

  Future<void> markHadithAsViewed() async {
    if (!repository.wasViewedToday('hadith')) {
      await repository.markViewed('hadith', _getTodayDateString());
      emit(state.copyWith(hadithViewedToday: true));
    }
  }

  Future<void> markSunnahAsViewed() async {
    if (!repository.wasViewedToday('sunnah')) {
      await repository.markViewed('sunnah', _getTodayDateString());
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
    final now = appDateCubit.state.date.gregorian;
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> refresh() => loadDailyContent();

  @override
  Future<void> close() async {
    await _dateSubscription?.cancel();
    return super.close();
  }
}
