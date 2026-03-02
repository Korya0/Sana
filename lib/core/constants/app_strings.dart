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
  static const String unknownLocation = 'غير معروف';
  static const String locationError =
      'نحتاج للوصول إلى موقعك لتحديد القبلة ومواقيت الصلاة';

  // Qibla
  static const String sensorError =
      'هاتفك قد لا يدعم الحساسات اللازمة لهذه الميزة';

  // Common Error Handling
  static const String noInternet = 'يرجى التحقق من اتصالك بالإنترنت';
  static const String ourFault = 'نعتذر، هناك خلل تقني من جانبنا جاري إصلاحه';
  static const String missingDataError =
      'لا توجد بيانات متوفرة حالياً، يرجى المحاولة لاحقاً';

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

  // Developer Dashboard
  static const String developerDashboard = 'لوحة التحكم';
  static const String deletedSuccessfully = 'تم الحذف بنجاح';
  static const String deleteConfirmation = 'هل أنت متأكد من الحذف؟';
  static const String delete = 'حذف';
  static const String cancel = 'إلغاء';
  static const String copy = 'نسخ';
  static const String adminReply = 'رد الإدارة';
  static const String noFeedbacksYet = 'لا توجد اقتراحات أو شكاوى بعد';
  static const String deleteFeedbackConfirmationMessage =
      'هل أنت متأكد من رغبتك في حذف هذا الاقتراح بشكل نهائي؟';
  static const String userSuggestion = 'اقتراح مستخدم';
  static const String unknown = 'غير معروف';
  static const String unknownDevice = 'جهاز غير معروف';
  static const String unknownOS = 'نظام غير معروف';
  static String appVersionWithBuild(String version, String build) =>
      'تطبيق: $version (إصدار $build)';

  // Prayer & Sunnah
  static const String confirmedSunnah = 'السنن المؤكدة';
  static const String noSunnahForPrayer = 'لا توجد سنن مؤكدة لهذه الصلاة';
}
