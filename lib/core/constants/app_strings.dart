import 'package:sana/core/constants/app_constants.dart';

class AppStrings {
  const AppStrings._();

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
  static const String serverError =
      'نعتذر، هناك خلل تقني من جانبنا جاري إصلاحه';
  static const String cacheError = 'حدث خطأ أثناء تحميل البيانات المحلية';
  static const String missingDataError =
      'لا توجد بيانات متوفرة حالياً، يرجى المحاولة لاحقاً';
  static const String unknownError =
      'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى';

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
}
