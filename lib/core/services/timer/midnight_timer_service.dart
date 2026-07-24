import 'dart:async';

abstract interface class MidnightTimerService {
  Stream<void> get midnightStream;
  void start();
  void stop();
}

class MidnightTimerServiceImpl implements MidnightTimerService {
  Timer? _timer;
  final _midnightController = StreamController<void>.broadcast();

  @override
  Stream<void> get midnightStream => _midnightController.stream;

  @override
  void start() {
    _scheduleNextMidnight();
  }

  void _scheduleNextMidnight() {
    _timer?.cancel();

    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final duration = nextMidnight.difference(now);

    _timer = Timer(duration + const Duration(seconds: 1), () {
      if (!_midnightController.isClosed) {
        _midnightController.add(null);
      }
      _scheduleNextMidnight();
    });
  }

  @override
  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
