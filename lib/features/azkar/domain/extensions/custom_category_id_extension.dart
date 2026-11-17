import 'package:sana/features/azkar/data/constants/azkar_constants.dart';

// Checks a custom category id
extension CustomCategoryIdExtension on String {
  bool get isCustomCategoryId => startsWith(customCategoryIdPrefix);
}
