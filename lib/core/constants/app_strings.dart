import 'package:sana/core/constants/app_constants.dart';

class AppStrings {
  const AppStrings._();
  // common
  static const String pressHereToSeeMore = 'اضغط هنا لتري البقية';
  static const String copiedToClipboard = 'تم النسخ';

  // Hijri Adjustment
  static const String hijriAdjustmentBottomSheetTitle =
      'يمكنك تصحيح التاريخ يدويًا إذا وجدت اختلاف في بلدك';
  static const String hijriAdjustmentBottomSheetReturnToNormal =
      'العودة للتاريخ الطبيعي';
  static String hijriAdjustmtDialogTitle(String hijriStr) =>
      'هل اليوم هو $hijriStr في بلدك؟';
  static const String hijriAdjustmtDialogMessage =
      'تأكيدك في بداية كل شهر يضمن دقة التاريخ هجرياً حسب رؤية بلدك.';
  static const String hijriAdjustmtDialogConfirmText = 'التاريخ صحيح';
  static const String hijriAdjustmtDialogCancelText = 'التعديل الان';

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
  static const String azkarCompletedMessage =
      'لقد أتممت جميع الأذكار بنجاح، جعلها الله في ميزان حسناتك';
  static const String azkarCopiedMessage = 'تم نسخ الذكر بنجاح';
  static const String azkarShareCardDepartment = 'من الأذكار';

  // dialy Content
  static const String dailyContentFavorites = 'المفضلة اليومية';
  static const String dailyContentNoFavoritesYet =
      'لا يوجد محتوى في المفضلة بعد';
  static const String hadith = 'حديث نبوي';
  static const String sunnah = 'سنة مهجورة';
  static const String explanation = 'شرح';
  static const String close = 'إغلاق';
  static const String explanationAndClarification = 'شرح وتوضيح';
  static const String copyExplanation = 'نسخ الشرح';
  static const String understoodJazakAllahuKhairan = 'فهمت، جزاكم الله خيراً';
  static const String fromSunnah = 'من سنة الحبيب ﷺ';
  static const String fromHadith = 'من الحديث اليومي';
  static const String hadithOfTheDay = 'حديث اليوم';

  // App Error widget
  static const String errorWidgetTitle = 'عذراً، حدث خطأ';
  static const String tryAgain = 'حاول مرة اخري';
  // Location & City
  static const String loading = 'جارٍ التحميل';
  static const String notAvailable = 'غير متوفر';
  static const String notAccessible = 'غير متاح';
  static const String unknownLocation = 'غير معروف';
  static const String locationError =
      'نحتاج للوصول إلى موقعك لتحديد القبلة ومواقيت الصلاة';

  // Qibla
  static const String sensorError =
      'هاتفك قد لا يدعم الحساسات اللازمة لهذه الميزة';
  static const String qiblaDirection = 'اتجاه القبلة';
  static const String qiblaErrorLoad =
      'لم نتمكن من تحميل مواقيت الصلاة. ساعدنا في تحسين التطبيق بإرسال بلاغ عن المشكلة، جزاك الله خيراً';
  static const String qiblaCompassGuidelines = 'إرشادات استخدام البوصلة';
  static const String qiblaCompassNoSensor =
      'إذا لم يتحرك السهم، فجهازك قد لا يحتوي على حساس البوصلة';
  static const String qiblaBestAccuracy = 'للحصول على أفضل دقة:';
  static const String qiblaGuideline1 =
      'ابعد أي أجهزة إلكترونية أو جراب به معدن عن الهاتف (سماعات، ساعة ذكية، إلخ)';
  static const String qiblaGuideline2 = 'ضع الهاتف على سطح مستوٍ';
  static const String qiblaGuideline3 =
      'لف الهاتف ببطء حتى يثبت السهم على اتجاه القبلة';
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

  static const String noInternet = 'يرجى التحقق من اتصالك بالإنترنت';
  static const String ourFault = 'نعتذر، هناك خلل تقني من جانبنا جاري إصلاحه';
  static const String missingDataError =
      'لا توجد بيانات متوفرة حالياً، يرجى المحاولة لاحقاً';

  // Location Manager
  static const String enableLocationServiceTitle = 'تفعيل خدمة الموقع';
  static const String enableLocationServiceMessage =
      'نحتاج إلى تفعيل خدمة الموقع للمتابعة في التطبيق.';
  static const String enable = 'تفعيل';
  static const String locationPermissionTitle = 'إذن الموقع';
  static const String locationPermissionMessage =
      'نحتاج إلى إذن الوصول إلى موقعك للحصول على أفضل تجربة.';
  static const String allow = 'السماح';
  static const String locationPermissionPermanentlyDeniedTitle =
      'إذن الموقع مرفوض نهائيًا';
  static const String locationPermissionPermanentlyDeniedMessage =
      'لقد رفضت إذن الموقع عدة مرات، ولن يظهر الطلب مرة أخرى.\nيجب فتح إعدادات التطبيق للسماح بالإذن.';
  static const String openAppSettings = 'فتح إعدادات التطبيق';
  static const String locationEnabledCheckError = 'تعذر التحقق من حالة الـ GPS';
  static const String openLocationSettingsError = 'تعذر فتح إعدادات الموقع';
  static const String locationPermissionCheckError =
      'تعذر التحقق من أذونات الموقع';
  static const String locationPermissionRequestError = 'تعذر طلب إذن الموقع';
  static const String locationNameFetchError = 'تعذر جلب اسم المنطقة';
  static const String waitingForLocation = 'بانتظار تحديد الموقع...';
  static const String locationStoredCheckSuccess = 'تم التحقق من الموقع المخزن';
  static const String locationSavedSuccess = 'تم حفظ موقعك بنجاح';
  static const String needsLocationService = 'يرجى تفعيل خدمة الموقع للمتابعة';
  static const String needsLocationPermission = 'يرجى السماح بالوصول إلى موقعك';
  static const String locationDisabled = 'خدمة الموقع معطلة';
  static const String locationPermissionDenied = 'تم رفض إذن الموقع';
  static const String success = 'تم بنجاح';

  // Feedback
  static const String feedbackTitle = 'اقتراح أو شكوى';
  static const String feedbackSubTitle = 'ساعدنا في التحسين';
  static const String details = 'تفاصيل';
  static const String send = 'إرسال';
  static const String letContactInfo = 'وسيلة تواصل (اختياري)';
  static const String emailOrPhone = 'بريد إلكتروني أو رقم هاتف';
  static const String writeDetails = 'اكتب وصفاً تفصيلياً ...';
  static const String writeDetailsLateset10Characters =
      'الرجاء كتابة 10 أحرف على الأقل';
  static const String thanksForYourContribution =
      'شكراً لمساهمتك في تحسين تطبيق ${AppConstants.appName}، جزاك الله خيراً.';
  static const String webNotSupported = 'هذه الميزة غير متاحة علي الويب حالياً';
  static const String qiblaWebNotSupported =
      'ميزة القبلة غير متاحة علي الويب و الايفون حالياً';
  static const String salatAlaNabiWebNotSupported =
      'ميزة الصلاة علي النبي غير متاحة علي الويب و الايفون حالياً';
  static const String hadithSearchWebNotSupported =
      'ميزة البحث في الاحاديث غير متاحة علي الويب و الايفون حالياً';

  // Hadith Search
  static const String hadiths = 'الأحاديث';
  static const String noResults = 'لا توجد نتائج';
  static const String addedToFavorites = 'تمت الإضافة للمفضلة';
  static const String removedFromFavorites = 'تمت الإزالة من المفضلة';
  static const String myFavoriteHadiths = 'أحاديثي المفضلة';
  static const String noFavoritesYet = 'لا توجد أحاديث في المفضلة بعد';
  static const String searchSearchHint = 'ابحث عن حديث (حروف عربية فقط)...';
  static const String suggestedTopics = 'مواضيع مقترحة للبحث';
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
  static const String developerDashboard = 'لوحة التحكم';
  static const String deletedSuccessfully = 'تم الحذف بنجاح';
  static const String deleteConfirmation = 'هل أنت متأكد من الحذف؟';
  static const String delete = 'حذف';
  static const String cancel = 'إلغاء';
  static const String copy = 'نسخ';
  static const String adminReply = 'رد الإدارة';
  static const String noFeedbacksYet = 'لا توجد اقتراحات أو شكاوى بعد';
  static const String features = 'ميزات';
  static const String feature = 'ميزة';
  static const String azkarHeader = 'ألاذكار';
  static const String showMore = 'عرض المزيد';
  static const String settings = 'الإعدادات';
  static const String preferences = 'التفضيلات';
  static const String prayerSettings = 'إعدادات مواقيت الصلاة';
  static const String shareReward = 'كن شريكاً في الأجر';
  static const String personallyWithMe = 'معي شخصيا';
  static const String contactPerBusiness = 'تواصل لأغراض العمل';
  static const String shareAndRate = 'شارك وقيم';
  static const String rateApp = 'قيم التطبيق';
  static const String shareApp = 'مشاركة التطبيق';
  static String shareAppText(String link) => 'حمل تطبيق سَـنَـا الآن:\n$link';
  static String shareWebAppText(String link) =>
      'تصفح نسخة الويب من تطبيق سَـنَـا:\n$link';
  static const String followAppOn = 'تابع التطبيق علي';
  static const String charityForMuslims = 'صدقة جاريه للمسلمين';
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
      'تطبيق: $version (إصدار $build)';

  static const String dailyWisdomHeader = 'أنوار اليوم';
  static const String quranKareem = 'القرآن الكريم';

  // Secret Pin Dialog
  static const String adminPanel = 'لوحة الإدارة';
  static const String adminSectionRequirePin =
      'تتطلب الوصول إلى هذه الشاشة إدخال رمز الأمان';
  static const String invalidPin = 'عفواً، الرمز غير صحيح';
  static const String wrongPin = 'رمز خاطئ';
  static const String login = 'دخول';

  // Prayer & Sunnah
  static const String confirmedSunnah = 'السنن المؤكدة';
  static const String noSunnahForPrayer = 'لا توجد سنن مؤكدة لهذه الصلاة';

  // Salat Ala Nabi
  static const String salawatReminderTitle = 'التذكير بالصلاة على النبي ﷺ';
  static const String saveChanges = 'حفظ التغييرات';
  static const String changesSavedSuccess = 'تم حفظ التغييرات بنجاح';
  static const String saveChangesQuestion = 'حفظ التغييرات؟';
  static const String unsavedChangesMessage =
      'لديك تغييرات غير محفوظة. هل تريد حفظها؟';
  static const String discard = 'تجاهل';
  static const String maxIntervalError = 'الحد الأقصى 120 دقيقة';
  static const String minIntervalError = 'الحد الأدنى 15 دقيقة';
  static const String intervalQuestion = 'التكرار كل كم دقيقة (تقريباً)';
  static const String intervalRangeNote =
      'المدة بين 15-120 دقيقة • قد يختلف التوقيت الفعلي قليلاً';
  static String minutes(int mins) => '$mins دقيقة';
  static const String enableReminder = 'تفعيل التذكير';
  static const String importantNotes = 'ملاحظات مهمة';
  static const String reminderDelayWarning =
      'قد يتأخر التذكير أحياناً بسبب قيود نظام الهاتف';
  static const String ensureServiceContinuity = 'لضمان استمرار الخدمة:';
  static const String openAppDaily = 'افتح التطبيق يومياً';
  static const String reactivateServiceOccasionally =
      'أعد تفعيل الخدمة من حين لآخر';
  static const String checkAppSettings =
      'تأكد من عدم إيقاف التطبيق من إعدادات الهاتف';
  static const String selectTime = 'اختر الوقت';
  static const String ok = 'موافق';
  static const String am = 'صباحاً';
  static const String pm = 'مساءً';
  static const String reminderWorkingHours = 'ساعات تفعيل التذكير';
  static const String allDay = 'طوال اليوم';
  static const String twentyFourHours = '24 ساعة';
  static const String from10amTo10pm = 'من 10 صباحاً إلى 10 مساءً';
  static const String tenAmTenPm = '10 ص - 10 م';
  static const String selectCustomTime = 'حدد الوقت بنفسك';
  static const String from = 'من';
  static const String to = 'إلى';

  // Teaching Prayer
  static String copiedTopicContent(String topic) => 'تم نسخ محتوى $topic';
  static const String copyContent = 'نسخ المحتوى';
  static const String fromTeachingPrayer = 'من تعليم الصلاة';

  // Prayer & Timing
  static const String nextPrayerRemaining = 'متبقي على';
  static const String currentPrayerTime = 'حان وقت';
  static const String gracePeriodTitle = 'دقائق متبقية من الوقت';
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
  static const String noVirtueAvailable = 'لا يوجد نص فضل متاح حالياً.';
  static const String openingPrayerAction = 'دعاء الاستفتاح';
  static const String postPrayerAzkarAction = 'أذكار بعد الصلاة';
  static const String contentCopiedTitle = 'تم نسخ المحتوى بنجاح';
  static const String prayerSettingsTitle = 'إعدادات مواقيت الصلاة';
  static const String calculationMethodTitle = 'طريقة الحساب';
  static const String madhabTitle = 'المذهب الفقهي';
  static const String openingPrayerCategoryId = '23';
  static const String postPrayerAzkarCategoryId = '1';
  static const String religiousEventsDepartment = 'من المناسبات الإسلامية';
  static const String prayerVirtuesDepartment = 'من فضل الأوقات';
  static const String prayerStatusShareImageName = 'prayer_status_share';
  static const String nobleHadith = 'حديث شريف';
  static const String shareAsImage = 'مشاركة كصورة';
}
