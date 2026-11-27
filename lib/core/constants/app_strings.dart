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

  // Quran
  static const String quranInitError = 'تعذّر تجهيز المصحف';
  static const String generalAppearance = 'المظهر العام';
  static const String themeSystem = 'نظام';
  static const String themeLight = 'فاتح';
  static const String themeDark = 'داكن';

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
  static const String startFirstZikr = 'ابدأ بإنشاء أول ذكر لإدارته';
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
  static const String reorderZikrHint = 'اضغط مطولاً لإعادة الترتيب';
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
  static const String close = 'إغلاق';
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
  static const String decrementOne = 'ناقص واحد';
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
  static const String saveSettingsError = 'تعذّر حفظ إعدادات القراءة';
  static const String loadSettingsError = 'تعذّر تحميل إعدادات القراءة';
  static const String hapticFeedback = 'اهتزاز العداد';
  static const String volumeButtonCount = 'العد بأزرار الصوت';
  static const String volumeButtonCountUnsupported =
      'متاح على أجهزة Android فقط';

  // Tasbeeh
  static const String tasbeehTitle = 'السبحة';
  static const String chooseTasbeehToStart = 'اختر سبحة للبدء';
  static const String chooseOrAddCustomTasbeeh = 'السبحة المخصصة';
  static const String tasbeehPresetSubhan =
      'سبحان الله وبحمده، سبحان الله العظيم';
  static const String tasbeehPresetIstighfar = 'أستغفر الله';
  static const String tasbeehPresetAlhamdulillah = 'الحمد للّه';
  static const String tasbeehPresetSubhanAllah = 'سبحان الله';
  static const List<String> tasbeehPresets = [
    tasbeehPresetSubhan,
    tasbeehPresetIstighfar,
  ];
  static const String allTasbeeh = 'كل السبح';
  static const String tasbeehListTitle = 'قائمة السبح';
  static const String chooseTasbeeh = 'اضغط لاختيار السبحة';
  static const String continueTasbeeh = 'متابعة';
  static const String continueCounting = 'متابعة التسبيح';
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
  static const String tasbeehTargetHint = 'اتركه فارغًا للعد الحر';
  static String tasbeehTargetMaxError(int max) => 'الحد الأقصى للعدد هو $max';
  static const String tasbeehEmpty = 'لا توجد سبح محفوظة';
  static const String tasbeehLoadError = 'تعذّر تحميل السبح';
  static const String tasbeehSaveError = 'تعذّر حفظ السبحة';
  static const String tasbeehDeleteError = 'تعذّر حذف السبحة';
  static const String tasbeehOptions = 'خيارات السبحة';

  // Counters
  static String counterValue(int value) => '$value';

  // Fields
  static const String requiredField = 'حقل مطلوب';
  static String tooShortText(int min) =>
      'النص قصير جدًا، الحد الأدنى $min أحرف';
  static const String arabicLettersRequired = 'اكتب حروفًا عربية صحيحة';
  static const String categoryNameDuplicate = 'يوجد قسم بهذا الاسم';
  static const String tasbeehTextDuplicate = 'يوجد سبحة بنفس النص';
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

  // Qibla
  static const String qiblaHeader = 'القبلة';
  static const String qiblaPermissionTitle = 'نحتاج إلى موقعك الحالي';
  static const String qiblaPermissionStep1 = 'اضغط زر «السماح بالوصول للموقع»';
  static const String qiblaPermissionStep2 = 'اختر «السماح أثناء استخدام التطبيق»';
  static const String qiblaAllow = 'السماح بالوصول للموقع';
  static const String qiblaDeniedTitle = 'تم رفض إذن الموقع';
  static const String qiblaDeniedStep1 = 'اضغط على زر «فتح الإعدادات» أولًا.';
  static const String qiblaDeniedStep2 = 'اختر «الأذونات» من صفحة التطبيق.';
  static const String qiblaDeniedStep3 = 'ابحث عن «الموقع» واضغط عليه.';
  static const String qiblaDeniedStep4 = 'اختر «السماح» ثم ارجع إلى التطبيق.';
  static const String qiblaOpenSettings = 'فتح الإعدادات';
  static const String qiblaFailedTitle = 'تعذّر تحديد موقعك';
  static const String qiblaFailedStep1 =
      'اسحب شريط الإشعارات، فعّل «الموقع»، ثم ارجع إلى التطبيق.';
  static const String qiblaFailedStep2 =
      'أو اضغط «فتح إعدادات الموقع»، فعّل خدمة الموقع، ثم ارجع. سيُعاد حساب الاتجاه تلقائيًا.';
  static const String qiblaOpenLocationSettings = 'فتح إعدادات الموقع';
  static const String qiblaUnsupportedTitle = 'جهازك لا يدعم البوصلة';
  static const String qiblaUnsupportedMessage =
      'جهازك لا يدعم حساس البوصلة، لذا لا يمكن استخدام هذه الميزة.';
  static const String qiblaFacing = 'أنت تواجه القبلة';
  static const String qiblaHoldInDirection =
      'ثبّت هاتفك في هذا الاتجاه ولا تحرّكه كثيرًا حتى تستقر البوصلة.';
  static const String qiblaTurnRight = 'استدر نحو اليمين';
  static const String qiblaTurnLeft = 'استدر نحو اليسار';
  static const String qiblaLowAccuracy = 'دقة البوصلة منخفضة';
  static const String qiblaPlaceFlat = 'ضع الهاتف على سطح مستوٍ';
  static const String qiblaFlatSurfaceGuidance =
      'ضع الهاتف على سطح مستوٍ وأبعده عن المعادن لتكون القراءة دقيقة.';
  static const String qiblaDeterminingLocation = 'جارٍ تحديد موقعك';
  static String qiblaRemainingDegrees(int degrees) =>
      'متبقي $degrees° تقريبًا. واصل الدوران ببطء حتى تواجه القبلة.';
}
