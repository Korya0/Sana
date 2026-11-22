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
  static const String volumeButtonCount = 'العد بأزرار الصوت';
  static const String volumeButtonCountUnsupported =
      'متاح على أجهزة Android فقط';

  // Tasbeeh
  static const String tasbeehTitle = 'السبحة';
  static const String chooseTasbeehToStart = 'اختر سبحة للبدء';
  static const String tasbeehPresetSubhan =
      'سبحان الله وبحمده، سبحان الله العظيم';
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

  // Zakat — shared
  static const String zakatTitle = 'زكاتي';
  static const String zakatSubtitle = 'احسب زكاتك بسهولة واعرف كيف تُخرجها';
  static const String zakatCalculate = 'حساب الزكاة';
  static const String zakatStartCalculation = 'ابدأ حساب الزكاة';
  static const String zakatExplain = 'شرح الزكاة';
  static const String zakatReadExplanation = 'اقرأ شرح الزكاة';
  static const String zakatResult = 'نتيجة الحساب';
  static const String zakatDisclaimer =
      'هذا التطبيق يقدّر مقدار الزكاة للتسهيل، وليس فتوى '
      'شرعية. في الحالات المعقدة اسأل أهل العلم الثقات.';
  static const String zakatDisclaimerControversial =
      'من المسائل الخلافية: زكاة الذهب الشخصي، خصم الديون، ومعيار '
      'النصاب. راجع جهة الفتوى المعتمدة كدار الإفتاء المصرية.';
  static const String zakatResultDisclaimer =
      'هذه النتيجة تقديرية ولا تُعد فتوى شرعية. إن لم تكن متأكدًا '
      'من النصاب أو الحول فتحقق من الحكم الشرعي عند أهل العلم.';
  static const String zakatWhatIs = 'ما هي الزكاة؟';
  static const String zakatWhatIsBody =
      'الزكاة عبادة مالية فرضها الله على المسلم القادر، فيُخرج جزءًا '
      'صغيرًا من ماله للمستحقين إذا بلغ المال النصاب وتحققت شروط '
      'الوجوب. وهي من أركان الإسلام الخمسة.';

  // Zakat — explainer
  static const String zakatQaWhat = 'ما هي الزكاة؟';
  static const String zakatQaWhatAnswer =
      'عبادة مالية فرضها الله على المسلمين المستحق عليهم إخراجها وفقًا لشروطها.';
  static const String zakatQaWhen = 'متى تجب؟';
  static const String zakatQaWhenAnswer =
      'في الأموال التي تجب فيها الزكاة عند بلوغ النصاب وتحقق شروط الوجوب ومرور الحول.';
  static const String zakatQaNisab = 'ما هو النصاب؟';
  static const String zakatQaNisabAnswer =
      'الحد الأدنى من المال الذي إذا بلغه وجبت الزكاة (85 جم ذهب خالص أو 595 جم فضة).';
  static const String zakatQaHawl = 'ما هو الحول؟';
  static const String zakatQaHawlAnswer =
      'أن تمر سنة هجرية كاملة على المال وهو بالغ للنصاب.';
  static const String zakatQaRate = 'كم مقدار زكاة المال؟';
  static const String zakatQaRateAnswer =
      'ربع العشر، أي 2.5%، في الأموال التي ينطبق عليها هذا المقدار.';
  static const String zakatRecipientsTitle = 'من يستحق الزكاة؟';
  static const String zakatRecipientsIntro =
      'الفئات الثماني المذكورة في سورة التوبة، الآية 60:';
  static const String zakatExampleTitle = 'مثال بسيط';
  static const String zakatExampleBody =
      'إذا كنت تملك 100 جرام من الذهب عيار 21، وكان سعر جرام عيار 21 '
      'هو 5,000 جنيه، فقيمة الذهب = 100 × 5,000 = 500,000 جنيه.\n'
      'وللتحقق من النصاب يُحوَّل الوزن إلى ما يعادله من الذهب الخالص: '
      '100 × 21 ÷ 24 = 87.5 جرامًا، وهو يبلغ نصاب الذهب (85 جرامًا). '
      'فإذا مر الحول على هذا المال، تكون الزكاة = 500,000 × 2.5% = '
      '12,500 جنيه.';
  static const List<String> zakatRecipients = [
    'الفقراء',
    'المساكين',
    'العاملون عليها',
    'المؤلفة قلوبهم',
    'في الرقاب (تحرير الرقاب)',
    'الغارمون (المدينون)',
    'في سبيل الله',
    'ابن السبيل',
  ];

  // Zakat — calculate flow
  static const String zakatStepNisabPrices = 'النصاب والأسعار';
  static const String zakatCurrencyTitle = 'عملة الحساب';
  static const String zakatCurrencyLabel = 'اختر العملة';
  static const String zakatCurrencyHelper =
      'كل المبالغ والأسعار وقيمة النصاب تُحسب وتُعرض بهذه العملة.';
  static String zakatCurrencySemantics(String label) =>
      'عملة الحساب المختارة: $label';
  static const String zakatStepAssets = 'أموالك';
  static const String zakatStepHawl = 'الحول';
  static String zakatStepProgress(int current, int total) =>
      'الخطوة $current من $total';
  static const String zakatNext = 'التالي';
  static const String zakatPrevious = 'السابق';
  static const String zakatSectionNisabPrices = 'أولًا: النصاب والأسعار';
  static const String zakatSectionAssets = 'ثانيًا: أموالك';
  static const String zakatSectionDebts = 'ثالثًا: ما عليك من ديون';
  static const String zakatSectionHawl = 'رابعًا: الحول';
  static const String zakatChooseStandard =
      'اختر المعيار الذي تعتمده في تقدير النصاب:';
  static String zakatNisabStandardLabel(String label) => 'نصاب $label';
  static const String zakatGoldKaratLabel = 'عيار الذهب';
  static const String zakatGoldKaratHelper =
      'اختر عيار الذهب الذي تملكه. الشائع في مصر عيار 21.';
  static String zakatKaratLabel(int karat) => 'عيار $karat';
  static String zakatGoldPriceLabel(int karat) => 'سعر جرام الذهب عيار $karat';
  static const String zakatGoldPriceHelper =
      'أدخل سعر الجرام من العيار المختار.';
  static const String zakatSilverPriceLabel = 'سعر جرام الفضة النقية';
  static const String zakatSilverPriceHelper =
      'أدخل سعر الجرام الحالي من مصدر موثوق.';
  static const String zakatPriceSuffix = 'جنيه / جرام';
  static String zakatPriceSuffixFor(String currency) =>
      '$currency / $zakatGramsSuffix';
  static const String zakatFetchPrices =
      'جلب أسعار الذهب والفضة تلقائيًا عبر الإنترنت';
  static const String zakatLoadingPrices =
      'جارٍ فحص الاتصال وتحديث أسعار الذهب والفضة...';
  static const String zakatPricesOnlineNote =
      'تم جلب أسعار الذهب والفضة آليًا عبر الإنترنت وفقًا لأسعار السوق الحالية.';
  static const String zakatPricesOfflineNote =
      'يختلف النصاب بحسب المعيار. يمكنك إدخال الأسعار يدويًا لعدم توفر اتصال بالإنترنت.';
  static const String zakatLivePricesTitle =
      'تم جلب أسعار الذهب والفضة تلقائيًا عبر الإنترنت';
  static const String zakatRefreshPrices = 'إعادة التحديث';
  static String zakatGoldLivePriceLabel(int karat) =>
      'سعر جرام الذهب (عيار $karat):';
  static const String zakatSilverLivePriceLabel = 'سعر جرام الفضة النقية:';
  static const String zakatPoundSuffix = 'جنيه';
  static const String zakatNisabPreviewMissingGold =
      'أدخل سعر جرام الذهب لتظهر قيمة النصاب التقديرية.';
  static const String zakatNisabPreviewMissingSilver =
      'أدخل سعر جرام الفضة لتظهر قيمة النصاب التقديرية.';
  static const String zakatNisabPreviewPrefix = 'النصاب التقديري = ';
  static const String zakatNisabPreviewPure = 'سعر الخالص';
  static const String zakatNisabPreviewSilverPrice = 'سعر الجرام';

  static const String zakatCashLabel = 'الأموال النقدية والمدخرات';
  static const String zakatCashHelper =
      'النقد الذي معك والأرصدة في البنك وحسابات التوفير.';
  static const String zakatSilverGramsLabel = 'وزن الفضة بالجرام';
  static const String zakatSilverGramsHelper =
      'أدخل وزن الفضة النقية التي تملكها، إن وجدت.';
  static const String zakatTradeLabel = 'الأموال التجارية';
  static const String zakatTradeHelper =
      'قيمة البضاعة المعدّة للبيع وسيولة التجارة.';
  static const String zakatReceivableLabel =
      'ديون لك عند الآخرين يُرجى تحصيلها';
  static const String zakatReceivableHelper = 'أدخل فقط الدين الذي ترجو سداده.';
  static String zakatGoldGramsLabelFor(int karat) =>
      'وزن الذهب بالجرام (عيار $karat)';
  static const String zakatGoldGramsHelper = 'أدخل وزن الذهب الذي تملكه.';
  static const String zakatGramsSuffix = 'جرام';
  static const String zakatGoldPersonalLabel =
      'الذهب للاستعمال الشخصي (حلي ونحوه)';
  static const String zakatGoldPersonalSubtitle =
      'زكاة الذهب المقتنى للاستعمال الشخصي فيها خلاف فقهي.';
  static const String zakatIncludePersonalGoldLabel = 'أريد إدخاله في الحساب';
  static const String zakatIncludePersonalGoldSubtitle =
      'إن لم تفعّل الخيار يُستبعد الذهب الشخصي من الحساب.';
  static const String zakatDebtsLabel = 'الديون والالتزامات الحالّة';
  static const String zakatDebtsHelper =
      'أدخل ما حلّ موعد سداده وترى أنه يجوز خصمه.';
  static String zakatMetalValue({
    required String metal,
    required String weight,
    required String price,
    required String value,
  }) => 'قيمة $metal: $weight × $price = $value';
  static String zakatInvalidPrice(String metal) =>
      'أدخل سعر جرام $metal لحساب قيمته والنصاب.';
  static const String zakatInvalidNumber =
      'أدخل رقمًا صحيحًا (بدون علامة سالبة).';
  static const String zakatValueTooLarge = 'القيمة كبيرة جدًا، تأكد من الرقم.';

  static const String zakatHawlTitle =
      'مرت سنة هجرية كاملة على مالي وهو بالغ للنصاب';
  static const String zakatHawlSubtitle =
      'الحول شرط أساسي في وجوب الزكاة. '
      'لا يمكن عرض نتيجة الحساب إلا بعد التأكد من تمام الحول.';
  static const String zakatHawlError =
      'يجب التأكد من مرور الحول (سنة هجرية كاملة) لعرض النتيجة.';
  static const String zakatCalculateAction = 'احسب الزكاة';
  static const String zakatClearAction = 'مسح البيانات وإعادة الحساب';
  static const String zakatValidationError =
      'تحقق من القيم المميزة باللون الأحمر ثم حاول مرة أخرى.';
  static const String zakatHawlBlocked =
      'لا يمكن عرض النتيجة إلا بعد التأكد من تمام الحول الشرعي.';
  static const String zakatPriceMissingResult =
      'لا يمكن إتمام الحساب لأن سعر المعدن غير متاح. راجع الأسعار في الخطوة الأولى.';
  static const String zakatClearDialogTitle = 'مسح بيانات الحساب';
  static const String zakatClearDialogMessage =
      'سيتم حذف كل المبالغ والأسعار التي أدخلتها. هل تريد المتابعة؟';
  static const String zakatClearConfirm = 'مسح';
  static const String zakatClearCancel = cancel;
  static const String zakatClearedSnackbar = 'تم مسح البيانات.';
  static const String zakatUndo = 'تراجع';

  // Zakat — result
  static const String zakatResultDetails = 'تفاصيل الحساب';
  static const String zakatResultHow = 'كيف وصلنا إلى النتيجة؟';
  static const String zakatVerdictDue = 'تجب عليك الزكاة';
  static const String zakatVerdictBelowNisab = 'المال لم يبلغ النصاب';
  static const String zakatVerdictHawlMissing = 'لم يمر الحول بعد';
  static const String zakatVerdictPriceMissing = 'سعر المعدن غير مدخل';
  static const String zakatZakatDueAmount = 'مقدار الزكاة الواجب إخراجها';
  static const String zakatTotalAssets = 'إجمالي الأموال';
  static const String zakatDeductions = 'الخصومات المطبّقة';
  static const String zakatNetEstimated = 'صافي المال (تقديري)';
  static const String zakatNet = 'صافي المال';
  static const String zakatMetals = 'المعادن';
  static const String zakatGoldValue = 'قيمة الذهب';
  static const String zakatSilverValue = 'قيمة الفضة';
  static const String zakatGoldWeight = 'وزن الذهب';
  static const String zakatSilverWeight = 'وزن الفضة';
  static const String zakatNisabSection = 'النصاب';
  static const String zakatStandardUsed = 'المعيار المعتمد';
  static const String zakatNisabValue = 'قيمة النصاب';
  static const String zakatHawlCompleted = 'تمام الحول';
  static const String zakatYes = 'نعم';
  static const String zakatNo = 'لا';
  static const String zakatUnknown = 'غير محدد';
  static String zakatGoldWeightValue(String weight, int karat) =>
      '$weight جرام (عيار $karat)';
  static String zakatSilverWeightValue(String weight) => '$weight جرام';
  static String zakatStatusDueExplanation(
    String net,
    String nisab,
    String amount,
  ) =>
      'صافي مالك $net، وهو يبلغ النصاب ($nisab) وقد مر عليه الحول.\n'
      'الزكاة التقديرية = $net × 2.5% = $amount.';
  static String zakatStatusBelowExplanation(String net, String nisab) =>
      'صافي مالك $net، وهو أقل من النصاب ($nisab)، '
      'فلا تجب عليك الزكاة بحسب البيانات المدخلة.';
  static String zakatStatusHawlExplanation(String net, String nisab) =>
      'صافي مالك $net، وهو يبلغ النصاب ($nisab)، لكن لم يتم الحول '
      'بعد، فلا تجب الزكاة الآن.';
  static String zakatStatusUnknownExplanation(String net, double rate) =>
      'القيمة المحسوبة من البيانات المتاحة $net (قد تكون ناقصة). '
      'لم يتم إدخال سعر المعدن اللازم، فلا يمكن تقدير النصاب بدقة. '
      'نسبة الزكاة شرعاً هي ${rate * 100}%.';
  static const String zakatEditData = 'تعديل البيانات';
  static const String zakatBackHome = 'العودة للرئيسية';

  // Zakat — guided flow additions
  static const String zakatMetalGold = 'الذهب';
  static const String zakatMetalSilver = 'الفضة';
  static const String zakatStepReview = 'المراجعة';
  static const String zakatReviewTitle = 'المراجعة الأخيرة';
  static const String zakatReviewHint =
      'راجع الأسعار والأموال، ثم أكّد تمام الحول.';
  static const String zakatHawlQuickPrompt =
      'سؤال سريع: هل مرّ على مالك سنة هجرية كاملة؟';
  static const String zakatHawlQuickHint =
      'لا تقلق، يمكنك تأكيد الحول في الخطوة الأخيرة بعد مراجعة الأرقام.';
  static const String zakatSummaryStandard = 'المعيار';
  static const String zakatSummaryGoldPrice = 'سعر الذهب';
  static const String zakatSummaryNisab = 'قيمة النصاب';
  static String zakatSummaryNisabIn(String currency) =>
      'قيمة النصاب ($currency)';
  static const String zakatEmptyAssets =
      'أدخل قيمة واحدة على الأقل للأموال أو المعادن قبل عرض النتيجة.';
  static const String zakatPriceErrorInline =
      'تعذّر اعتماد سعر المعدن. حدّث الأسعار أو أدخلها يدويًا ثم حاول مرة أخرى.';
  static const String zakatEmptyField = 'فارغ';
  static String zakatSummaryValue(String label, String value) =>
      '$label: $value';

  // Zakat — accessibility labels
  static const String zakatPricesSemanticsLabel = 'أسعار المعادن';
  static String zakatLivePricesSemantics(String gold, String silver) =>
      'سعر الذهب $gold، سعر الفضة $silver';

  // States
  static const String errorWidgetTitle = 'عذرًا، حدث خطأ';
  static const String tryAgain = 'حاول مرة أخرى';
  static const String emptyTitle = 'لا يوجد محتوى';
}
