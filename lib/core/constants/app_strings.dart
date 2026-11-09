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

  // Azkar & Tasbeeh
  static const String azkarHeader = 'الأذكار';
  static const String azkarTasbeehHeader = 'الأذكار والتسابيح';
  static const String azkarCategoriesSectionTitle = 'أقسام الأذكار';
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
  static const String loading = 'جارٍ التحميل...';
  static const String back = 'رجوع';

  // Reminders
  static const String remindersTitle = 'التذكيرات';
  static const String remindersEmpty = 'لا توجد تذكيرات حالياً';

  // Custom Azkar
  static const String customZikr = 'ذكر مخصص';
  static const String customZikrWithPlus = 'ذكر مخصص +';
  static const String customAzkar = 'الأذكار المخصصة';
  static const String viewCustomAzkar = 'عرض الأذكار المخصصة';
  static const String noCustomAzkarYet = 'لا توجد أذكار مخصصة بعد';
  static const String createCustomZikr = 'إنشاء ذكر مخصص';
  static const String editCustomZikr = 'تعديل ذكر مخصص';
  static const String customZikrName = 'اسم الذكر';
  static const String customZikrNameHint = 'أدخل اسم الذكر (مثال: أورادي اليومية)';
  static const String customZikrNameRequired = 'اسم الذكر مطلوب';
  static const String customZikrNameArabicOnly =
      'يجب أن يكون اسم الذكر باللغة العربية فقط';
  static const String addZikr = 'إضافة ذكر';
  static const String editZikr = 'تعديل الذكر';
  static const String deleteZikr = 'حذف الذكر';
  static const String deleteCustomZikrDialogTitle = 'حذف الذكر المخصص';
  static const String deleteCustomZikrDialogMessage =
      'هل تريد حذف هذا الذكر المخصص نهائياً؟';
  static const String deleteItemDialogTitle = 'حذف الذكر';
  static const String deleteItemDialogMessage =
      'هل تريد حذف هذا الذكر من القائمة؟';
  static const String delete = 'حذف';
  static const String cancel = 'إلغاء';
  static const String save = 'حفظ';
  static const String zikrText = 'نص الذكر';
  static const String zikrTextHint = 'اكتب نص الذكر هنا';
  static const String zikrTextRequired = 'نص الذكر مطلوب';
  static const String zikrTextArabicOnly =
      'يجب أن يكون نص الذكر باللغة العربية فقط';
  static const String targetCount = 'العدد المستهدف';
  static const String targetCountHint = 'مثال: 33';
  static const String targetCountRequired = 'العدد المستهدف مطلوب';
  static const String targetCountDigitsOnly =
      'العدد المستهدف يجب أن يتكون من أرقام فقط';
  static const String targetCountGreaterThanZero =
      'العدد يجب أن يكون أكبر من صفر';
  static const String mustAddAtLeastOneZikr = 'يجب إضافة ذكر واحد على الأقل';
  static const String customZikrSavedSuccess = 'تم حفظ الذكر المخصص بنجاح';
  static const String customZikrDeletedSuccess = 'تم حذف الذكر المخصص بنجاح';
  static const String customZikrActionsTitle = 'خيارات الذكر المخصص';
  static const String zikrOptionsTitle = 'خيارات الذكر';
  static const String resetCounter = 'تصفير العداد';
  static const String counterResetSuccess = 'تم تصفير العداد بنجاح';
  static const String editTargetCount = 'تعديل الهدف';
  static const String targetCountUpdatedSuccess = 'تم تعديل هدف الذكر بنجاح';
  static const String zikrAddedSuccess = 'تمت إضافة الذكر بنجاح';
  static const String zikrDeletedSuccess = 'تم حذف الذكر بنجاح';
  static const String resetCategoryToDefault = 'إعادة تعيين للأصل';
  static const String resetCategoryDialogTitle = 'إعادة تعيين الأذكار';
  static const String resetCategoryDialogMessage =
      'هل تريد إعادة تعيين هذا القسم وحذف التعديلات والعودة للأذكار الأصلية؟';
  static const String resetCategorySuccess =
      'تمت إعادة تعيين الأذكار للأصل بنجاح';
  static String azkarCountLabel(int count) => 'عدد الأذكار: $count';

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
