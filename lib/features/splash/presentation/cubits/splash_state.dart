import 'package:flutter/foundation.dart';

@immutable
sealed class SplashState {
  const SplashState();

  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  int get hashCode => runtimeType.hashCode;
}

final class SplashInitial extends SplashState {
  const SplashInitial();
}

final class SplashLoading extends SplashState {
  const SplashLoading();
}

final class SplashFinished extends SplashState {
  const SplashFinished();
}
