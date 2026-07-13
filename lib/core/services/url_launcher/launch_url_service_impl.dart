import 'dart:async';

import 'package:sana/core/services/url_launcher/i_launch_url_service.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:url_launcher/url_launcher.dart';

/// Implementation of [ILaunchUrlService] using the url_launcher package.
class LaunchUrlServiceImpl implements ILaunchUrlService {
  const LaunchUrlServiceImpl();

  @override
  Future<bool> launch(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      }
      return false;
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.localError('LaunchUrl Error', error: e, stackTrace: stack),
      );
      return false;
    }
  }
}
