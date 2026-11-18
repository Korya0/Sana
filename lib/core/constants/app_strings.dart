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
  static const String azkarLoadError = 'تعذّر تحميل الأذكار';
  static const String azkarSaveError = 'تعذّر حفظ الأذكار';
  static const String azkarDeleteError = 'تعذّر حذف الأذكار';
  static const String azkarEmpty = 'لا توجد أذكار في هذا القسم';
  static const String azkarCategoriesEmpty = 'لا توجد أقسام';
  static const String azkarExitDialogTitle = 'تنبيه';
  static const String azkarExitDialogMessage =
      'هل تريد الخروج؟ ستفقد تقدمك الحالي في الأذكار';
  static const String azkarExitDialogConfirmText = 'خروج';
  static const String azkarExitDialogCancelText = 'البقاء';
  static const String azkarCompletedMessage =
      'لقد أتممت جميع الأذكار بنجاح، جعلها الله في ميزان حسناتك';
  static const String azkarHomeOptions = 'خيارات';
  static const String loading = 'جارٍ التحميل...';
  static const String back = 'رجوع';

  // Azkar sharing
  static const String copyZikrText = 'نسخ النص';
  static const String zikrCopyError = 'تعذّر نسخ الذكر';
  static const String zikrVirtue = 'فضل الذكر';
  static const String zikrVirtueHint = 'اكتب فضل الذكر (اختياري)';
  static String zikrCopyText({
    required String categoryTitle,
    required String zikrText,
    String? description,
  }) {
    final trimmedDescription = description?.trim();
    final sections = [
      '« $categoryTitle »',
      '« $zikrText »',
      if (trimmedDescription != null && trimmedDescription.isNotEmpty)
        '« $zikrVirtue: $trimmedDescription »',
    ];
    return sections.join('\n\n');
  }

  // Custom Azkar
  static const String customZikr = 'ذكر مخصص';
  static const String customAzkar = 'الأذكار المخصصة';
  static const String noCustomAzkarYet = 'لا توجد أذكار مخصصة بعد';
  static const String addCustomAzkar = 'إنشاء أذكار';
  static const String manageCustomAzkar = 'إدارة الأذكار';
  static const String editAzkar = 'تعديل الأذكار';
  static const String azkarOptions = 'خيارات الأذكار';
  static const String restoreOriginal = 'استعادة الأصل';
  static const String unsavedChangesDialogTitle = 'تغييرات غير محفوظة';
  static const String unsavedChangesDialogMessage =
      'هل تريد الخروج دون حفظ التعديلات؟';
  static const String unsavedChangesConfirm = 'خروج';
  static const String unsavedChangesCancel = 'البقاء';
  static const String azkarName = 'اسم قسم الأذكار';
  static const String azkarNameHint = 'مثال: أذكار الصباح';
  static const String azkarNameRequired = 'اسم القسم مطلوب';
  static const String addZikr = 'إضافة ذكر';
  static const String editZikr = 'تعديل الذكر';
  static const String editCustomZikr = 'تعديل ذكر مخصص';
  static const String deleteZikr = 'حذف الذكر';
  static const String deleteCustomZikrDialogTitle = 'حذف الذكر المخصص';
  static const String deleteCustomAzkarDialogTitle = 'حذف الأذكار';
  static const String deleteCustomAzkarDialogMessage =
      'هل تريد حذف هذه الأذكار نهائيًا؟';
  static const String deleteItemDialogTitle = 'حذف الذكر';
  static const String deleteItemDialogMessage =
      'هل تريد حذف هذا الذكر من القائمة؟';
  static const String delete = 'حذف';
  static const String cancel = 'إلغاء';
  static const String save = 'حفظ';
  static const String zikrText = 'نص الذكر';
  static const String zikrTextHint = 'اكتب نص الذكر هنا';
  static const String zikrTextRequired = 'نص الذكر مطلوب';
  static const String targetCount = 'العدد المستهدف';
  static const String targetCountHint = 'مثال: 33';
  static const String targetCountRequired = 'العدد المستهدف مطلوب';
  static const String targetCountGreaterThanZero =
      'العدد يجب أن يكون أكبر من صفر';
  static const String azkarSavedSuccess = 'تم حفظ الأذكار بنجاح';
  static const String customAzkarDeletedSuccess = 'تم حذف الأذكار بنجاح';
  static const String resetCounter = 'تصفير العداد';
  static const String editTargetCount = 'تعديل الهدف';
  static const String restoreCategoryDialogTitle = 'استعادة الأذكار';
  static const String restoreCategoryDialogMessage =
      'هل تريد استعادة الأذكار الأصلية وحذف التعديلات؟';
  static String azkarCountLabel(int count) => 'عدد الأذكار: $count';

  // Reading settings
  static const String azkarTasbeehSettingsTitle = 'إعدادات القراءة';
  static const String fontSize = 'حجم الخط';
  static const String fontSmall = 'صغير';
  static const String fontLarge = 'كبير';
  static const String fontSizePreview = 'معاينة';
  static const String saveSettingsError = 'تعذّر حفظ إعدادات القراءة';
  static const String loadSettingsError = 'تعذّر تحميل إعدادات القراءة';
  static const String fontSizePreviewText = 'سبحان الله';
  static const String hapticFeedback = 'اهتزاز العداد';

  // Tasbeeh
  static const String tasbeehTitle = 'السبحة';
  static const String chooseTasbeehToStart = 'اختر سبحة للبدء';
  static const String tasbeehPresetSubhan = 'سبحان الله وبحمده، سبحان الله العظيم';
  static const String tasbeehPresetIstighfar = 'أستغفر الله';
  static const List<String> tasbeehPresets = [
    tasbeehPresetSubhan,
    tasbeehPresetIstighfar,
  ];
  static const String allTasbeeh = 'كل السبح';
  static const String chooseTasbeeh = 'اضغط لاختيار السبحة';
  static const String continueTasbeeh = 'متابعة';
  static const String customTasbeeh = 'سبحة مخصصة';
  static const String addTasbeeh = 'إنشاء سبحة';
  static const String editTasbeeh = 'تعديل السبحة';
  static const String deleteTasbeeh = 'حذف السبحة';
  static const String deleteTasbeehDialogTitle = 'حذف السبحة';
  static const String deleteTasbeehDialogMessage =
      'هل تريد حذف هذه السبحة نهائيًا؟';
  static const String tasbeehName = 'نص السبحة';
  static const String tasbeehNameHint = 'مثال: سبحان الله';
  static const String tasbeehNameRequired = 'نص السبحة مطلوب';
  static const String tasbeehTarget = 'العدد المستهدف';
  static const String tasbeehTargetHint = 'اتركه فارغًا للعد الحر';
  static String tasbeehTargetMaxError(int max) =>
      'الحد الأقصى للعدد هو $max';
  static const String tasbeehEmpty = 'لا توجد سبح محفوظة';
  static const String tasbeehLoadError = 'تعذّر تحميل السبح';
  static const String tasbeehSaveError = 'تعذّر حفظ السبحة';
  static const String tasbeehDeleteError = 'تعذّر حذف السبحة';
  static const String tasbeehOptions = 'خيارات السبحة';

  // Counters
  static String counterValue(int value) => '$value';

  // Fields
  static const String requiredField = 'حقل مطلوب';
  static const String requiredFieldMark = '*';
  static const String optionalFieldMark = '(اختياري)';
  static String charCounter(int currentLength, int maxLength) =>
      '$currentLength / $maxLength';

  // Semantics
  static const String remainingCounterLabel = 'العدد المتبقي للتكرار';
  static const String completed = 'تم الانتهاء';
  static const String completedRepetitions = 'تم الانتهاء من التكرار';
  static const String tapToCount = 'انقر للعد واحتساب التكرار';
  static String zikrLabel(String text) => 'ذكر: $text';
  static String tasbeehSelectorSemantics(String text) =>
      '$chooseTasbeeh: $text';
  static String remainingCountOfTotal(int remaining, int total) =>
      'متبقي $remaining من $total';

  // States
  static const String errorWidgetTitle = 'عذرًا، حدث خطأ';
  static const String tryAgain = 'حاول مرة أخرى';
  static const String emptyTitle = 'لا يوجد محتوى';
}
