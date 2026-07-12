class AppStrings {
  const AppStrings._();
  static const String exit = 'خروج';
  // common
  static const String pressHereToSeeMore = 'تصفح المزيد';
  static String itemCopied(String item) => 'تم نسخ $item بنجاح';
  static const String copiedToClipboard = 'تم النسخ بنجاح';
  static const String comingSoon = 'قريباً إن شاء الله';
  // Hijri Adjustment
  static const String hijriAdjustmentBottomSheetTitle =
      'يمكنك تصحيح التاريخ يدويًا إذا وجدت اختلافًا في بلدك';
  static const String hijriAdjustmentBottomSheetReturnToNormal =
      'العودة للتاريخ التلقائي';
  static String hijriAdjustmentDialogTitle(String hijriStr) =>
      'هل اليوم هو $hijriStr في بلدك؟';
  static const String hijriAdjustmentDialogMessage =
      'تأكيدك في بداية كل شهر يضمن دقة التاريخ هجرياً حسب رؤية بلدك.';
  static const String hijriAdjustmentDialogFooterNote =
      '\n\n(تنبيه: يمكنك التعديل لاحقاً بالضغط على التاريخ في الشاشة الرئيسية)';
  static const String hijriAdjustmentDialogConfirmText = 'التاريخ صحيح';
  static const String hijriAdjustmentDialogCancelText = 'تعديل يدوي';
  static const String hijriEditAtAnyTime = 'للتعديل في أي وقت:';
  static const String hijriClickToEditHint = 'اضغط على التاريخ الهجري...';
  static const String hijriAdjustmentSaveError =
      'فشل في حفظ تعديل التاريخ الهجري';
  static const String hijriMonthSaveError = 'فشل في حفظ تعديل الشهر الهجري';
  static const String hijriSymbol = 'هـ';
  static const String notificationDefaultChannelId = 'default_channel_id';
  static const String notificationDefaultChannelName = 'التنبيهات العامة';
  static const String notificationMorningTitle = 'أذكار الصباح';
  static const String notificationMorningBody = 'حان وقت أذكار الصباح، نور ليومك وبركة لوقتك.';
  static const String notificationEveningTitle = 'أذكار المساء';
  static const String notificationEveningBody = 'حان وقت أذكار المساء، حصن نفسك واذكر ربك.';
  static const String notificationNightTitle = 'أذكار النوم';
  static const String notificationNightBody = 'حان وقت أذكار النوم، راحة لقلبك وطمأنينة لنفسك.';
  static const String notificationGeneralTitle = 'ذكر الله';
  static const String notificationGeneralBody = 'لا تنس ذكر الله اليوم، فبذكر الله تطمئن القلوب.';
  static const String notificationWakeUpTitle = 'أذكار الاستيقاظ';
  static const String notificationWakeUpBody = 'حان وقت أذكار الاستيقاظ، ابدأ يومك بذكر الله وبركة.';

  // Notification permission
  static const String notificationPermissionTitle = 'إذن الإشعارات';
  static const String notificationPermissionMessage =
      'يلزم إذن الإشعارات لتفعيل التذكيرات وتلقي التنبيهات في الوقت المحدد.';

  // Reminder errors
  static const String reminderLoadError = 'فشل في تحميل التذكيرات';
  static const String reminderSaveError = 'فشل في حفظ التذكير';
  static const String reminderUpdateError = 'فشل في تعديل التذكير';
  static const String reminderDeleteError = 'فشل في حذف التذكير';
  static const String reminderToggleError = 'فشل في تغيير حالة التذكير';
  static const String reminderNotFound = 'التذكير غير موجود';
  static const String reminderSectionTitle = 'التذكيرات';
  static const String reminderAdd = 'إضافة';
  static const String reminderAlreadyExists = 'يوجد تذكير لهذا القسم بالفعل';
  static const String noRemindersActiveForThisZikr = 'لا توجد تذكيرات مفعلة لهذا الذكر';
  static const String reminderPermissionDeniedTitle = 'إذن الجدولة مرفوض';
  static const String reminderPermissionDeniedMessage =
      'يرجى تفعيل إذن الجدولة الدقيقة في إعدادات التطبيق لتفعيل التذكيرات';

  static const String sharingError = 'حدث خطأ أثناء المشاركة';
  static const String copyError = 'حدث خطأ أثناء النسخ';

  // App Update
  static const String appUpdateMessage = 'تحديث جديد متاح';
  static const String updateNow = 'تحديث الآن';

  // asma ul husna
  static const String asmaUlHusna = 'أسماء الله الحسنى';

  static const String asmaUlHusnaShareCardDepartment = 'من أسماء الله الحسنى';
  static const String skeletonAsmaName = 'الله';
  static const String skeletonAsmaMeaningBrief = 'معنى مختصر للاسم الحسنى';
  static const String skeletonAsmaMeaningDetailed = 'معنى تفصيلي للاسم الحسنى';

  // azkar

  static const String zkr = 'ذكر';
  static const String azkarExitDialogTitle = 'تنبيه';
  static const String azkarExitDialogMessage =
      'هل تريد الخروج؟ ستفقد تقدمك الحالي في الأذكار';
  static const String azkarExitDialogConfirmText = 'خروج';
  static const String azkarExitDialogCancelText = 'البقاء';
  static const String azkarCompletedMessage =
      'لقد أتممت جميع الأذكار بنجاح، جعلها الله في ميزان حسناتك';
  static const String azkarShareCardDepartment = 'من الأذكار';

  // daily Content
  static const String dailyContentFavorites = 'المفضلة اليومية';
  static const String dailyContentNoFavoritesYet =
      'لا يوجد محتوى في المفضلة بعد';
  static const String hadith = 'حديث نبوي';
  static const String sunnah = 'سنة مهجورة';
  static const String explanation = 'شرح';
  static const String close = 'إغلاق';
  static const String explanationAndClarification = 'شرح وتوضيح';
  static const String copyExplanation = 'نسخ الشرح';
  static const String fromSunnah = 'من سنة الحبيب ﷺ';
  static const String fromHadith = 'من الحديث اليومي';
  static const String hadithOfTheDay = 'حديث اليوم';

  // App Error widget
  static const String errorWidgetTitle = 'عذراً، حدث خطأ';
  static const String tryAgain = 'حاول مرة أخرى';
  static const String pageNotFound = 'الصفحة غير موجودة';
  static const String pageNotFoundDescription =
      'عذراً، لم نتمكن من العثور على الصفحة التي تبحث عنها. قد تكون محذوفة أو بها خطأ فني.';
  static const String backToHome = 'العودة للرئيسية';
  // Location & City
  static const String loading = 'جارٍ التحميل...';
  static const String notAvailable = 'غير متوفر حالياً';
  static const String notAccessible = 'غير متاح';
  static const String unknownLocation = 'موقع غير معروف';
  static const String locationError =
      'نحتاج للوصول إلى موقعك لتحديد القبلة ومواقيت الصلاة بدقة';

  // Qibla
  static const String sensorError =
      'هاتفك قد لا يدعم الحساسات اللازمة لهذه الميزة';
  static const String qiblaDirection = 'اتجاه القبلة';
  static const String qiblaErrorLoad =
      'عذراً، تعذر تحميل البيانات حالياً. يرجى المحاولة لاحقاً';
  static const String qiblaCompassGuidelines = 'إرشادات استخدام البوصلة';
  static const String qiblaCompassNoSensor =
      'إذا لم يتحرك السهم، فجهازك قد لا يحتوي على حساس البوصلة';
  static const String qiblaBestAccuracy = 'للحصول على أفضل دقة:';
  static const String qiblaGuideline1 =
      'ابعد أي أجهزة إلكترونية أو أغلفة معدنية عن الهاتف';
  static const String qiblaGuideline2 = 'ضع الهاتف على سطح مستوٍ';
  static const String qiblaGuideline3 =
      'لف الهاتف ببطء حتى يثبت السهم على اتجاه القبلة';
  static const String qiblaCalibrationHint =
      'ضع الهاتف على الأرض وقم بتدويره ليكون اتجاه رأس السهم مع الكعبة';
  static const String iUnderstood = 'فهمت';
  static const String distanceToMecca = 'المسافة إلى مكة';
  static const String distanceUnitKm = 'كم';
  static const String qiblaRight = 'اليمين';
  static const String qiblaLeft = 'اليسار';
  static const String qiblaPerfectMessage = 'ممتاز! أنت في الاتجاه الصحيح';
  static const String qiblaPerfectSubMessage = 'يمكنك الصلاة الآن';
  static const String qiblaCloseMessage = 'قريب جداً من الاتجاه الصحيح';
  static String qiblaCloseSubMessage(String direction) =>
      'حرك الهاتف قليلاً نحو $direction';
  static String qiblaAdjustingMessage(String direction) =>
      'استمر في التوجيه نحو $direction';
  static String qiblaAdjustingSubMessage(int angle) => 'متبقي $angle° تقريباً';
  static String qiblaSearchingMessage(String direction) =>
      'استدر نحو $direction';
  static String qiblaSearchingSubMessage(int angle) => 'متبقي $angle° تقريباً';
  static const String compassMode = 'بوصلة';
  static const String mapMode = 'خريطة';

  static const String degreeSymbol = '°';
  static const String north = 'N';
  static const String east = 'E';
  static const String south = 'S';
  static const String west = 'W';

  static const String noInternet = 'يرجى التحقق من اتصالك بالإنترنت';
  static const String ourFault =
      'نعتذر، حدث خطأ تقني ونحن نعمل على إصلاحه الآن';
  static const String missingDataError =
      'لا توجد بيانات متوفرة حالياً، يرجى المحاولة لاحقاً';

  // Location Manager
  static const String enableLocationServiceTitle = 'تفعيل خدمة الموقع';
  static const String enableLocationServiceMessage =
      'نحتاج إلى تفعيل خدمة الموقع لمتابعة استخدام التطبيق.';
  static const String enable = 'تفعيل';
  static const String locationPermissionTitle = 'إذن الموقع';
  static const String locationPermissionMessage =
      'نحتاج إلى إذن الوصول إلى موقعك لتحديد مواقيت الصلاة بدقة.';
  static const String allow = 'السماح';
  static const String locationPermissionPermanentlyDeniedTitle =
      'إذن الموقع مرفوض نهائياً';
  static const String locationPermissionPermanentlyDeniedMessage =
      'لقد تم رفض إذن الموقع. يجب تفعيل الإذن من إعدادات الهاتف لتشغيل هذه الميزة.';
  static const String openAppSettings = 'فتح إعدادات التطبيق';
  static const String locationEnabledCheckError = 'تعذر التحقق من حالة الـ GPS';
  static const String openLocationSettingsError = 'تعذر فتح إعدادات الموقع';
  static const String locationPermissionCheckError =
      'تعذر التحقق من أذونات الموقع';
  static const String locationPermissionRequestError = 'تعذر طلب إذن الموقع';
  static const String locationNameFetchError = 'تعذر جلب اسم المنطقة';
  static const String gpsTimeoutError =
      'انتهت مهلة تحديد الموقع، يرجى التأكد من تشغيل الـ GPS وحاول مرة أخرى';
  static const String waitingForLocation = 'بانتظار تحديد الموقع...';
  static const String locationStoredCheckSuccess = 'تم التحقق من الموقع بنجاح';
  static const String locationSavedSuccess = 'تم حفظ موقعك بنجاح';
  static const String autoLocation = 'تحديد تلقائي (GPS)';
  static const String needsLocationService = 'يرجى تفعيل خدمة الموقع للمتابعة';
  static const String needsLocationPermission = 'يرجى السماح بالوصول إلى موقعك';
  static const String locationDisabled = 'خدمة الموقع معطلة';
  static const String locationPermissionDenied = 'تم رفض إذن الموقع';
  static const String success = 'تم بنجاح';
  static const String selectCountry = 'اختر الدولة';
  static const String determineLocation = 'تحديد الموقع';
  static const String chooseLocationMethodMessage =
      'يرجى اختيار طريقة لتحديد الموقع والمواقيت';
  static const String chooseCountry = 'اختر دولة';
  static const String enterWithoutLocation = 'الدخول دون الموقع';
  static const String activateLocation = 'تفعيل الموقع';
  static const String egypt = 'مصر';
  static const String saudiArabia = 'السعودية';
  static const String uae = 'الإمارات';
  static const String kuwait = 'الكويت';
  static const String qatar = 'قطر';
  static const String oman = 'عمان';
  static const String jordan = 'الأردن';
  static const String lebanon = 'لبنان';
  static const String palestine = 'فلسطين';
  static const String morocco = 'المغرب';

  // Reminder UI
  static const String addReminder = 'إضافة تذكير';
  static const String editReminder = 'تعديل التذكير';
  static const String reminderTime = 'وقت التذكير';
  static const String repeat = 'التكرار';
  static const String repeatOnce = 'مرة واحدة';
  static const String repeatDaily = 'يومياً';
  static const String repeatCustom = 'أيام مخصصة';
  static const String days = 'الأيام';
  static const String daysPrefix = 'أيام: ';
  static const String monday = 'الإثنين';
  static const String tuesday = 'الثلاثاء';
  static const String wednesday = 'الأربعاء';
  static const String thursday = 'الخميس';
  static const String friday = 'الجمعة';
  static const String saturday = 'السبت';
  static const String sunday = 'الأحد';
  static const String mondayShort = 'ن';
  static const String tuesdayShort = 'ث';
  static const String wednesdayShort = 'ر';
  static const String thursdayShort = 'خ';
  static const String fridayShort = 'ج';
  static const String saturdayShort = 'س';
  static const String sundayShort = 'ح';

  // Feedback
  static const String feedbackTitle = 'اقتراح أو شكوى';
  static const String feedbackSubTitle = 'ساعدنا في تطوير التطبيق';
  static const String details = 'التفاصيل';
  static const String send = 'إرسال';
  static const String letContactInfo = 'بيانات التواصل (اختياري)';
  static const String emailOrPhone = 'بريد إلكتروني أو رقم هاتف';
  static const String writeDetails = 'اكتب وصفاً تفصيلياً هنا...';
  static const String writeDetailsLateset10Characters =
      'الرجاء كتابة 10 أحرف على الأقل';
  static const String thanksForYourContribution =
      'شكراً لمساهمتك، جزاك الله خيراً وجعلها الله في ميزان حسناتك.';
  static String webFeatureNotSupported(String feature) =>
      'ميزة $feature غير متاحة على الويب حالياً';
  static const String webNotSupported = 'هذه الميزة غير متاحة على الويب حالياً';

  // Hadith Search
  static const String hadiths = 'الأحاديث الشريفة';
  static const String noResults = 'لا توجد نتائج بحث';
  static const String addedToFavorites = 'تمت الإضافة للمفضلة';
  static const String removedFromFavorites = 'تمت الإزالة من المفضلة';
  static const String myFavoriteHadiths = 'أحاديثي المفضلة';
  static const String noFavoritesYet = 'لا توجد أحاديث في المفضلة بعد';
  static const String searchSearchHint = 'ابحث عن حديث (حروف عربية فقط)...';
  static const String suggestedTopics = 'مواضيع مقترحة';
  static const String narrator = 'الراوي:';
  static const String scholar = 'المحدث:';
  static const String source = 'المصدر:';
  static const String pageOrNumber = 'الصفحة أو الرقم:';
  static const String scholarJudgment = 'خلاصة حكم المحدث:';
  static const String page = 'الصفحة:';
  static const String worship = 'العبادات';
  static const String ethics = 'الأخلاق';
  static const String creedAndSofteningOfHearts = 'العقيدة والرقائق';
  static const String hadithSearchShareCardDepartment = 'من البحث الحديثي';

  // Hadith Search Suggestions
  static const String praySuggestion = 'الصلاة';
  static const String fastSuggestion = 'الصيام';
  static const String zakatSuggestion = 'الزكاة';
  static const String hajjSuggestion = 'الحج';
  static const String qiyamSuggestion = 'قيام الليل';
  static const String wuduSuggestion = 'الوضوء';
  static const String parentsSuggestion = 'بر الوالدين';
  static const String goodMannersSuggestion = 'حسن الخلق';
  static const String honestySuggestion = 'الصدق';
  static const String trustSuggestion = 'الأمانة';
  static const String mercySuggestion = 'تراحموا';
  static const String backbitingSuggestion = 'الغيبة';
  static const String repentanceSuggestion = 'التوبة';
  static const String seekingForgivenessSuggestion = 'الاستغفار';
  static const String paradiseSuggestion = 'الجنة';
  static const String hellSuggestion = 'النار';
  static const String graveTrialSuggestion = 'فتنة القبر';
  static const String faithSuggestion = 'الإيمان';

  // Developer Dashboard
  static const String adminPanel = 'لوحة الإدارة';
  static const String deletedSuccessfully = 'تم الحذف بنجاح';
  static const String deleteConfirmation = 'هل أنت متأكد من الحذف؟';
  static const String delete = 'حذف';
  static const String confirm = 'تأكيد';
  static const String cancel = 'إلغاء';
  static const String copy = 'نسخ';
  static const String adminReply = 'رد الإدارة';
  static const String noFeedbacksYet = 'لا توجد اقتراحات أو شكاوى حالياً';
  static const String features = 'الميزات';
  static const String feature = 'ميزة';
  static const String azkarHeader = 'الأذكار';
  static const String showMore = 'عرض المزيد';
  static const String home = 'الرئيسية';
  static const String settings = 'الإعدادات';
  static const String preferences = 'التفضيلات';
  static const String prayerSettings = 'إعدادات المواقيت';
  static const String shareReward = 'شاركنا الأجر';
  static const String personallyWithMe = 'تواصل معي';
  static const String support = 'الدعم';
  static const String contactPerBusiness = 'تواصل للأعمال';
  static const String shareAndRate = 'قيم وشارك';
  static const String aboutApp = 'عن التطبيق';
  static const String rateApp = 'قيم التطبيق';
  static const String shareApp = 'مشاركة التطبيق';
  static String shareAppText(String link) => 'حمل تطبيق سنا الآن:\n$link';
  static String shareWebAppText(String link) =>
      'تصفح نسخة الويب من تطبيق سنا:\n$link';
  static const String followAppOn = 'تابعنا على';
  static const String charityForMuslims = 'صدقة جارية للمسلمين';
  static const String teachPrayer = 'تعلم الصلاة';
  static const String asmaUlHusnaHome = 'الأسماء الحسنى';
  static const String salawat = 'الصلاة على النبي ﷺ';
  static const String qibla = 'القبلة';
  static const String deleteFeedbackConfirmationMessage =
      'هل أنت متأكد من رغبتك في حذف هذا الاقتراح بشكل نهائي؟';
  static const String userSuggestion = 'اقتراح مستخدم';
  static const String unknown = 'غير معروف';
  static const String unknownDevice = 'جهاز غير معروف';
  static const String unknownOS = 'نظام غير معروف';
  static String appVersionWithBuild(String version, String build) =>
      'تطبيق سنا: $version (إصدار $build)';

  static const String dailyWisdomHeader = 'أنوار اليوم';
  static const String quranKareem = 'القرآن الكريم';
  static const String quranCorrection = 'تصحيح التلاوة';
  static const String noDataAvailable = 'لا يوجد بيانات متاحة';

  // Secret Pin Dialog
  static const String adminSectionRequirePin = 'يرجى إدخال رمز الأمان للوصول';
  static const String invalidPin = 'عفواً، الرمز غير صحيح';
  static const String wrongPin = 'رمز خاطئ';
  static const String login = 'دخول';

  // Prayer & Sunnah
  static const String confirmedSunnah = 'سنة مؤكدة';
  static const String nobleHadith = 'حديث شريف';
  
  // --- Errors and Toasts ---
  static const String quranInitError = 'حدث خطأ أثناء تهيئة المصحف';
  static const String locationNotFound = 'لم يتم العثور على موقع';
  static const String qiblaLocationError = 'حدث خطأ في تحديد الموقع';
  static const String compassError = 'حدث خطأ في حساس البوصلة';
  static const String unexpectedError = 'حدث خطأ غير متوقع';
  static const String copiedSuccessfully = 'تم النسخ إلى الحافظة';
  static const String copyFailed = 'فشل النسخ';

  static const String noSunnahForPrayer = 'لا توجد سنن مؤكدة لهذه الصلاة';

  // Salat Ala Nabi
  static const String salatAlaNabiTitle = 'الصلاة على النبي ﷺ';
  static const String salawatReminderTitle = 'التذكير بالصلاة على النبي ﷺ';
  static const String salatAlaNabiNotificationBody =
      'اللهم صل وسلم وبارك على سيدنا محمد';
  static const String salatAlaNabiChannelDescription =
      'تنبيهات صوتية للصلاة على النبي ﷺ';
  static const String saveChanges = 'حفظ التغييرات';
  static const String changesSavedSuccess = 'تم حفظ التغييرات بنجاح';
  static const String saveChangesQuestion = 'حفظ التغييرات؟';
  static const String unsavedChangesMessage =
      'لديك تغييرات غير محفوظة. هل تريد حفظها؟';
  static const String discard = 'تجاهل';
  static const String maxIntervalError = 'الحد الأقصى 120 دقيقة';
  static const String minIntervalError = 'الحد الأدنى 15 دقيقة';
  static const String intervalQuestion = 'تكرار التنبيه (بالدقائق)';
  static const String intervalRangeNote =
      'المدة بين 15-120 دقيقة • قد يختلف التوقيت قليلاً حسب نظام الهاتف';
  static String minutes(int mins) => '$mins دقيقة';
  static const String enableReminder = 'تفعيل التذكير';
  static const String importantNotes = 'ملاحظات هامة';
  static const String reminderDelayWarning =
      'قد يتأخر التنبيه أحياناً بسبب قيود توفير الطاقة في النظام';
  static const String ensureServiceContinuity = 'لتبقى التنبيهات نشطة:';
  static const String openAppDaily = 'افتح التطبيق يومياً';
  static const String reactivateServiceOccasionally =
      'أعد تفعيل الخدمة من حين لآخر';
  static const String checkAppSettings =
      'تأكد من عدم تقييد التطبيق من إعدادات البطارية';
  static const String selectTime = 'اختر الوقت';
  static const String ok = 'موافق';
  static const String am = 'صباحاً';
  static const String pm = 'مساءً';
  static const String reminderWorkingHours = 'فترة تفعيل التذكير';
  static const String allDay = 'طوال اليوم';
  static const String twentyFourHours = '24 ساعة';
  static const String from10amTo10pm = 'من 10 صباحاً إلى 10 مساءً';
  static const String tenAmTenPm = '10 ص - 10 م';
  static const String selectCustomTime = 'تحديد وقت مخصص';
  static const String from = 'من';
  static const String to = 'إلى';

  // Teaching Prayer
  static String copiedTopicContent(String topic) => 'تم نسخ محتوى $topic';
  static const String copyContent = 'نسخ المحتوى';
  static const String fromTeachingPrayer = 'من تعليم الصلاة';

  // Prayer & Timing
  static const String nextPrayerRemaining = 'متبقي على صلاة';
  static const String currentPrayerTime = 'حان الآن وقت صلاة';
  static const String gracePeriodTitle = 'دقائق متبقية من وقت الصلاة';
  static const String religiousEventTitle = 'المناسبة الدينية';
  static const String eventToday = 'المناسبة الحالية';
  static const String upcomingEvent = 'المناسبة القادمة';
  static const String noReligiousEvents = 'لا توجد مناسبات دينية اليوم';
  static const String dayVirtue = 'فضل اليوم';
  static const String spiritualStatusDefault = 'ذكر الله تعالى';
  static const String spiritualStatusDefaultDesc = 'ألا بذكر الله تطمئن القلوب';
  static const String tapToKnowVirtue = 'اضغط لمعرفة الفضل';
  static const String statusDialogCategoryLabel = 'فضل الوقت';
  static const String hadithLabel = 'حديث نبوي';
  static const String virtueOfPrefix = 'فضل';
  static const String noVirtueAvailable = 'لا يوجد نص متاح حالياً.';
  static const String openingPrayerAction = 'دعاء الاستفتاح';
  static const String postPrayerAzkarAction = 'أذكار بعد الصلاة';
  static const String contentCopiedTitle = 'تم نسخ المحتوى بنجاح';
  static const String prayerSettingsTitle = 'إعدادات المواقيت';
  static const String calculationMethodTitle = 'طريقة الحساب';
  static const String madhabTitle = 'المذهب الفقهي';
  static const String openingPrayerCategoryId = '23';
  static const String postPrayerAzkarCategoryId = '1';
  static const String religiousEventsDepartment = 'من المناسبات الإسلامية';
  static const String prayerVirtuesDepartment = 'من فضل الأوقات';
  static const String prayerStatusShareImageName = 'prayer_status_share';
  static const String shareAsImage = 'مشاركة كصورة';
  static const String combinedShareCopyTooltip = 'مشاركة (ضغطة مطولة للنسخ)';

  // Religious Events
  static const String startHijriYear = 'رأس السنة الهجرية';
  static const String reminderToFastAshura = 'صيام عاشوراء (تذكير)';
  static const String ashura = 'يوم عاشوراء';
  static const String ramadhan = 'شهر رمضان';
  static const String nightOfQadir = 'ليالي القدر';
  static const String eidAlFitr = 'عيد الفطر المبارك';
  static const String sixShawwal = 'صيام الست من شوال';
  static const String arafah = 'يوم عرفة';
  static const String tenDaysOfDhulHijjah = 'عشر من ذي الحجة';
  static const String eidAlAdha = 'عيد الأضحى المبارك';

  // Prayer Names
  static const String fajr = 'الفجر';
  static const String sunrise = 'الشروق';
  static const String dhuhr = 'الظهر';
  static const String asr = 'العصر';
  static const String maghrib = 'المغرب';
  static const String isha = 'العشاء';

  // Theme Mode
  static const String themeModeLabel = 'المظهر';
  static const String themeModeDark = 'المظهر الداكن';
  static const String themeModeLight = 'المظهر الفاتح';
  static const String themeModeSystem = 'تلقائي (حسب النظام)';

  // Reading Settings
  static const String readingSettingsTitle = 'إعدادات القراءة';
  static const String fontSizeTitle = 'حجم الخط';
  static const String keepScreenAwakeTitle = 'إبقاء الشاشة مفتوحة';
  static const String keepScreenAwakeDescription =
      'منع الشاشة من الانطفاء تلقائياً أثناء تشغيل التطبيق';
  static const String fontSmall = 'صغير';
  static const String fontLarge = 'كبير';
  static const String saveSettingsError = 'تعذر حفظ إعدادات القراءة';
  static const String fontSizePreviewText =
      'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ.';

  // Semantics & Accessibility
  static const String enabled = 'مفعّل';
  static const String disabled = 'معطّل';
  static const String doubleTapToToggle = 'انقر مرتين للتفعيل أو التعطيل';
  static const String shareAndCopyOptions = 'خيارات مشاركة ونسخ الذكر';
  static const String remainingCounterLabel = 'العدد المتبقي للتكرار';
  static const String completed = 'تم الانتهاء';
  static const String completedText = 'اكتمل';
  static const String completedRepetitions = 'تم الانتهاء من التكرار';
  static const String tapToCount = 'انقر للعد واحتساب التكرار';
  static String zikrLabel(String text) => 'ذكر: $text';
  static String remainingCountOfTotal(int remaining, int total) =>
      'متبقي $remaining من $total';
}
