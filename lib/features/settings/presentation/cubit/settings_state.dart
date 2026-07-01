import 'package:flutter/foundation.dart';

@immutable
class SettingsState {
  const SettingsState({
    required this.isRatingSupported,
    required this.shareText,
  });

  final bool isRatingSupported;
  final String shareText;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsState &&
          runtimeType == other.runtimeType &&
          isRatingSupported == other.isRatingSupported &&
          shareText == other.shareText;

  @override
  int get hashCode => isRatingSupported.hashCode ^ shareText.hashCode;
}
