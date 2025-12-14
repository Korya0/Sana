import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/features/home/data/models/daily_content_models.dart';
part 'daily_content_state.dart';

class DailyContentCubit extends Cubit<DailyContentState> {
  DailyContentCubit() : super(const DailyContentState());

  Future<void> loadDailyContent() async {
    try {
      emit(state.copyWith(status: DailyContentStatus.loading));

      // Load Hadiths
      final hadithJson = await rootBundle.loadString(
        AppConstants.dailyHadithsJsonPath,
      );
      final hadithsData = (json.decode(hadithJson) as List)
          .map((e) => DailyHadith.fromJson(e))
          .toList();

      // Load Verses
      final verseJson = await rootBundle.loadString(
        AppConstants.dailyVersesJsonPath,
      );
      final versesData = (json.decode(verseJson) as List)
          .map((e) => DailyVerseReference.fromJson(e))
          .toList();

      // Load Sunnahs
      final sunnahJson = await rootBundle.loadString(
        AppConstants.dailySunnahsJsonPath,
      );
      final sunnahsData = (json.decode(sunnahJson) as List)
          .map((e) => DailySunnah.fromJson(e))
          .toList();

      if (hadithsData.isEmpty || versesData.isEmpty || sunnahsData.isEmpty) {
        emit(state.copyWith(status: DailyContentStatus.failure));
        return;
      }

      // Select content based on the day of the year to ensure it changes daily
      final now = DateTime.now().toUtc();
      final diff = now.difference(DateTime(now.year, 1, 1));
      final dayOfYear = diff.inDays;

      final hadithIndex = dayOfYear % hadithsData.length;
      final verseIndex = dayOfYear % versesData.length;
      final sunnahIndex = dayOfYear % sunnahsData.length;

      emit(
        state.copyWith(
          status: DailyContentStatus.success,
          dailyHadith: hadithsData[hadithIndex],
          dailyVerse: versesData[verseIndex],
          dailySunnah: sunnahsData[sunnahIndex],
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: DailyContentStatus.failure));
    }
  }
}
