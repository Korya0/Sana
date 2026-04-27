class AppStrings {
  const AppStrings._();
  static const String exit = 'خروج';
  // common
  static const String pressHereToSeeMore = 'اضغط هنا لترى البقية';
  static const String copiedToClipboard = 'تم النسخ بنجاح';
  static const String comingSoon = 'قريباً إن شاء الله';
  // Hijri Adjustment
  static const String hijriAdjustmentBottomSheetTitle =
      'يمكنك تصحيح التاريخ يدويًا إذا وجدت اختلافًا في بلدك';
  static const String hijriAdjustmentBottomSheetReturnToNormal =
      'العودة للتاريخ التلقائي';
  static String hijriAdjustmtDialogTitle(String hijriStr) =>
      'هل اليوم هو $hijriStr في بلدك؟';
  static const String hijriAdjustmtDialogMessage =
      'تأكيدك في بداية كل شهر يضمن دقة التاريخ هجرياً حسب رؤية بلدك.';
  static const String hijriAdjustmtDialogFooterNote =
      '\n\n(تنبيه: يمكنك التعديل لاحقاً بالضغط على التاريخ في الشاشة الرئيسية)';
  static const String hijriAdjustmtDialogConfirmText = 'التاريخ صحيح';
  static const String hijriAdjustmtDialogCancelText = 'تعديل يدوي';

  // App Update
  static const String appUpdateMessage = 'تحديث جديد متاح';
  static const String updateNow = 'تحديث الآن';

  // asma ul husna
  static const String asmaUlHusna = 'أسماء الله الحسنى';
  static String copyAsmaUlHusna(String name) => 'تم نسخ اسم الله $name';

  static const String asmaUlHusnaShareCardDepartment = 'من أسماء الله الحسنى';

  // azkar
  static const String allAzkar = 'جميع الأذكار';
  static const String zkr = 'ذكر';
  static const String azkarExitDialogTitle = 'تنبيه';
  static const String azkarExitDialogMessage =
      'هل تريد الخروج؟ ستفقد تقدمك الحالي في الأذكار';
  static const String azkarExitDialogConfirmText = 'خروج';
  static const String azkarExitDialogCancelText = 'البقاء';
  static const String azkarCompletedMessage =
      'لقد أتممت جميع الأذكار بنجاح، جعلها الله في ميزان حسناتك';
  static const String azkarCopiedMessage = 'تم نسخ الذكر بنجاح';
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
  static const String waitingForLocation = 'بانتظار تحديد الموقع...';
  static const String locationStoredCheckSuccess = 'تم التحقق من الموقع بنجاح';
  static const String locationSavedSuccess = 'تم حفظ موقعك بنجاح';
  static const String autoLocation = 'تحديد تلقائي (GPS)';
  static const String needsLocationService = 'يرجى تفعيل خدمة الموقع للمتابعة';
  static const String needsLocationPermission = 'يرجى السماح بالوصول إلى موقعك';
  static const String locationDisabled = 'خدمة الموقع معطلة';
  static const String locationPermissionDenied = 'تم رفض إذن الموقع';
  static const String success = 'تم بنجاح';

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
  static const String qiblaWebNotSupported =
      'ميزة القبلة غير متاحة على الويب حالياً';
  static const String salatAlaNabiWebNotSupported =
      'ميزة الصلاة على النبي غير متاحة على الويب حالياً';
  static const String hadithSearchWebNotSupported =
      'ميزة البحث في الأحاديث غير متاحة على الويب حالياً';

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

  // Developer Dashboard
  static const String adminPanel = 'لوحة الإدارة';
  static const String deletedSuccessfully = 'تم الحذف بنجاح';
  static const String deleteConfirmation = 'هل أنت متأكد من الحذف؟';
  static const String delete = 'حذف';
  static const String cancel = 'إلغاء';
  static const String copy = 'نسخ';
  static const String adminReply = 'رد الإدارة';
  static const String noFeedbacksYet = 'لا توجد اقتراحات أو شكاوى حالياً';
  static const String features = 'الميزات';
  static const String feature = 'ميزة';
  static const String azkarHeader = 'الأذكار';
  static const String showMore = 'عرض المزيد';
  static const String settings = 'الإعدادات';
  static const String preferences = 'التفضيلات';
  static const String prayerSettings = 'إعدادات المواقيت';
  static const String shareReward = 'شاركنا الأجر';
  static const String personallyWithMe = 'تواصل معي';
  static const String contactPerBusiness = 'تواصل للأعمال';
  static const String shareAndRate = 'قيم وشارك';
  static const String rateApp = 'قيم التطبيق';
  static const String shareApp = 'مشاركة التطبيق';
  static String shareAppText(String link) => 'حمل تطبيق سَـنَـا الآن:\n$link';
  static String shareWebAppText(String link) =>
      'تصفح نسخة الويب من تطبيق سَـنَـا:\n$link';
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
      'تطبيق سَـنَـا: $version (إصدار $build)';

  static const String dailyWisdomHeader = 'أنوار اليوم';
  static const String quranKareem = 'القرآن الكريم';

  // Secret Pin Dialog
  static const String adminSectionRequirePin = 'يرجى إدخال رمز الأمان للوصول';
  static const String invalidPin = 'عفواً، الرمز غير صحيح';
  static const String wrongPin = 'رمز خاطئ';
  static const String login = 'دخول';

  // Prayer & Sunnah
  static const String confirmedSunnah = 'السنن المؤكدة';
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
  static const String ensureServiceContinuity = 'لضمان استمرار الخدمة:';
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
  static const String nobleHadith = 'حديث شريف';
  static const String shareAsImage = 'مشاركة كصورة';
  static const String combinedShareCopyTooltip = 'مشاركة (ضغطة مطولة للنسخ)';
}
