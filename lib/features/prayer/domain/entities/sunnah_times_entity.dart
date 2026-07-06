import 'package:flutter/foundation.dart';

@immutable
class SunnahTimesEntity {
  const SunnahTimesEntity({
    required this.middleOfTheNight,
    required this.lastThirdOfTheNight,
  });

  final DateTime middleOfTheNight;
  final DateTime lastThirdOfTheNight;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SunnahTimesEntity) return false;
    return middleOfTheNight == other.middleOfTheNight &&
        lastThirdOfTheNight == other.lastThirdOfTheNight;
  }

  @override
  int get hashCode => middleOfTheNight.hashCode ^ lastThirdOfTheNight.hashCode;
}
