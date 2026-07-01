abstract class IDateTimeProvider {
  DateTime get now;
}

class DateTimeProviderImpl implements IDateTimeProvider {
  @override
  DateTime get now => DateTime.now();
}
