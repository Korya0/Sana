import 'package:flutter/widgets.dart';

abstract interface class IAnalyticsService {
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  });

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  });

  Future<void> setUserProperty({
    required String name,
    required String? value,
  });

  Future<void> setUserId(String? id);

  NavigatorObserver getObserver();
}
