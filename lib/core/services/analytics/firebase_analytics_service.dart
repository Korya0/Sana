import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:sana/core/services/analytics/analytics_service.dart';

class FirebaseAnalyticsServiceImpl implements IAnalyticsService {
  FirebaseAnalyticsServiceImpl(this._analytics);
  final FirebaseAnalytics _analytics;

  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  @override
  Future<void> setUserId(String? id) async {
    await _analytics.setUserId(id: id);
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  @override
  NavigatorObserver getObserver() {
    return FirebaseAnalyticsObserver(analytics: _analytics);
  }
}
