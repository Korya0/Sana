import 'package:freezed_annotation/freezed_annotation.dart';

part 'qibla_state.freezed.dart';

@freezed
class QiblaState with _$QiblaState {
  const factory QiblaState.initial() = QiblaInitial;
  const factory QiblaState.loading() = QiblaLoading;
  const factory QiblaState.loaded({
    required double qiblaDirection,
    required double distanceToKaaba,
  }) = QiblaLoaded;
  const factory QiblaState.error(String message) = QiblaError;
}
