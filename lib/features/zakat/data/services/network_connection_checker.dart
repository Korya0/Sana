import 'dart:io';

/// فاحص الاتصال بالإنترنت.
class NetworkConnectionChecker {
  const NetworkConnectionChecker();

  /// التحقق من توفر اتصال فعلي بالإنترنت عبر DNS lookup.
  Future<bool> hasConnection() async {
    try {
      final lookup = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 4));
      if (lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (_) {
      try {
        final lookupFallback = await InternetAddress.lookup(
          'one.one.one.one',
        ).timeout(const Duration(seconds: 4));
        if (lookupFallback.isNotEmpty &&
            lookupFallback[0].rawAddress.isNotEmpty) {
          return true;
        }
      } catch (_) {
        return false;
      }
    }
    return false;
  }
}
