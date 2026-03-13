import 'package:flutter/widgets.dart';

abstract class IAnalyticsService {
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  });

  Future<void> setUserProperty({
    required String name,
    required String? value,
  });

  Future<void> setUserId(String? id);

  Future<void> setCurrentScreen(String screenName);

  NavigatorObserver getObserver();
}
