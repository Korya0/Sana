class AzkarKeys {
  const AzkarKeys._();
  static const String id = 'id';
  static const String array = 'array';
  static const String category = 'category';
  static const String subText = 'subText';
  static const String text = 'text';
  static const String count = 'count';

  // Category IDs
  static const String catAfterPrayer = '1';
  static const String catMorning = '2';
  static const String catEvening = '3';
  static const String catSleep = '4';
  static const String catWakeup = '5';
  static const String catWudu = '6';
  static const String catMosque = '7';
  static const String catHome = '8';
  static const String catAthan = '9';
  static const String catToilet = '10';
  static const String catFood = '11';
  static const String catDress = '12';
  static const String catFasting = '13';
  static const String catSadness = '14';
  static const String catPrayer = '15';
  static const String catTasbih = '16';
  static const String catMarriage = '17';
  static const String catChildren = '18';
  static const String catSick = '19';
  static const String catAllah = '20';
  static const String catAnger = '21';
  static const String catTravel = '22';
  static const String catDua = '23';

  /// The IDs of categories that should appear at the top of the list
  static const Set<String> priorityCategoryIds = {
    catMorning,
    catEvening,
    catWakeup,
    catSleep,
    catAfterPrayer,
  };
}
