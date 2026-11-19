import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/di/app_initializer.dart';
import 'package:sana/sana_app.dart';

// App entry
void main() async {
  await AppInitializer.initialize();

  runApp(
    // Debug preview
    kDebugMode && kIsWeb
        ? DevicePreview(builder: (context) => const SanaApp())
        // Release
        : const SanaApp(),
  );
}
