import 'package:adhan/adhan.dart';
import 'package:equatable/equatable.dart';

/// UI-ready model containing all display data for a single prayer
/// This model is prepared by the Cubit and consumed directly by the UI
class PrayerDisplayModel extends Equatable {
  const PrayerDisplayModel({
    required this.type,
    required this.time,
    required this.displayName,
    required this.isCurrent,
    required this.isNext,
    this.sunnahTimes,
    this.hadith,
    this.additionalData,
  });

  final Prayer type;
  final DateTime time;
  final String displayName;
  final bool isCurrent;
  final bool isNext;
  final SunnahTimes? sunnahTimes;

  // Future extensions
  final String? hadith;
  final Map<String, dynamic>? additionalData;

  @override
  List<Object?> get props => [
    type,
    time,
    displayName,
    isCurrent,
    isNext,
    sunnahTimes,
    hadith,
    additionalData,
  ];

  PrayerDisplayModel copyWith({
    Prayer? type,
    DateTime? time,
    String? displayName,
    bool? isCurrent,
    bool? isNext,
    SunnahTimes? sunnahTimes,
    String? hadith,
    Map<String, dynamic>? additionalData,
  }) {
    return PrayerDisplayModel(
      type: type ?? this.type,
      time: time ?? this.time,
      displayName: displayName ?? this.displayName,
      isCurrent: isCurrent ?? this.isCurrent,
      isNext: isNext ?? this.isNext,
      sunnahTimes: sunnahTimes ?? this.sunnahTimes,
      hadith: hadith ?? this.hadith,
      additionalData: additionalData ?? this.additionalData,
    );
  }
}
