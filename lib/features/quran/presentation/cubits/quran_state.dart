import 'package:flutter/foundation.dart';

@immutable
sealed class QuranState {
  const QuranState();

  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  int get hashCode => runtimeType.hashCode;
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuranError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
