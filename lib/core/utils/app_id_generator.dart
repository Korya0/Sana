class AppIdGenerator {
  AppIdGenerator({DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;
  int _lastMicros = 0;

  String next({required String prefix, Set<String> existingIds = const {}}) {
    var micros = _clock().microsecondsSinceEpoch;
    if (micros <= _lastMicros) micros = _lastMicros + 1;
    _lastMicros = micros;

    var id = '$prefix$micros';
    var suffix = 0;
    while (existingIds.contains(id)) {
      suffix++;
      id = '$prefix${micros}_$suffix';
    }
    return id;
  }

  // Integer ids keep the same guarantees as [next] for zikr items stored as
  // numbers: increasing values and no collision with an id already in the list.
  int nextInt({Set<int> existingIds = const {}}) {
    var micros = _clock().microsecondsSinceEpoch;
    if (micros <= _lastMicros) micros = _lastMicros + 1;
    while (existingIds.contains(micros)) {
      micros++;
    }
    _lastMicros = micros;
    return micros;
  }
}
