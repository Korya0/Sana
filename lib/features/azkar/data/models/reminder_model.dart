class ReminderModel {
  const ReminderModel({
    required this.id,
    required this.azkarId,
    required this.time,
    required this.repeatType,
    required this.days,
    required this.isEnabled,
    required this.timezone,
    required this.template,
  });

  final String id;
  final String azkarId;
  final String time;
  final String repeatType;
  final List<int> days;
  final bool isEnabled;
  final String timezone;
  final String template;
}
