class AzkarConstants {
  const AzkarConstants._();

  // Box Names
  static const String metadataBoxName = 'azkar_metadata_box';
  static const String categoriesBoxName = 'azkar_categories_box';
  static const String azkarCategoryBoxPrefix = 'azkar_category_';

  // Keys
  static const String versionKey = 'azkar_version';
  static const String versionMapKey = 'version';

  // Model Keys
  static const String idKey = 'id';
  static const String titleKey = 'title';
  static const String textKey = 'text';
  static const String countKey = 'count';
  static const String referenceKey = 'reference';
  static const String descriptionKey = 'description';
  static const String fontSizeModelKey = 'fontSize';
  static const String keepScreenAwakeModelKey = 'keepScreenAwake';
  static const String screenReaderEnabledModelKey = 'screenReaderEnabled';

  // Reading Settings Keys
  static const String keyFontSize = 'azkar_font_size';
  static const String keyKeepScreenAwake = 'azkar_keep_screen_awake';
  static const String keyScreenReaderEnabled = 'azkar_screen_reader_enabled';

  // Reading Settings Configurations
  static const double defaultFontSize = 20;
  static const double minFontSize = 12;
  static const double maxFontSize = 28;
}
