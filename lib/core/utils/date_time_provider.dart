abstract interface class DateTimeProvider {
  DateTime get now;
}

class DateTimeProviderImpl implements DateTimeProvider {
  @override
  DateTime get now => DateTime.now();
}
