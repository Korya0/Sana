/// Stable identity for every azkar category.
///
/// The [key] is shared with `assets/json/azkar/categories.json` and is also the
/// asset file name (`morning` -> `assets/json/azkar/morning.json`).
///
/// Never use a numeric id for a category: the key survives data reordering and
/// makes the icon mapping exhaustive at compile time.
enum AzkarCategoryType {
  morning('morning'),
  evening('evening'),
  wakingUp('waking_up'),
  sleep('sleep'),
  afterPrayer('after_prayer'),
  ablution('ablution'),
  adhan('adhan'),
  home('home'),
  mosque('mosque'),
  restroom('restroom'),
  foodDrink('food_drink'),
  clothes('clothes'),
  fasting('fasting'),
  distressWorry('distress_worry'),
  repentance('repentance_seeking_forgiveness'),
  praisingAllah('praising_allah'),
  marriage('marriage'),
  children('children'),
  sickness('sickness'),
  death('death'),
  funeral('funeral'),
  travel('travel'),
  openingSupplication('opening_supplication');

  const AzkarCategoryType(this.key);

  final String key;

  static final Map<String, AzkarCategoryType> _byKey = {
    for (final type in values) type.key: type,
  };

  /// Returns `null` for a key added to JSON before the app knows it.
  static AzkarCategoryType? fromKey(String key) => _byKey[key];
}
