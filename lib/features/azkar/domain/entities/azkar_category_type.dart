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

  // Creates type
  const AzkarCategoryType(this.key);

  final String key;

  static final Map<String, AzkarCategoryType> _byKey = {
    for (final type in values) type.key: type,
  };

  // Resolves key
  static AzkarCategoryType? fromKey(String key) => _byKey[key];
}
