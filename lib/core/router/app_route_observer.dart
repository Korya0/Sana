import 'package:flutter/widgets.dart';

final class AppRouteObserver extends RouteObserver<ModalRoute<dynamic>> {
  AppRouteObserver._();

  static final AppRouteObserver instance = AppRouteObserver._();
}
