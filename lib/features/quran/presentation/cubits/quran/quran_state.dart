sealed class QuranState {
  const QuranState();
}

final class QuranInitial extends QuranState {
  const QuranInitial();
}

final class QuranLoading extends QuranState {
  const QuranLoading();
}

final class QuranReady extends QuranState {
  const QuranReady();
}

final class QuranFailed extends QuranState {
  const QuranFailed(this.message);

  final String message;
}
