// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

abstract class ShareService {
  Future<void> shareImage(Uint8List imageBytes, {String? text});
}

class ShareServiceImpl implements ShareService {
  @override
  Future<void> shareImage(Uint8List imageBytes, {String? text}) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/share_zikr_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles([XFile(file.path)], text: text);
    } catch (e) {
      debugPrint('Error sharing image: $e');
    }
  }
}
