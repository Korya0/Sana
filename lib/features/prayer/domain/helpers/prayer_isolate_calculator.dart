import 'package:adhan/adhan.dart';
import 'package:sana/features/prayer/domain/helpers/prayer_name_provider.dart';

import 'package:sana/features/prayer/domain/models/prayer_calculation_params.dart';
import 'package:sana/features/prayer/domain/models/prayer_display_model.dart';

/// Top-level function for Isolate
/// Must be outside any class or a static method.
List<PrayerDisplayModel> calculatePrayerTimesInIsolate(
  PrayerCalculationParams params,
) {
  // Calculate prayer times
  final adhanParams = params.settings.method.getParameters()
    ..madhab = params.settings.madhab
    ..adjustments = params.settings.adjustments;

  final dateComponents = DateComponents.from(params.dateTime);
  final prayerTimes = PrayerTimes(params.coords, dateComponents, adhanParams);

  final sunnahTimes = SunnahTimes(prayerTimes);

  // List of prayers to display
  final prayerTypes = [
    Prayer.fajr,
    Prayer.dhuhr,
    Prayer.asr,
    Prayer.maghrib,
    Prayer.isha,
  ];

  // Determine current and next prayer
  Prayer? currentPrayerType;
  Prayer? nextPrayerType;
  DateTime? nextPrayerTime;

  for (int i = 0; i < prayerTypes.length; i++) {
    final prayer = prayerTypes[i];
    final time = _getPrayerTimeHelper(prayerTimes, prayer);

    if (params.dateTime.isBefore(time)) {
      nextPrayerType = prayer;
      nextPrayerTime = time;
      if (i > 0) {
        currentPrayerType = prayerTypes[i - 1];
      }
      break;
    }
  }

  // If no next prayer found today, next is tomorrow's Fajr
  if (nextPrayerType == null) {
    currentPrayerType = Prayer.isha;
    nextPrayerType = Prayer.fajr;

    final tomorrow = params.dateTime.add(const Duration(days: 1));
    final tomorrowComponents = DateComponents.from(tomorrow);
    final tomorrowPrayerTimes = PrayerTimes(
      params.coords,
      tomorrowComponents,
      adhanParams,
    );
    nextPrayerTime = tomorrowPrayerTimes.fajr;
  }

  // Build display models
  final displayModels = prayerTypes.map((prayer) {
    final time = _getPrayerTimeHelper(prayerTimes, prayer);
    final displayName = PrayerNameProvider.getName(prayer, params.locale);

    final isThisNext =
        prayer == nextPrayerType &&
        nextPrayerTime != null &&
        time.isAtSameMomentAs(nextPrayerTime);

    return PrayerDisplayModel(
      type: prayer,
      time: time,
      displayName: displayName,
      isCurrent: prayer == currentPrayerType,
      isNext: isThisNext,
      sunnahTimes: sunnahTimes,
    );
  }).toList();

  // Handle tomorrow's Fajr if applicable
  if (nextPrayerType == Prayer.fajr &&
      nextPrayerTime != null &&
      nextPrayerTime.isAfter(prayerTimes.isha)) {
    final tomorrowFajrName = PrayerNameProvider.getName(
      Prayer.fajr,
      params.locale,
    );

    final fajrIndex = displayModels.indexWhere((p) => p.type == Prayer.fajr);
    if (fajrIndex != -1) {
      displayModels[fajrIndex] = PrayerDisplayModel(
        type: Prayer.fajr,
        time: nextPrayerTime,
        displayName: tomorrowFajrName,
        isCurrent: false,
        isNext: true,
        sunnahTimes: sunnahTimes,
      );
    }
  }

  return displayModels;
}

/// Helper function to match Prayer enum to DateTime
DateTime _getPrayerTimeHelper(PrayerTimes prayerTimes, Prayer prayer) {
  switch (prayer) {
    case Prayer.fajr:
      return prayerTimes.fajr;
    case Prayer.sunrise:
      return prayerTimes.sunrise;
    case Prayer.dhuhr:
      return prayerTimes.dhuhr;
    case Prayer.asr:
      return prayerTimes.asr;
    case Prayer.maghrib:
      return prayerTimes.maghrib;
    case Prayer.isha:
      return prayerTimes.isha;
    case Prayer.none:
      return DateTime.now();
  }
}
