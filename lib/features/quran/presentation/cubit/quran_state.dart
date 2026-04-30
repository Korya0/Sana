import 'package:flutter/foundation.dart';

@immutable
sealed class QuranState {
  const QuranState();
}

final class QuranInitial extends QuranState {
  const QuranInitial();
}

final class QuranLoading extends QuranState {
  const QuranLoading();
}

final class QuranSuccess extends QuranState {
  const QuranSuccess();
}

final class QuranError extends QuranState {
  const QuranError(this.message);
  final String message;
}
