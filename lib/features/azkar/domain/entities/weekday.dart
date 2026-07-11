enum WeekDay {
  monday(1),
  tuesday(2),
  wednesday(3),
  thursday(4),
  friday(5),
  saturday(6),
  sunday(7);

  const WeekDay(this.value);

  final int value;

  static WeekDay fromValue(int value) {
    return WeekDay.values.firstWhere(
      (day) => day.value == value,
      orElse: () => WeekDay.monday,
    );
  }
}
