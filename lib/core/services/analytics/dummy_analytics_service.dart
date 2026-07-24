import 'package:flutter/widgets.dart';
import 'package:sana/core/services/analytics/analytics_service.dart';

class DummyAnalyticsService implements AnalyticsService {
  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {}

  @override
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {}

  @override
  Future<void> setUserId(String? id) async {}

  @override
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {}

  @override
  NavigatorObserver getObserver() => NavigatorObserver();
}
