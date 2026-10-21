class AppStrings {
  const AppStrings._();

  // App
  static const String appName = 'سَـنَـا';
  static const String pageNotFound = 'تعذّر فتح الصفحة';

  // Navigation
  static const String homeTab = 'الرئيسية';
  static const String adhkarTab = 'الأذكار';
  static const String quranTab = 'القرآن';
  static const String settingsTab = 'الإعدادات';

  // Azkar
  static const String azkarHeader = 'الأذكار';
  static const String azkarTitlePrefix = 'أذكار ';
  static const String azkarLoadError = 'تعذّر تحميل الأذكار';
  static const String azkarEmpty = 'لا توجد أذكار في هذا القسم';
  static const String azkarCategoriesEmpty = 'لا توجد أقسام';
  static const String azkarExitDialogTitle = 'تنبيه';
  static const String azkarExitDialogMessage =
      'هل تريد الخروج؟ ستفقد تقدمك الحالي في الأذكار';
  static const String azkarExitDialogConfirmText = 'خروج';
  static const String azkarExitDialogCancelText = 'البقاء';
  static const String azkarCompletedMessage =
      'لقد أتممت جميع الأذكار بنجاح، جعلها الله في ميزان حسناتك';
  static const String azkarShareCardDepartment = 'من الأذكار';
  static const String sharingError = 'تعذّرت المشاركة';
  static const String copiedToClipboard = 'تم النسخ بنجاح';
  static const String copyError = 'تعذّر النسخ';
  static const String loading = 'جارٍ التحميل...';
  static const String back = 'رجوع';

  // Reading settings
  static const String readingSettingsTitle = 'إعدادات القراءة';
  static const String fontSizeTitle = 'حجم الخط';
  static const String fontSmall = 'صغير';
  static const String fontLarge = 'كبير';
  static const String saveSettingsError = 'تعذّر حفظ إعدادات القراءة';
  static const String loadSettingsError = 'تعذّر تحميل إعدادات القراءة';
  static const String fontSizePreviewText =
      'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ.';

  // Semantics
  static const String shareAndCopyOptions = 'خيارات مشاركة ونسخ الذكر';
  static const String remainingCounterLabel = 'العدد المتبقي للتكرار';
  static const String completed = 'تم الانتهاء';
  static const String completedRepetitions = 'تم الانتهاء من التكرار';
  static const String tapToCount = 'انقر للعد واحتساب التكرار';
  static String zikrLabel(String text) => 'ذكر: $text';
  static String remainingCountOfTotal(int remaining, int total) =>
      'متبقي $remaining من $total';

  // States
  static const String errorWidgetTitle = 'عذراً، حدث خطأ';
  static const String tryAgain = 'حاول مرة أخرى';
  static const String emptyTitle = 'لا يوجد محتوى';
}
