abstract interface class IMidnightTimerService {
  /// A stream that emits an event exactly at midnight every day.
  Stream<void> get midnightStream;

  /// Starts the timer.
  void start();

  /// Stops the timer and cleans up resources.
  void stop();
}
