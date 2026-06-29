import 'package:flutter/foundation.dart';

class AppLinks {
  const AppLinks._();
  static const String facebook =
      'https://www.facebook.com/profile.php?id=61585568923187';
  static const String whatsapp = 'https://wa.me/201065171195';
  static const String playStore =
      'https://play.google.com/store/apps/details?id=com.sana.muslim.app';
  static const String webApp = 'https://sana0.vercel.app/';

  /// Returns the appropriate store link for the current platform
  static String get storeLink {
    if (kIsWeb) return webApp;
    return playStore;
  }
}
